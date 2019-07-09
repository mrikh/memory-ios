//
//  PhoneNumberViewModel.swift
//  Memory
//
//  Created by Mayank Rikh on 09/07/19.
//  Copyright © 2019 Mayank Rikh. All rights reserved.
//

import SwiftyJSON
import Foundation

class PhoneNumberViewModel{

    private var dictArray = [[String : Any]]()

    func fetcUserCountryCode() -> String?{

        let locale = Locale.current
        if let countryCode = locale.regionCode, let file = Bundle.main.path(forResource: "CountryData", ofType: "json"){
            if let data = try? Data(contentsOf: URL(fileURLWithPath: file)){
                if let array = try? JSONSerialization.jsonObject(with: data, options: .allowFragments) as? [[String : Any]]{

                    dictArray = array
                    if let object = array.first(where: {$0["ISOCode"] as? String == countryCode}){
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
            if let number = object["CountryCode"] as? Int{
                return "+\(number)"
            }
        }

        return nil
    }
}
