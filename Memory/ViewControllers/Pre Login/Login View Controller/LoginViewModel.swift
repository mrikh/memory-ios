//
//  LoginViewModel.swift
//  Memory
//
//  Created by Mayank Rikh on 08/07/19.
//  Copyright © 2019 Mayank Rikh. All rights reserved.
//

import Foundation

class LoginViewModel{

    func validateEmail(text : String) -> String?{

        return ValidationController.validateEmail(text)
    }

    func validatePassword(text : String) -> String?{
        
        return ValidationController.validatePassword(text)
    }

    func startLogin(){
        
    }
}
