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
    func photosPreviousPage()
}

class PhotosSelectionViewController: BaseViewController, ImagePickerProtocol {

    @IBOutlet weak var nextButton: UIButton!
    @IBOutlet weak var previousButton: UIButton!
    @IBOutlet weak var mainCollectionView: UICollectionView!

    var isUploading : Bool{
        return viewModel.isUploading
    }

    var create : CreateModel?
    let viewModel = PhotoSelectionViewModel()
    weak var delegate : PhotoSelectionViewControllerDelegate?

    override func viewDidLoad() {
        super.viewDidLoad()

        initialSetup()
    }

    override func viewDidLayoutSubviews() {

        super.viewDidLayoutSubviews()
        nextButton.layer.cornerRadius = nextButton.bounds.height/2.0
        previousButton.layer.cornerRadius = previousButton.bounds.height/2.0
    }

    //MARK:- IBAction
    @IBAction func nextAction(_ sender: UIButton) {

        viewModel.startUpload()
        delegate?.userDidPressContinue()
    }

    @IBAction func previousAction(_ sender: UIButton) {

        delegate?.photosPreviousPage()
    }

    //MARK:- Private
    private func initialSetup(){

        mainCollectionView.register(ImageCollectionViewCell.nib, forCellWithReuseIdentifier: ImageCollectionViewCell.identifier)

        previousButton.configureArrowButton(name: .arrowLeft)
        nextButton.configureArrowButton(name: .arrowRight)

        viewModel.delegate = self
    }
}

extension PhotosSelectionViewController : UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout{

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForHeaderInSection section: Int) -> CGSize {

        let indexPath : IndexPath = [0, section]
        let headerView = collectionView.dequeueReusableSupplementaryView(ofKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: PhotoHeaderCollectionReusableView.identifier, for: indexPath)
        return headerView.systemLayoutSizeFitting(CGSize(width: collectionView.bounds.width, height: UIView.layoutFittingExpandedSize.height), withHorizontalFittingPriority: .required, verticalFittingPriority: .fittingSizeLevel)
    }

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {

        #warning("add mosaic layout")
        let width = collectionView.bounds.width/3.0
        return CGSize(width: width, height: width)
    }

    func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {

        guard let header = collectionView.dequeueReusableSupplementaryView(ofKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: PhotoHeaderCollectionReusableView.identifier, for: indexPath) as? PhotoHeaderCollectionReusableView else {return UICollectionReusableView(frame: CGRect.zero)}

        return header
    }

    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {

        //+1 to show button
        return viewModel.selectedCount + 1
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {

        if indexPath.item == 0{

            return configureButtonCell(indexPath: indexPath)
        }else{

            guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: ImageCollectionViewCell.identifier, for: indexPath) as? ImageCollectionViewCell else { return UICollectionViewCell(frame: CGRect.zero) }

            let image = viewModel.dataSource[indexPath.item - 1]
            cell.updateDeleteLoaderCell(image : image.image, animate: image.isUploading)

            cell.deleteAction = { [weak self] in

                self?.viewModel.delete(position: indexPath.item - 1)

                collectionView.performBatchUpdates({
                    collectionView.deleteItems(at: [indexPath])
                }, completion: { (finished) in
                    collectionView.reloadData()
                })

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

    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {

        if indexPath.item == 0{
            openImagePickerSheet(cameraAction: { [weak self] in

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
                        let nav = FlowManager.createNavigationController(viewController)
                        self?.present(nav, animated: true, completion: nil)
                    }else{
                        //dont show toast if permission was asked this time
                        if !authorizationRequested{
                            self?.showRedirectAlert(StringConstants.oops.localized, withMessage: StringConstants.gallery_access.localized)
                        }
                    }
                }
            }, removePhoto: nil)
        }
    }

    private func configureButtonCell(indexPath : IndexPath) -> UICollectionViewCell{

        guard let cell = mainCollectionView.dequeueReusableCell(withReuseIdentifier: ButtonCollectionViewCell.identifier, for: indexPath) as? ButtonCollectionViewCell else {
            return UICollectionViewCell(frame: CGRect.zero)
        }
        return cell
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

        //remove all images selected from gallery in model as we are getting new ones.
        #warning("Apply better logic")
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
    }
}
