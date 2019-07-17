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

    func completed(with images : [UIImage])
    func select(atPosition: Int, select: Bool)
}

class GalleryViewModel{

    var reloadCollection : (()->())?

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
        return CGSize(width: UIScreen.main.bounds.size.width/3.0, height: UIScreen.main.bounds.size.width/3.0)
    }

    var shouldEnableDone : Bool{
        return !selectedAssets.isEmpty
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
        var tempImages = [UIImage]()

        let options = PHImageRequestOptions()
        options.isNetworkAccessAllowed = true

        selectedAssets.forEach { (asset) in
            group.enter()
            cachingImageManager.requestImage(for: asset, targetSize: PHImageManagerMaximumSize, contentMode: .aspectFill, options: options, resultHandler: {(image, nil) in

                if let tempImage = image{
                    tempImages.append(tempImage)
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

        if let position = selectedAssets.firstIndex(where: {$0 == item}){
            selectedAssets.remove(at: position)
            delegate?.select(atPosition: position, select: false)
        }else{
            selectedAssets.append(item)
            delegate?.select(atPosition: position, select: true)
        }
    }
}
