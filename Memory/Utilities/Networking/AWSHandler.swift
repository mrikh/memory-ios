//
//  AWSHandler.swift
//  GullyBeatsBeta
//
//  Created by Mayank Rikh on 06/12/18.
//  Copyright © 2018 Appinventiv. All rights reserved.
//

import Foundation
import AWSS3

class AWSHandler{

    static var utility = AWSS3TransferUtility.default()

    /// Upload a file to our own aws server
    ///
    /// - Parameters:
    ///   - path: Path to upload file from
    ///   - fileName: name of the file
    ///   - tag: Parameter to uniquely identify the uploaded item in the callback
    ///   - contentType: Type of file
    ///   - progress : Gives progress callback
    ///   - completion: Closure to handle success or failure
    static func uploadFileToAws(withPath path : URL, andFileName fileName : String, andContentType contentType : String, progress: AWSS3TransferUtilityMultiPartProgressBlock?, completion: AWSS3TransferUtilityMultiPartUploadCompletionHandlerBlock?, transferTask : ((AWSS3TransferUtilityMultiPartUploadTask?, Error?)->())?){

        let expression = AWSS3TransferUtilityMultiPartUploadExpression()
        expression.progressBlock = progress
        expression.setValue("public-read", forRequestHeader: "x-amz-acl")
    
        utility.uploadUsingMultiPart(fileURL: path, bucket: AWSKeys.bucket_name, key: "\(fileName).mp4", contentType: contentType, expression: expression, completionHandler: completion).continueWith { (task) -> Any? in

            DispatchQueue.main.async {
                transferTask?(task.result, task.error)
            }

            return nil
        }
    }

    /// Download a file from our own aws server
    ///
    /// - Parameters:
    ///   - fileName: name of the file with content type
    ///   - progress : Gives progress callback
    ///   - completion: Closure to handle success or failure
    static func downloadFileFromAWS(_ fileName : String, progress: AWSS3TransferUtilityProgressBlock?, completion: AWSS3TransferUtilityDownloadCompletionHandlerBlock?, transferTask : ((AWSS3TransferUtilityDownloadTask?, Error?)->())?){

        let expression = AWSS3TransferUtilityDownloadExpression()
        expression.progressBlock = progress

        //used this method instead of directly writing to url using aws as that wasn't being detected properly when checking locally.
        utility.downloadData(fromBucket: AWSKeys.bucket_name, key: fileName, expression: expression, completionHandler: completion).continueWith { (task) -> Any? in

            DispatchQueue.main.async {
                transferTask?(task.result, task.error)
            }

            return nil
        }
    }


    static func uploadImage(withData data : Data, andFileName fileName : String, progress: AWSS3TransferUtilityMultiPartProgressBlock?, completion: AWSS3TransferUtilityMultiPartUploadCompletionHandlerBlock?, transferTask : ((AWSS3TransferUtilityMultiPartUploadTask?, Error?)->())?){

        let expression = AWSS3TransferUtilityMultiPartUploadExpression()
        expression.progressBlock = progress
        expression.setValue("public-read", forRequestHeader: "x-amz-acl")

        utility.uploadUsingMultiPart(data: data, bucket: AWSKeys.bucket_name, key: fileName, contentType: "image/jpeg", expression: expression, completionHandler: completion).continueWith { (task) -> Any? in

            DispatchQueue.main.async {
                transferTask?(task.result, task.error)
            }

            return nil
        }
    }
}
