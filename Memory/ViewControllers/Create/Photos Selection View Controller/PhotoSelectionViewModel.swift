//
//  PhotoSelectionViewModel.swift
//  Memory
//
//  Created by Mayank Rikh on 18/07/19.
//  Copyright © 2019 Mayank Rikh. All rights reserved.
//

import SDWebImage
import UIKit

protocol PhotolSelectionViewModelDelegate : BaseProtocol {

    func uploadBegan(position : Int)
    func uploadEnded(position : Int)
    func uploadError(position : Int)
    func completedUpload(with images : [String])
}

class PhotoSelectionViewModel{

    private (set) var dataSource = [ImageModel]()

    lazy var uploadManager : ImageUploadManager = ImageUploadManager()
    weak var delegate : PhotolSelectionViewModelDelegate?

    var selectedCount : Int{
        return dataSource.count
    }

    var isSelectedEmpty : Bool{
        return dataSource.isEmpty
    }

    func removeGalleryImages(){
        dataSource.removeAll(where: {$0.localId != nil})
    }

    func add(image : UIImage, id : String?){

        dataSource.append(ImageModel(image: image, localId: id))
    }

    func add(images : [ImageModel]){

        dataSource.append(contentsOf: images)
    }

    func startUpload(){

        let group = DispatchGroup()
        var imageUrls = [String]()

        for (index, model) in dataSource.enumerated(){
            group.enter()

            //TODO:- maintain order of upload response urls
            delegate?.uploadBegan(position : index)
            uploadManager.uploadImage(model.image, forItemWithTag: index, periodProgress: nil) { [weak self] (tag, urlString, error) in

                guard let strongSelf = self else { return }
                strongSelf.delegate?.uploadEnded(position: tag)
                if let tempString = urlString{

                    imageUrls.append(tempString)
                    SDImageCache.shared.clearMemory()
                    SDImageCache.shared.store(Utilities.resizeImage(model.image), forKey: tempString, completion: nil)
                }else{
                    strongSelf.delegate?.errorOccurred(errorString: error?.localizedDescription)
                    strongSelf.delegate?.uploadError(position: tag)
                }

                group.leave()
            }
        }

        group.notify(queue: .main) { [weak self] in
            self?.delegate?.completedUpload(with: imageUrls)
        }
    }
}
