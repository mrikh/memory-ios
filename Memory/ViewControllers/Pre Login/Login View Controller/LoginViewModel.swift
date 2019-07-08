//
//  LoginViewModel.swift
//  Memory
//
//  Created by Mayank Rikh on 08/07/19.
//  Copyright © 2019 Mayank Rikh. All rights reserved.
//

import Foundation

protocol LoginVewModelDelegate : BaseProtocol{

    func validationSuccess()
    func success()

    func receivedResponse()
}

class LoginViewModel{

    var email : Binder<String> = Binder("")
    var emailError : Binder<String?> = Binder(nil)
    var password : Binder<String> = Binder("")
    var passwordError : Binder<String?> = Binder(nil)

    weak var delegate : LoginVewModelDelegate?

    func validateEmail(text : String){

        emailError.value = ValidationController.validateEmail(text.trimmingCharacters(in: .whitespacesAndNewlines))
    }

    func validatePassword(text : String){
        
        passwordError.value = ValidationController.validatePassword(text)
    }

    func startLogin(){

        guard emailError.value == nil, passwordError.value == nil else {
            delegate?.errorOccurred(errorString: StringConstants.one_or_more_fields.localized)
            return
        }

        delegate?.validationSuccess()

        APIManager.login(params: ["email" : email.value.trimmingCharacters(in: .whitespacesAndNewlines), "password" : password.value]) { [weak self] (json, error) in
            self?.delegate?.receivedResponse()
            if let tempJson = json?["data"]{

                let userModel = UserModel(tempJson["user"])
                userModel.saveToUserDefaults()
                UserModel.current = userModel

                let token = tempJson["token"].stringValue
                APIManager.authenticationToken = token
                Defaults.save(value: token, forKey: .token)
                self?.delegate?.success()
            }else{
                self?.delegate?.errorOccurred(errorString: error?.localizedDescription)
            }
        }
    }
}
