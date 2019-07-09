//
//  CountryCodeModel.swift
//  Memory
//
//  Created by Mayank Rikh on 09/07/19.
//  Copyright © 2019 Mayank Rikh. All rights reserved.
//

import Foundation
import SwiftyJSON

struct CountryCodeModel {

    let countryID : Int
    let countryEnglishName : String
    let countryLocalName : String
    let iSOCode : String
    let countryCode : Int
    let countryExitCode : Int
    let min_NSN : Int
    let max_NSN : Int
    let trunkCode : Int
    let googleStore : Int
    let appleStore : Int
    let uNRank : Int
    let mobileRank : String
    let sortIndex : Int

    init(_ dict : [String : Any]) {
        let json = JSON(dict)

        countryID = json["CountryID"].intValue
        countryEnglishName = json["CountryEnglishName"].stringValue
        countryLocalName = json["CountryLocalName"].stringValue
        iSOCode = json["ISOCode"].stringValue
        countryCode = json["CountryCode"].intValue
        countryExitCode = json["CountryExitCode"].intValue
        min_NSN = json["Min NSN"].intValue
        max_NSN = json["Max NSN"].intValue
        trunkCode = json["TrunkCode"].intValue
        googleStore = json["GoogleStore"].intValue
        appleStore = json["AppleStore"].intValue
        uNRank = json["UNRank"].intValue
        mobileRank = json["MobileRank"].stringValue
        sortIndex = json["SortIndex"].intValue
    }
}
