//
//  GalleryViewController.swift
//  Memory
//
//  Created by Mayank Rikh on 17/07/19.
//  Copyright © 2019 Mayank Rikh. All rights reserved.
//

import FontAwesome_swift
import UIKit

protocol GalleryViewControllerDelegate : AnyObject{

    func userDidSelect(images : [ImageModel])
}

class GalleryViewController: BaseViewController {

    @IBOutlet weak var mainCollectionView: UICollectionView!
    var viewModel = GalleryViewModel()
    weak var delegate : GalleryViewControllerDelegate?

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

        navigationItem.title = StringConstants.gallery.localized
        mainCollectionView.register(ImageCollectionViewCell.nib, forCellWithReuseIdentifier: ImageCollectionViewCell.identifier)

        viewModel.reloadCollection = { [weak self] in
            self?.mainCollectionView.reloadData()
        }

        viewModel.delegate = self
        viewModel.fetchAssestsFromPhotoLibrary()

        let rightButton = UIBarButtonItem(image: UIImage.fontAwesomeIcon(name: FontAwesome.check, style: .solid, textColor: Colors.black, size: CGSize(width: 35.0, height : 35.0)), style: .plain, target: self, action: #selector(rightButtonTapped(_:)))
        rightButton.isEnabled = false
        navigationItem.rightBarButtonItem = rightButton

        let leftButton = UIBarButtonItem(image: UIImage.fontAwesomeIcon(name: FontAwesome.times, style: .solid, textColor: Colors.black, size: CGSize(width: 35.0, height : 35.0)), style: .plain, target: self, action: #selector(backButtonTapped(_:)))
        navigationItem.leftBarButtonItem = leftButton
    }

    @objc func rightButtonTapped(_ sender : UIBarButtonItem){

        viewModel.completeImageSelection()
    }

    @objc func backButtonTapped(_ sender : UIBarButtonItem){

        viewModel.stopCaching()
        dismiss(animated: true, completion: nil)
    }

    private func enableButton(){

        navigationItem.rightBarButtonItem?.isEnabled = viewModel.isAnyAssetSelected
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

        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: ImageCollectionViewCell.identifier, for: indexPath) as? ImageCollectionViewCell else { return UICollectionViewCell(frame: CGRect.zero) }

        viewModel.fetchImage(atPosition: indexPath.item) { (image) in
            cell.mainImageView.image = image
        }

        cell.configure(currentSelected: viewModel.isSelected(atPosition: indexPath.item), animated : false)

        return cell
    }

    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {

        viewModel.select(atPosition: indexPath.item)
    }
}

extension GalleryViewController : GalleryViewModelDelegate{

    func completed(with images: [ImageModel]) {

        viewModel.stopCaching()
        delegate?.userDidSelect(images: images)
        dismiss(animated: true, completion: nil)
    }

    func select(atPosition position: Int, select : Bool) {

        enableButton()

        guard let cell = mainCollectionView.cellForItem(at: [0, position]) as? ImageCollectionViewCell else {return}
        cell.configure(currentSelected: select, animated: true)
    }
}
