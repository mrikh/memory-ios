//
//  AuthorizationProtocol.swift
//  Memory
//
//  Created by Mayank Rikh on 25/01/19.
//  Copyright © 2019 Mayank Rikh. All rights reserved.
//

import Foundation
import Photos
import AVKit

protocol AuthorizationProtocol{
    
    /// Method to check camera authorization
    ///
    /// - Parameter completion: Completion closure. First parameter will let us know if access was granted and second parameter will let us know if access permission was asked for the first time.
    func checkCameraAuthorization(_ completion:@escaping (Bool, Bool)->())
    
    
    /// Method to check gallery authorization
    ///
    /// - Parameter completion: Completion closure. First parameter will let us know if access was granted and second parameter will let us know if access permission was asked for the first time.
    func checkGalleryAuthorization(_ completion:@escaping(Bool, Bool)->())
    
    
    /// Method to check audio authorization
    ///
    /// - Parameter completion: Completion closure. First parameter will let us know if access was granted and second parameter will let us know if access permission was asked for the first time.
    func checkAudioAuthorization(_ completion:@escaping(Bool, Bool)->())
    
    
    /// Method to check Recording authorization
    ///
    /// - Parameter completion: Completion closure. First parameter will let us know if access was granted and second parameter will let us know if access permission was asked for the first time.
    func checkRecordingAuthorization(_ completion:@escaping(Bool, Bool)->())
}

extension AuthorizationProtocol{
    
    func checkRecordingAuthorization(_ completion:@escaping(Bool, Bool)->()){
        
        switch AVAudioSession.sharedInstance().recordPermission{
            case .undetermined:
                AVAudioSession.sharedInstance().requestRecordPermission { (granted) in
                    DispatchQueue.main.async {
                        completion(granted, true)
                    }
                }
            case .denied:
                completion(false, false)
            case .granted:
                completion(true, false)
        @unknown default:
            completion(false, false)
        }
    }
    
    func checkAudioAuthorization(_ completion:@escaping(Bool, Bool)->()){
        
        checkAuthorizationForMedia(AVMediaType.audio.rawValue) { (granted, authorizationRequested) in
            
            completion(granted, authorizationRequested)
        }
    }
    
    func checkCameraAuthorization(_ completion:@escaping (Bool, Bool)->()){
        
        checkAuthorizationForMedia(AVMediaType.video.rawValue) { (granted, authorizationRequested) in
            
            completion(granted, authorizationRequested)
        }
    }
    
    func checkGalleryAuthorization(_ completion:@escaping(Bool, Bool)->()){
        
        let status = PHPhotoLibrary.authorizationStatus()
        
        switch (status){
            case .authorized:
                completion(true, false)
                break
            case .notDetermined:
                PHPhotoLibrary.requestAuthorization({ (status) in
                    DispatchQueue.main.async {
                        completion(status == .authorized, true)
                    }
                })
                break
            default:
                completion(false, false)
            break
        }
    }
    
    private func checkAuthorizationForMedia(_ mediaType:String, andOnCompletion completion:@escaping (Bool, Bool)->()){
        
        let status = AVCaptureDevice.authorizationStatus(for: AVMediaType(rawValue: mediaType))
        
        if status == AVAuthorizationStatus.denied || status == AVAuthorizationStatus.restricted{
            
            completion(false, false)
            
        }else if status == AVAuthorizationStatus.notDetermined{
            
            AVCaptureDevice.requestAccess(for: AVMediaType(rawValue: mediaType), completionHandler: { (granted) in
                
                DispatchQueue.main.async {
                    
                    completion(granted, true)
                }
            })
            
        }else if status == AVAuthorizationStatus.authorized{
            
            completion(true, false)
        }
    }
}
