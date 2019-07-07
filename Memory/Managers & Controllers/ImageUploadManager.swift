//
//  ImageUploadManager.swift
//  Mid West Pilot Cars
//
//  Created by Mayank Rikh on 28/05/19.
//  Copyright © 2019 Mayank Rikh. All rights reserved.
//

import SDWebImage
import Foundation

class ImageUploadManager{

    //To keep track of uploading status
    var isUploading = false
    //To keep track of unique identifiers currently being uploaded
    var tagArray : [Int] = [Int]()


    func uploadImage(_ image : UIImage, forItemWithTag tag : Int, periodProgress : ((Double)->())?, withCompletion completion:@escaping (Int, String?, Error?)->()){

        isUploading = true
        tagArray.append(tag)

        DispatchQueue.global().async { [weak self] in
            if let tempImage = Utilities.resizeImage(image){

                self?.upload(image: tempImage, tag: tag, periodicProgress : periodProgress, withCompletion: { (tag, urlString, error) in

                    self?.tagArray.removeAll(where: {$0 == tag})
                    if let empty = self?.tagArray.isEmpty, empty{
                        self?.isUploading = false
                    }
                    completion(tag, urlString, error)
                })

            }else{
                //upload uncropped to aws as resizing failed D:
                self?.upload(image: image, tag: tag, periodicProgress: periodProgress, withCompletion: { (tag, urlString, error) in

                    self?.tagArray.removeAll(where: {$0 == tag})
                    if let empty = self?.tagArray.isEmpty, empty{
                        self?.isUploading = false
                    }
                    completion(tag, urlString, error)
                })
            }
        }
    }

    //upload data
    private func upload (image : UIImage, tag : Int, periodicProgress : ((Double)->())?, withCompletion completion:@escaping (Int, String?,Error?)->()){

        let fileName = Utilities.uniqueName

        //just in case url creation failes
        guard let data = image.jpegData(compressionQuality: 0.9), let tempUrl = URL(string : "\(AWSKeys.s3BaseUrl)\(AWSKeys.bucket_name)/\(fileName)") else {
            completion(tag, nil, NSError(domain: "", code: 4001, userInfo: [NSLocalizedDescriptionKey : StringConstants.something_wrong.localized]))
            return
        }

        AWSHandler.uploadImage(withData: data, andFileName: fileName, progress: { (uploadTask, progress) in

            DispatchQueue.main.async{
                periodicProgress?(progress.fractionCompleted)
            }

        }, completion: {(uploadTask, error) in

            DispatchQueue.main.async{
                if let tempError = error{
                    completion(tag, nil, tempError)
                }else{
                    completion(tag, tempUrl.absoluteString, nil)
                }
            }
        }) {(uploadTask, error) in

            DispatchQueue.main.async{

                if let _ = uploadTask{

                }else{
                    completion(tag, nil, NSError(domain: "", code: 4001, userInfo: [NSLocalizedDescriptionKey : error?.localizedDescription ?? StringConstants.something_wrong.localized]))
                }
            }
        }
    }
}
