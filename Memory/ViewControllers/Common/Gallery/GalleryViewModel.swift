//
//  GalleryViewModel.swift
//  Memory
//
//  Created by Mayank Rikh on 17/07/19.
//  Copyright © 2019 Mayank Rikh. All rights reserved.
//

import Photos
import UIKit

protocol GalleryViewModelDelegate : BaseProtocol{

    func completed(with images : [ImageModel])
    func select(atPosition: Int, select: Bool)
}

class GalleryViewModel{

    var reloadCollection : (()->())?

    //total count taken seperately as per current logic when user clicks from camera, it doesnt have phasset object so selected assets wont contain it
    private var totalCount = 0
    private var preSelectedImages : [ImageModel]?

    private lazy var cachingImageManager : PHCachingImageManager = {
        return PHCachingImageManager()
    }()

    private var assets : [PHAsset] = []
    private lazy var selectedAssets : [PHAsset] = {
        return [PHAsset]()
    }()

    weak var delegate : GalleryViewModelDelegate?

    var numberOfItems : Int{
        return assets.count
    }

    var cellSize : CGSize{
        let width = UIScreen.main.bounds.size.width/3.0
        return CGSize(width: width, height: width)
    }

    var isAnyAssetSelected : Bool{
        return !selectedAssets.isEmpty
    }

    convenience init(selectedImages : [ImageModel]?) {

        self.init()
        self.preSelectedImages = selectedImages
        totalCount = selectedImages?.count ?? 0
    }

    func isSelected(atPosition position : Int) -> Bool{
        return selectedAssets.contains(assets[position])
    }

    func fetchImage(atPosition position : Int, completion:@escaping(UIImage?)->()){

        cachingImageManager.requestImage(for: assets[position], targetSize: cellSize, contentMode: .aspectFill, options: PHImageRequestOptions()) { (image, nil) in
            DispatchQueue.main.async{
                completion(image)
            }
        }
    }

    func completeImageSelection(){

        delegate?.startLoader()

        let group = DispatchGroup()
        var tempImages = [ImageModel]()

        let options = PHImageRequestOptions()
        //i dont want to handle icloud images for not atleast, possible feature
        options.isNetworkAccessAllowed = false
        options.isSynchronous = true

        selectedAssets.forEach { (asset) in
            group.enter()
            cachingImageManager.requestImage(for: asset, targetSize: PHImageManagerMaximumSize, contentMode: .aspectFill, options: options, resultHandler: {(image, nil) in

                if let tempImage = image{
                    let model = ImageModel(image: tempImage, localId: asset.localIdentifier)
                    tempImages.append(model)
                }

                group.leave()
            })
        }

        group.notify(queue: .main) { [weak self] in
            self?.delegate?.stopLoader()
            self?.delegate?.completed(with: tempImages)
        }
    }

    /// Checks the authorization status of the Gallery and fetch the image assets
    func fetchAssestsFromPhotoLibrary(){

        let fetchOptions = PHFetchOptions()

        fetchOptions.sortDescriptors = [NSSortDescriptor(key:"creationDate", ascending: false)]
        guard let allPhotos = PHAsset.fetchAssets(with: .image, options: fetchOptions) as? PHFetchResult<AnyObject> else { return }

        if allPhotos.count > 0{
            delegate?.startLoader()
        }

        DispatchQueue.global(qos: .userInitiated).async { [weak self] in

            allPhotos.enumerateObjects { [weak self] (object, _, _) in

                if let phAsset = object as? PHAsset{
                    self?.assets.append(phAsset)

                    if let preSelected = self?.preSelectedImages{

                        if let _ = preSelected.firstIndex(where: { (image) -> Bool in
                            if let id = image.localId{
                                return id == phAsset.localIdentifier
                            }else{
                                return false
                            }
                        }){
                            self?.selectedAssets.append(phAsset)
                        }
                    }
                }
            }

            if let tempAssets = self?.assets{
                self?.cachingImageManager.startCachingImages(for: tempAssets, targetSize: PHImageManagerMaximumSize, contentMode: .aspectFit, options: nil )
            }

            DispatchQueue.main.async {

                self?.delegate?.stopLoader()
                self?.reloadCollection?()
            }
        }
    }

    func select(atPosition position : Int){

        let item = assets[position]

        if let index = selectedAssets.firstIndex(where: {$0 == item}){
            totalCount -= 1
            selectedAssets.remove(at: index)
            delegate?.select(atPosition: position, select: false)
        }else{

            if totalCount >= ValidationConstants.imageCountLimit {
                delegate?.errorOccurred(errorString: StringConstants.count_limit.localized)
                return
            }

            totalCount += 1
            selectedAssets.append(item)
            delegate?.select(atPosition: position, select: true)
        }
    }
}
