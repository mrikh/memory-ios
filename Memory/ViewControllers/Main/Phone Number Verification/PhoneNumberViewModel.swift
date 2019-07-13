//
//  PhoneNumberViewModel.swift
//  Memory
//
//  Created by Mayank Rikh on 09/07/19.
//  Copyright © 2019 Mayank Rikh. All rights reserved.
//

import SwiftyJSON
import Foundation

protocol PhoneNumberViewModelDelegate : BaseProtocol{

    func textFieldError(errorString : String)
    func willHitApi()
    func gotResponse()
    func success(number : String)
}

class PhoneNumberViewModel{

    weak var delegate : PhoneNumberViewModelDelegate?
    private var dictArray = [[String : Any]]()
    private var selected : [String : Any]?

    func fetcUserCountryCode() -> String?{

        let locale = Locale.current
        if let countryCode = locale.regionCode, let file = Bundle.main.path(forResource: "CountryData", ofType: "json"){
            if let data = try? Data(contentsOf: URL(fileURLWithPath: file)){
                if let array = try? JSONSerialization.jsonObject(with: data, options: .allowFragments) as? [[String : Any]]{

                    dictArray = array
                    if let object = array.first(where: {$0["ISOCode"] as? String == countryCode}){
                        selected = object
                        if let number = object["CountryCode"] as? Int{
                            return "+\(number)"
                        }
                    }
                }
            }
        }

        return nil
    }

    func countryCodeNumber(for code : String) -> String?{

        if let object = dictArray.first(where: {$0["ISOCode"] as? String == code}){
            selected = object
            if let number = object["CountryCode"] as? Int{
                return "+\(number)"
            }
        }

        return nil
    }

    func startNumberVerification(number : String?){

        guard let temp = selected else{
            delegate?.errorOccurred(errorString: StringConstants.select_country_code.localized)
            return
        }

        let countryModel = CountryCodeModel(temp)

        guard let mobileNumber = number?.trimmingCharacters(in: .whitespacesAndNewlines), !mobileNumber.isEmpty else {
            delegate?.textFieldError(errorString: StringConstants.enter_mobile_number.localized)
            return
        }

        if mobileNumber.count < countryModel.min_NSN{
            delegate?.textFieldError(errorString: StringConstants.missing_digits.localized)
            return
        }

        if mobileNumber.count > countryModel.max_NSN{
            delegate?.textFieldError(errorString: StringConstants.number_not_long.localized)
            return
        }

        delegate?.willHitApi()
        let finalNumber = "\(countryModel.countryCode)\(mobileNumber)"
        APIManager.sendOTP(phone: finalNumber) { [weak self] (json, error) in
            self?.delegate?.gotResponse()
            if let _ = json{
                UserModel.current.phoneNumber = finalNumber
                UserModel.current.saveToUserDefaults()
                self?.delegate?.success(number : finalNumber)
            }else{
                self?.delegate?.errorOccurred(errorString: error?.localizedDescription)
            }
        }
    }
}
