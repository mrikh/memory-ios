//
//  GalleryViewController.swift
//  Memory
//
//  Created by Mayank Rikh on 17/07/19.
//  Copyright © 2019 Mayank Rikh. All rights reserved.
//

import UIKit

class GalleryViewController: BaseViewController {

    @IBOutlet weak var mainCollectionView: UICollectionView!
    let viewModel = GalleryViewModel()

    override func viewDidLoad() {
        super.viewDidLoad()

        initialSetup()
    }

    override func viewWillAppear(_ animated: Bool) {

        super.viewWillAppear(animated)
        navigationController?.setNavigationBarHidden(false, animated: true)
    }

    //MARK:- Private
    private func initialSetup(){

        navigationItem.title = StringConstants.Gallery.localized

        mainCollectionView.register(GalleryCollectionViewCell.nib, forCellWithReuseIdentifier: GalleryCollectionViewCell.identifier)

        viewModel.fetchAssestsFromPhotoLibrary()
        viewModel.delegate = self

        viewModel.reloadCollection = { [weak self] in
            self?.mainCollectionView.reloadData()
        }

        let rightButton = UIBarButtonItem(title: StringConstants.Done.localized, style: .done, target: self, action: #selector(rightButtonTapped(_:)))
        rightButton.isEnabled = false
        navigationItem.rightBarButtonItem = rightButton
    }

    @objc func rightButtonTapped(_ sender : UIBarButtonItem){

        viewModel.completeImageSelection()
    }

    private func enableButton(){

        navigationItem.rightBarButtonItem?.isEnabled = viewModel.shouldEnableDone
    }
}

extension GalleryViewController : UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout{

    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {

        return viewModel.numberOfItems
    }

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {

        return viewModel.cellSize
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {

        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: GalleryCollectionViewCell.identifier, for: indexPath) as? GalleryCollectionViewCell else {return UICollectionViewCell()}

        if viewModel.showCamera && indexPath.item == 0{

            cell.configureForCameraCell()
        }else{

            viewModel.fetchImage(atPosition: indexPath.item) { (image) in
                cell.mainImageView.image = image
            }

            cell.updateContainerView(isSelected: viewModel.isSelected(atPosition: indexPath.item))
        }

        return cell
    }

    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {

        viewModel.select(atPosition: indexPath.item)
    }
}

extension GalleryViewController : GalleryViewModelDelegate{

    func addedNewItem(atPosition position : Int) {

        mainCollectionView.insertItems(at: [[0, position]])
    }

    func didSelectCamera() {

        openCamera(showFront: true)
    }

    func startSingleSelection(singleImageInfo: (image: UIImage, asset: PHAsset)) {

        viewModel.phAssetBeingCropped = singleImageInfo.asset

        let cropViewController = TOCropViewController(croppingStyle: .circular, image: singleImageInfo.image)
        cropViewController.delegate = self
        present(cropViewController, animated: true, completion: nil)
    }

    func startMultipleSelection(multipleImagesInfo: [(image: UIImage, asset: PHAsset)]) {
        #warning ("Show gallery")
    }

    func select(atPosition position: Int, select : Bool) {

        enableButton()

        guard let cell = mainCollectionView.cellForItem(at: [0, position]) as? GalleryCollectionViewCell else {return}
        cell.updateContainerView(isSelected: select)
    }
}

extension GalleryViewController : UIImagePickerControllerDelegate, UINavigationControllerDelegate{

    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {

        guard let image = info[.originalImage] as? UIImage else { return }
        viewModel.addImage(image)
        dismiss(animated: true, completion: nil)
    }
}

extension GalleryViewController : TOCropViewControllerDelegate{

    func cropViewController(_ cropViewController: TOCropViewController, didCropToImage image: UIImage, rect cropRect: CGRect, angle: Int) {

        dismiss(animated: true, completion: nil)
        navigationController?.popViewController(animated: false)

        if let tempAsset = viewModel.phAssetBeingCropped{
            completedSelection?([(image : image, asset : tempAsset)])
        }
    }

    func cropViewController(_ cropViewController: TOCropViewController, didFinishCancelled cancelled: Bool) {

        dismiss(animated: true, completion: nil)
    }
}
