//
//  ImagePickerProtocol.swift
//  Memory
//
//  Created by Mayank Rikh on 25/01/19.
//  Copyright © 2019 Mayank Rikh. All rights reserved.
//

import UIKit

protocol ImagePickerProtocol : AuthorizationProtocol, ActionSheetProtocol, AlertProtocol{
    
    /// This method will handle the process of uploading an image. Including checking for camera and gallery access. It will show a action sheet and the class will have to conform to the picker delegate and navigation controller delegate to get the image back
    ///
    /// - Parameters:
    ///   - showFront: Boolean value if we need to show the front camera
    ///   - action: This is the closure to handle an image removal action if necessary
    func startImagePick(showFront : Bool, removalClosure action:(()->())?)
}

extension ImagePickerProtocol where Self : UIViewController & UIImagePickerControllerDelegate & UINavigationControllerDelegate{
    
    func startImagePick(showFront : Bool, removalClosure action:(()->())?){
        showPicker(showFront : showFront, removePhoto: action)
    }
    
    private func showPicker(showFront : Bool, removePhoto:(()->())?){

        openImagePickerSheet(cameraAction: { [weak self] in
            self?.showImagePicker(showFront : showFront, showCamera : true)
        }, galleryAction: { [weak self] in 
            self?.showImagePicker(showFront : showFront, showCamera : false)
        }, removePhoto: removePhoto)
    }
    
    func showImagePicker(showFront : Bool, showCamera : Bool){
        
        let imagePickerController = UIImagePickerController()
        
        imagePickerController.allowsEditing = false
        imagePickerController.delegate = self
        
        if showCamera{
            openCamera(imagePickerController, showFront : showFront)
        }else{
            openGallery(imagePickerController)
        }
    }
    
    func openCamera(_ picker : UIImagePickerController, showFront : Bool){
        
        checkCameraAuthorization { [weak self] (granted, authorizationRequested) in
            if granted{
                if UIImagePickerController.isSourceTypeAvailable(.camera){
                    picker.sourceType = .camera
                    if showFront{
                        picker.cameraDevice = .front
                    }else{
                        picker.cameraDevice = .rear
                    }
                    self?.present(picker, animated: true, completion: nil)
                }else{
                    self?.openGallery(picker)
                }
            }else{
                //dont show toast if permission was asked this time
                if !authorizationRequested{
                    self?.showRedirectAlert(StringConstants.oops.localized, withMessage: StringConstants.camera_access.localized)
                }
            }
        }
    }
    
    func openGallery(_ picker : UIImagePickerController) {
        checkGalleryAuthorization { [weak self] (granted, authorizationRequested) in
            if granted{
                picker.sourceType = .photoLibrary
                self?.present(picker, animated: true, completion: nil)
            }else{
                //dont show toast if permission was asked this time
                if !authorizationRequested{
                    self?.showRedirectAlert(StringConstants.oops.localized, withMessage: StringConstants.gallery_access.localized)
                }
            }
        }
    }
}
