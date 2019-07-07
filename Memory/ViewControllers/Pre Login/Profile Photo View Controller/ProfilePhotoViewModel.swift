//
//  ProfilePhotoViewModel.swift
//  Memory
//
//  Created by Mayank Rikh on 07/07/19.
//  Copyright © 2019 Mayank Rikh. All rights reserved.
//

import SDWebImage
import UIKit

protocol ProfilePhotoViewModelDelegate : BaseProtocol{

    func updateProgress(progress : Double)
    func imageUploadSuccess()
}

class ProfilePhotoViewModel{

    weak var delegate : ProfilePhotoViewModelDelegate?
    lazy var uploadManager : ImageUploadManager = ImageUploadManager()

    private (set) var imageString = ""

    func startUpload(image : UIImage){

        delegate?.updateProgress(progress: 0.0)
        uploadManager.uploadImage(image, forItemWithTag: 1001, periodProgress: { [weak self] (progress) in

            self?.delegate?.updateProgress(progress: progress)

        }) { [weak self] (tag, urlString, error) in

            guard let strongSelf = self else { return }

            if let tempString = urlString{

                SDImageCache.shared.clearMemory()
                SDImageCache.shared.store(Utilities.resizeImage(image), forKey: tempString, completion: nil)
                self?.imageString = tempString
                self?.delegate?.imageUploadSuccess()
            }else{
                strongSelf.delegate?.errorOccurred(errorString: error?.localizedDescription)
            }
        }
    }
}
