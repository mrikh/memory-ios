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
    func openImagePickerSheet(cameraAction: @escaping ()->(), withGalleryAction galleryAction : @escaping ()->(), andRemovePhoto removePhoto: (()->())?)
    
    /// Open default ios action sheet
    ///
    /// - Parameters:
    ///   - title: Title to display
    ///   - message: Message to display
    ///   - firstTitle: Title of first action
    ///   - firstAction: Closure of first action
    ///   - secondTitle: Title of second action
    ///   - secondAction: Closure of second action
    func openActionSheet(_ title : String, andMessage message : String, withFirstItemTitle firstTitle:String, withFirstAction firstAction : (()->())?, withSecondActionTitle secondTitle : String?, withSecondAction secondAction : (()->())?)
    
    /// Open default ios action sheet with selecting an option if necessary
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
    func openActionSheet(_ title : String, andMessage message : String, firstItemSelected : Bool, secondItemSelected : Bool, withFirstItemTitle firstTitle:String, withFirstAction firstAction : (()->())?, withSecondActionTitle secondTitle : String?, withSecondAction secondAction : (()->())?)
}

extension ActionSheetProtocol where Self : UIViewController{
    
    func openImagePickerSheet(cameraAction: @escaping ()->(), withGalleryAction galleryAction : @escaping ()->(), andRemovePhoto removePhoto: (()->())?){
        
        openActionSheet("", andMessage: StringConstants.select_option.localized, withFirstItemTitle: StringConstants.camera.localized, withFirstAction: cameraAction, withSecondActionTitle: StringConstants.gallery.localized, withSecondAction: galleryAction)
    }
    
    func openActionSheet(_ title : String, andMessage message : String, withFirstItemTitle firstTitle:String, withFirstAction firstAction : (()->())?, withSecondActionTitle secondTitle : String?, withSecondAction secondAction : (()->())?){
        
        let actionSheetController = UIAlertController(title: title, message: message, preferredStyle: .actionSheet)
        
        actionSheetController.addAction(UIAlertAction(title: firstTitle, style: .default){ _ in
            
            if let tempAction = firstAction{
                tempAction()
            }
        })
        
        if let tempTitle = secondTitle{
            actionSheetController.addAction( UIAlertAction(title: tempTitle, style: .default){ _ in
                if let tempAction = secondAction{
                    tempAction()
                }
            })
        }
        
        actionSheetController.addAction(UIAlertAction(title: StringConstants.cancel.localized, style: .cancel) { _ in })
        self.present(actionSheetController, animated: true, completion: nil)
    }

    
    func openActionSheet(_ title : String, andMessage message : String, firstItemSelected : Bool = false, secondItemSelected : Bool = false, withFirstItemTitle firstTitle:String, withFirstAction firstAction : (()->())?, withSecondActionTitle secondTitle : String?, withSecondAction secondAction : (()->())?){
        
        var selectSecond = secondItemSelected
        
        if firstItemSelected && selectSecond{
            selectSecond = false
        }
        
        let actionSheetController = UIAlertController(title: title, message: message, preferredStyle: .actionSheet)
        
        actionSheetController.addAction(UIAlertAction(title: firstTitle, style: firstItemSelected ? .destructive : .default){ _ in
            
            if let tempAction = firstAction{
                tempAction()
            }
        })
        
        if let tempTitle = secondTitle{
            actionSheetController.addAction( UIAlertAction(title: tempTitle, style: selectSecond ? .destructive : .default){ _ in
                if let tempAction = secondAction{
                    tempAction()
                }
            })
        }
        
        actionSheetController.addAction(UIAlertAction(title: StringConstants.cancel.localized, style: .cancel) { _ in })
        self.present(actionSheetController, animated: true, completion: nil)
    }
}
