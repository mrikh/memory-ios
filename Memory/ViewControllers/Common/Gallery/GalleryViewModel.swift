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
    private var isFetching = false

    private lazy var cachingImageManager : PHCachingImageManager = {
        let manager = PHCachingImageManager()
        manager.allowsCachingHighQualityImages = false
        return manager
    }()

    private var assets : PHFetchResult<PHAsset>?
    private lazy var selectedAssets : [PHAsset] = {
        return [PHAsset]()
    }()

    weak var delegate : GalleryViewModelDelegate?

    var numberOfItems : Int{
        return assets?.count ?? 0
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

        if let item = assets?.object(at: position){
            return selectedAssets.contains(item)
        }

        return false
    }

    func fetchImage(atPosition position : Int, completion:@escaping(UIImage?)->()){

        guard let image = assets?.object(at: position) else {return}

        let options = PHImageRequestOptions()
        options.isSynchronous = false
        options.isNetworkAccessAllowed = false
        cachingImageManager.requestImage(for: image, targetSize: cellSize, contentMode: .aspectFill, options: options) { (image, nil) in
            DispatchQueue.main.async{
                completion(image)
            }
        }
    }


    // Checks the authorization status of the Gallery and fetch the image assets
    func fetchAssestsFromPhotoLibrary(){

        let fetchOptions = PHFetchOptions()

        fetchOptions.sortDescriptors = [NSSortDescriptor(key:"creationDate", ascending: false)]
        let allPhotos = PHAsset.fetchAssets(with: .image, options: fetchOptions)
        self.assets = allPhotos

        if allPhotos.count > 0{
            delegate?.startLoader()
        }

        if let pre = preSelectedImages{
            let idArray = pre.map({$0.localId ?? ""})
            let temp = PHAsset.fetchAssets(withLocalIdentifiers: idArray, options: nil)
            temp.enumerateObjects { [weak self] (asset, _, _) in
                self?.selectedAssets.append(asset)
            }
        }

        DispatchQueue.main.async { [weak self] in
            self?.isFetching = false
            self?.delegate?.stopLoader()
            self?.reloadCollection?()
        }
    }

    func select(atPosition position : Int){

        guard let item = assets?.object(at: position) else {return}

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

    func completeImageSelection(){

        delegate?.startLoader()

        let group = DispatchGroup()
        var tempImages = [ImageModel]()

        let options = PHImageRequestOptions()
        #warning("i dont want to handle icloud images for not atleast, possible feature")
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

    func stopCaching(){

        cachingImageManager.stopCachingImagesForAllAssets()
    }
}
