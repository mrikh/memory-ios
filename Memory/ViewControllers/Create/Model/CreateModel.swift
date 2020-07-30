//
//  CreateModel.swift
//  Memory
//
//  Created by Mayank Rikh on 14/07/19.
//  Copyright © 2019 Mayank Rikh. All rights reserved.
//

import Foundation

class CreateModel{

    enum Privacy : Int{
        case selectedFriends = 0
        case anyone = 1

        var displayString : String{
            switch self{
            case .selectedFriends: return StringConstants.only_friends.localized
            case .anyone : return StringConstants.everyone.localized
            }
        }
    }

    var name : String?

    var startDate : Date?
    var endDate : Date?

    var addressTitle : String?
    var address : String?
    var nearby : String?
    var lat : Double?
    var long : Double?
    var countryCode : String?

    var privacy : Privacy = .anyone
    var photos = [ImageModel]()

    var otherDetails : String?
}
