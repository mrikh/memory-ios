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
    }

    var startDate : TimeInterval?
    var endDate : TimeInterval?

    var addressTitle : String?
    var address : String?
    var nearby : String?
    var lat : Double?
    var long : Double?

    var privacy : Privacy = .selectedFriends
    var photos = [ImageModel]()

    var invited = [String]()

    var otherDetails : String?
}
