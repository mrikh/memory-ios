//
//  PhotosSelectionViewController.swift
//  Memory
//
//  Created by Mayank Rikh on 17/07/19.
//  Copyright © 2019 Mayank Rikh. All rights reserved.
//

import CropViewController
import UIKit

protocol PhotoSelectionViewControllerDelegate : AnyObject {

    func userDidPressContinue()
}

class PhotosSelectionViewController: BaseViewController, ImagePickerProtocol {

    @IBOutlet weak var mainCollectionView: UICollectionView!
    @IBOutlet weak var cardView: UIView!
    @IBOutlet weak var questionLabel: UILabel!

    var create : CreateModel?
    let viewModel = PhotoSelectionViewModel()
    weak var delegate : PhotoSelectionViewControllerDelegate?

    override func viewDidLoad() {
        super.viewDidLoad()

        initialSetup()
    }

    //MARK:- Private
    private func initialSetup(){

        questionLabel.text = StringConstants.select_venue_photos.localized
        questionLabel.textColor = Colors.bgColor
        questionLabel.font = CustomFonts.avenirHeavy.withSize(18.0)

        mainCollectionView.layer.cornerRadius = 10.0
        cardView.layer.cornerRadius = 10.0
        cardView.addShadow(3.0, opacity: 0.3)

        mainCollectionView.register(ImageCollectionViewCell.nib, forCellWithReuseIdentifier: ImageCollectionViewCell.identifier)

        viewModel.delegate = self
    }
}

extension PhotosSelectionViewController : UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout{

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {

        if indexPath.item == viewModel.selectedCount{
            if viewModel.isSelectedEmpty{
                return CGSize(width : collectionView.bounds.width, height : collectionView.bounds.height - 90.0)
            }else{
                return CGSize(width : collectionView.bounds.width, height : 90.0)
            }
        }else{
            let width = collectionView.bounds.width/3.0
            return CGSize(width : width, height : width)
        }
    }

    func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {

        guard let header = collectionView.dequeueReusableSupplementaryView(ofKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: PhotoHeaderCollectionReusableView.identifier, for: indexPath) as? PhotoHeaderCollectionReusableView else {return UICollectionReusableView(frame: CGRect.zero)}

        header.action = { [weak self] in

            self?.openImagePickerSheet(cameraAction: { [weak self] in

                if let count = self?.viewModel.selectedCount, count >= ValidationConstants.imageCountLimit {
                    self?.showAlert(StringConstants.alert.localized, withMessage: StringConstants.count_limit.localized, withCompletion: nil)
                    return
                }

                self?.showImagePicker(showFront : false, showCamera : true)
            }, galleryAction: { [weak self] in

                self?.checkGalleryAuthorization { [weak self] (granted, authorizationRequested) in
                    if granted{
                        let viewController = GalleryViewController.instantiate(fromAppStoryboard: .Common)
                        viewController.viewModel = GalleryViewModel(selectedImages: self?.viewModel.dataSource)
                        viewController.delegate = self
                        let navigationController = FlowManager.createNavigationController(viewController)
                        self?.present(navigationController, animated: true, completion: nil)
                    }else{
                        //dont show toast if permission was asked this time
                        if !authorizationRequested{
                            self?.showRedirectAlert(StringConstants.oops.localized, withMessage: StringConstants.gallery_access.localized)
                        }
                    }
                }
            }, removePhoto: nil)
        }

        return header
    }

    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {

        //+1 to show button
        return viewModel.selectedCount + 1
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {

        if indexPath.item == viewModel.selectedCount{

            return configureButtonCell(indexPath: indexPath)
        }else{

            guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: ImageCollectionViewCell.identifier, for: indexPath) as? ImageCollectionViewCell else { return UICollectionViewCell(frame: CGRect.zero) }

            let image = viewModel.dataSource[indexPath.item]
            cell.mainImageView.image = image.image
            cell.updateLoader(animate: image.isUploading)
            cell.deleteButton.isHidden = false

            cell.deleteAction = { [weak self] in

                self?.viewModel.delete(position: indexPath.item)

                if let empty = self?.viewModel?.isSelectedEmpty, empty{
                    collectionView.reloadData()
                }else{
                    collectionView.performBatchUpdates({
                        collectionView.deleteItems(at: [indexPath])
                    }, completion: { (finished) in
                        collectionView.reloadData()
                    })
                }

                if let tempString = image.urlString{

                    AWSHandler.deleteImage(withUrl: tempString, completion: { [weak self] (success, urlString) in
                        if !success{
                            self?.viewModel.add(images: [image])
                            self?.showAlert(StringConstants.alert.localized, withMessage: StringConstants.error_delete.localized, withCompletion: nil)
                            collectionView.reloadData()
                        }
                    })
                }
            }

            return cell
        }
    }

    private func configureButtonCell(indexPath : IndexPath) -> UICollectionViewCell{

        guard let cell = mainCollectionView.dequeueReusableCell(withReuseIdentifier: ButtonCollectionViewCell.identifier, for: indexPath) as? ButtonCollectionViewCell else { return UICollectionViewCell(frame: CGRect.zero) }

        if viewModel.isSelectedEmpty{

            cell.buttonAction = { [weak self] in
                self?.delegate?.userDidPressContinue()
            }

            cell.mainButton.setAttributedTitle(setupAttributedString(title: StringConstants.or_skip.localized), for: .normal)
        }else{

            cell.buttonAction = { [weak self] in
                self?.viewModel.startUpload()
                self?.delegate?.userDidPressContinue()
            }

            if !viewModel.movedPast{

                cell.mainButton.setAttributedTitle(setupAttributedString(title: StringConstants.continue.localized), for: .normal)
            }else{

                //user already did this step and came back
                cell.mainButton.setAttributedTitle(setupAttributedString(title: StringConstants.press_again.localized), for: .normal)
            }
        }

        return cell
    }

    private func setupAttributedString(title : String) -> NSAttributedString{

        let paragraph = NSMutableParagraphStyle()
        paragraph.alignment = .center
        return NSAttributedString(string : title, attributes : [.foregroundColor : Colors.bgColor, .font : CustomFonts.avenirHeavy.withSize(15.0), .underlineStyle : NSUnderlineStyle.single.rawValue, .paragraphStyle : paragraph])
    }
}

extension PhotosSelectionViewController : UIImagePickerControllerDelegate, UINavigationControllerDelegate{

    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {

        guard let image = info[.originalImage] as? UIImage else { return }

        let cropViewController = CropViewController(croppingStyle: .default, image: image)
        cropViewController.delegate = self
        picker.present(cropViewController, animated: false, completion: nil)
    }

    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {

        dismiss(animated: true, completion: nil)
    }
}

extension PhotosSelectionViewController : CropViewControllerDelegate{

    func cropViewController(_ cropViewController: CropViewController, didCropToImage image: UIImage, withRect cropRect: CGRect, angle: Int) {

        viewModel.add(image: image, id: nil)
        mainCollectionView.reloadData()
        dismiss(animated: true, completion: nil)
    }

    func cropViewController(_ cropViewController: CropViewController, didFinishCancelled cancelled: Bool) {

        dismiss(animated: true, completion: nil)
    }
}

extension PhotosSelectionViewController : GalleryViewControllerDelegate{

    func userDidSelect(images: [ImageModel]) {

        //TODO:- remove all images selected from gallery in model as we are getting new ones. Apply better logic
        viewModel.removeGalleryImages()

        viewModel.add(images: images)
        mainCollectionView.reloadData()
    }
}

extension PhotosSelectionViewController : PhotolSelectionViewModelDelegate{

    func uploadBegan(position: Int) {

        if let cell = mainCollectionView.cellForItem(at: [0, position]) as? ImageCollectionViewCell{
            cell.updateLoader(animate: true)
        }
    }

    func uploadEnded(position: Int) {

        if let cell = mainCollectionView.cellForItem(at: [0, position]) as? ImageCollectionViewCell{
            cell.updateLoader(animate: false)
        }
    }

    func completedUpload(with images: [ImageModel]) {

        create?.photos = images
        mainCollectionView.reloadData()
        showAlert(StringConstants.success.localized, withMessage: StringConstants.image_upload_success.localized, withCompletion : nil)
    }
}
