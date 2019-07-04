//
//  BaseProtocol.swift
//  GullyBeatsBeta
//
//  Created by Mayank on 04/12/18.
//  Copyright © 2018 Mayank Rikh. All rights reserved.
//

import Foundation

protocol BaseProtocol : AnyObject{
    
    func startLoader()
    func stopLoader()

    func errorOccurred(errorString : String?)
}

extension BaseProtocol where Self : BaseViewController{
    
    func startLoader(){
        indicator?.startAnimating()
    }
    
    func stopLoader(){
        //set it to false initially
        isLoading = false
        indicator?.stopAnimating()
    }

    func errorOccurred(errorString : String?){

        //if error occurs this becomes true
        showAlert(StringConstants.oops.localized, withMessage: errorString, withCompletion: nil)
    }
}
