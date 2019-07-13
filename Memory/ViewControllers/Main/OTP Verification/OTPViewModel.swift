//
//  OTPViewModel.swift
//  Memory
//
//  Created by Mayank Rikh on 13/07/19.
//  Copyright © 2019 Mayank Rikh. All rights reserved.
//

import Foundation

protocol OTPViewModelDelegate : BaseProtocol {

    func resendSuccess()
    func verificationSuccess(message : String)

    func verificationStarted()
    func verificationCompleted()
}

class OTPViewModel{

    var otpArray = ["","","",""]
    
    private var phoneNumber : String = ""
    weak var delegate : OTPViewModelDelegate?

    convenience init(number : String){
        self.init()
        phoneNumber = number
    }

    func resend(){
        delegate?.startLoader()

        APIManager.sendOTP(phone: phoneNumber) { [weak self] (json, error) in
            self?.delegate?.stopLoader()

            if let _ = json{
                self?.delegate?.resendSuccess()
            }else{
                self?.delegate?.errorOccurred(errorString: error?.localizedDescription)
            }
        }
    }

    func verify(){

        let string = otpArray.joined(separator: "")

        if string.count != 4{
            delegate?.errorOccurred(errorString: StringConstants.fill_otp.localized)
            return
        }

        delegate?.verificationStarted()

        APIManager.verifyOTP(otp: string) { [weak self] (json, error) in
            self?.delegate?.verificationCompleted()
            
            if let tempJson = json{
                UserModel.current.phoneVerified = true
                UserModel.current.saveToUserDefaults()
                self?.delegate?.verificationSuccess(message : tempJson["message"].stringValue)
            }else{
                self?.delegate?.errorOccurred(errorString: error?.localizedDescription)
            }
        }
    }
}
