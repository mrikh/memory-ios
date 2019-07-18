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
    func completedUpload(with images : [ImageModel])
}

class PhotoSelectionViewModel{

    private (set) var dataSource = [ImageModel]()

    lazy var uploadManager : ImageUploadManager = ImageUploadManager()
    weak var delegate : PhotolSelectionViewModelDelegate?

    //this is taken as a hack to determine if user has moved past this feature to update the title of button below
    var movedPast : Bool = false

    var selectedCount : Int{
        return dataSource.count
    }

    var isSelectedEmpty : Bool{
        return dataSource.isEmpty
    }

    func delete(position : Int){
        dataSource.remove(at: position)
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

        movedPast = true
        let group = DispatchGroup()
        
        for (index, model) in dataSource.enumerated(){

            if model.urlString != nil { continue }

            group.enter()

            //TODO:- maintain order of upload response urls
            delegate?.uploadBegan(position : index)
            dataSource[index].isUploading = true
            
            uploadManager.uploadImage(model.image, forItemWithTag: index, periodProgress: nil) { [weak self] (tag, urlString, error) in

                guard let strongSelf = self else { return }
                strongSelf.delegate?.uploadEnded(position: tag)
                if let tempString = urlString{

                    strongSelf.dataSource[index].urlString = tempString
                    SDImageCache.shared.clearMemory()
                    SDImageCache.shared.store(Utilities.resizeImage(model.image), forKey: tempString, completion: nil)
                }else{
                    strongSelf.delegate?.errorOccurred(errorString: StringConstants.error_upload.localized)
                }

                strongSelf.dataSource[index].isUploading = false
                group.leave()
            }
        }

        group.notify(queue: .main) { [weak self] in
            self?.delegate?.completedUpload(with: self?.dataSource ?? [ImageModel]())
        }
    }
}
