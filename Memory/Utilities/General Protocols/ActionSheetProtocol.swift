//
//  ActionSheetProtocol.swift
//  Memory
//
//  Created by Mayank Rikh on 25/01/19.
//  Copyright © 2019 Mayank Rikh. All rights reserved.
//

import Foundation
import UIKit

protocol ActionSheetProtocol {

    /// Open image picker action sheet
    ///
    /// - Parameters:
    ///   - cameraAction: Closure containing camera functionality
    ///   - galleryAction: Closure containing gallery functionality
    ///   - removePhoto: Remove photo Closure if required
    func openImagePickerSheet(cameraAction: @escaping ()->(), galleryAction : @escaping ()->(), removePhoto: (()->())?)

    /// Open default ios action sheet with selecting an option if necessary. Make sure only 1 of the options being selected is true as otherwise it will crash.
    ///
    /// - Parameters:
    ///   - title: Title of the action sheet
    ///   - message: Description body of action sheet
    ///   - firstItemSelected: Should we select first item
    ///   - secondItemSelected: Should we select second item
    ///   - firstTitle: Title of first action
    ///   - firstAction: Closure of first action
    ///   - secondTitle: Title of second action
    ///   - secondAction: Closure of second action
    func openActionSheet(title : String, message : String, firstTitle: String, secondTitle : String?, thirdTitle : String?, firstSelected : Bool, secondSelected : Bool, thirdSelected : Bool, firstAction : (()->())?, secondAction : (()->())?, thirdAction : (()->())?)
}

extension ActionSheetProtocol where Self : UIViewController{

    func openImagePickerSheet(cameraAction: @escaping ()->(), galleryAction : @escaping ()->(), removePhoto: (()->())?){

        openActionSheet(title: StringConstants.select_option.localized, message: StringConstants.select_image_to_upload.localized, firstTitle: StringConstants.camera.localized, secondTitle: StringConstants.gallery.localized, thirdTitle: removePhoto == nil ? nil :  StringConstants.delete.localized, firstSelected: false, secondSelected: false, thirdSelected: false, firstAction: cameraAction, secondAction: galleryAction, thirdAction: removePhoto)
    }

    func openActionSheet(title : String, message : String, firstTitle: String, secondTitle : String?, thirdTitle : String?, firstSelected : Bool, secondSelected : Bool, thirdSelected : Bool, firstAction : (()->())?, secondAction : (()->())?, thirdAction : (()->())?){

        let actionSheetController = UIAlertController(title: title, message: message, preferredStyle: .actionSheet)
        actionSheetController.addAction(UIAlertAction(title: firstTitle, style: firstSelected ? .destructive : .default){ _ in

            if let tempAction = firstAction{
                tempAction()
            }
        })

        if let tempTitle = secondTitle{
            actionSheetController.addAction( UIAlertAction(title: tempTitle, style: secondSelected ? .destructive : .default){ _ in
                if let tempAction = secondAction{
                    tempAction()
                }
            })
        }

        if let tempTitle = thirdTitle{
            actionSheetController.addAction( UIAlertAction(title: tempTitle, style: thirdSelected ? .destructive : .default){ _ in
                if let tempAction = thirdAction{
                    tempAction()
                }
            })
        }

        actionSheetController.addAction(UIAlertAction(title: StringConstants.cancel.localized, style: .cancel) { _ in })
        self.present(actionSheetController, animated: true, completion: nil)
    }
}
