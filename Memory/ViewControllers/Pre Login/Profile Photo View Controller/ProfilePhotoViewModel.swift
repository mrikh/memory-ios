//
//  ProfilePhotoViewModel.swift
//  Memory
//
//  Created by Mayank Rikh on 07/07/19.
//  Copyright © 2019 Mayank Rikh. All rights reserved.
//

import SwiftyJSON
import SDWebImage
import UIKit

protocol ProfilePhotoViewModelDelegate : BaseProtocol{

    func updatedInfo()
    func updateProgress(progress : Double)
    func imageUploadSuccess()

    func pendingVerification(string : String)
}

class ProfilePhotoViewModel{

    weak var delegate : ProfilePhotoViewModelDelegate?
    lazy var uploadManager : ImageUploadManager = ImageUploadManager()

    func startUpload(image : UIImage){

        delegate?.updateProgress(progress: 0.0)
        uploadManager.uploadImage(image, forItemWithTag: 1001, periodProgress: { [weak self] (progress) in

            self?.delegate?.updateProgress(progress: progress)

        }) { [weak self] (tag, urlString, error) in

            guard let strongSelf = self else { return }

            if let tempString = urlString{

                SDImageCache.shared.store(Utilities.resizeImage(image), forKey: tempString, completion: nil)
                SDImageCache.shared.clearMemory()
                self?.delegate?.imageUploadSuccess()
                self?.uploadToOurServer(photoUrlString: tempString)
            }else{
                strongSelf.delegate?.errorOccurred(errorString: error?.localizedDescription)
            }
        }
    }

    func uploadToOurServer(photoUrlString : String){

        APIManager.updateUser(params: ["profilePhoto" : photoUrlString]) { [weak self] (json, error) in

            if let tempJson = json?["data"]{
                UserModel.current = UserModel(tempJson)
                UserModel.current.saveToUserDefaults()
                Defaults.save(value: APIManager.authenticationToken, forKey: .token)
                self?.delegate?.updatedInfo()
            }else{
                //clear it incase of error
                APIManager.authenticationToken = ""
                if let tempError = error, (tempError as NSError).code == 203{
                    self?.delegate?.pendingVerification(string: error?.localizedDescription ?? StringConstants.pending_verification.localized)
                }else{
                    self?.delegate?.errorOccurred(errorString: error?.localizedDescription)
                }
            }
        }
    }
}
