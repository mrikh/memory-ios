//
//  AlertProtocol.swift
//  Memory
//
//  Created by Mayank Rikh on 25/01/19.
//  Copyright © 2019 Mayank Rikh. All rights reserved.
//

import UIKit

protocol AlertProtocol {
    
    /// Show custom alert screen
    ///
    /// - Parameters:
    ///   - title: Title of the alert to show
    ///   - message: Body of the alert
    ///   - show: Wether we need to show the cancel button
    ///   - cancelOnLeft: if cancel button should be on the left
    ///   - cancelTitle: title of the cancel button
    ///   - okayTitle: title of the okay button
    ///   - completion: Closure to handle the okay action
    func showAlert(_ title : String, withMessage message: String?, andShowCancel show: Bool, cancelOnLeft : Bool, cancelTitle : String?, okayTitle : String?, withCompletion completion:(()->())?)
    
    
    /// Show alert to redirect user for the settings page
    ///
    /// - Parameters:
    ///   - title: Title of the alert
    ///   - cancelTitle: Cancel button title
    ///   - okayTitle: Okay button title
    ///   - message: Message to show in the alert body
    func showRedirectAlert(_ title: String, withMessage message: String)
}

extension AlertProtocol where Self : UIViewController{
   
    func showAlert(_ title : String, withMessage message: String?, andShowCancel show: Bool = false, cancelOnLeft : Bool = true, cancelTitle : String? = nil, okayTitle : String? = nil, withCompletion completion:(()->())?){
        
        if (message ?? "").isEmpty { return }
        
        let alertController = UIAlertController(title:title, message: message, preferredStyle: .alert)

        if show, cancelOnLeft{

            alertController.addAction(UIAlertAction(title: cancelTitle ?? StringConstants.cancel.localized, style: .default, handler: { (action) in

                DispatchQueue.main.async{
                    alertController.dismiss(animated: true, completion: nil)
                }
            }))
        }
        
        alertController.addAction(UIAlertAction(title: okayTitle ?? StringConstants.okay.localized, style: .default, handler: { (action) in
            
            DispatchQueue.main.async{
                alertController.dismiss(animated: true, completion: nil)
                completion?()
            }
        }))
        
        if show, !cancelOnLeft{

            alertController.addAction(UIAlertAction(title: cancelTitle ?? StringConstants.cancel.localized, style: .default, handler: { (action) in
                
                DispatchQueue.main.async{
                    alertController.dismiss(animated: true, completion: nil)
                }
            }))
        }
        
        DispatchQueue.main.async{
            
            self.present(alertController, animated: true, completion: nil)
        }
    }
    
    func showRedirectAlert(_ title: String, withMessage message: String){
        
        showAlert(title, withMessage: message, andShowCancel: true, cancelOnLeft: true) {
            
            if let url = URL(string : UIApplication.openSettingsURLString){
                if UIApplication.shared.canOpenURL(url){
                    UIApplication.shared.open(url, options: [:], completionHandler: nil)
                }
            }
        }
    }
}
