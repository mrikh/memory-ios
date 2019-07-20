//
//  FriendModel.swift
//  Memory
//
//  Created by Mayank Rikh on 21/07/19.
//  Copyright © 2019 Mayank Rikh. All rights reserved.
//

import SwiftyJSON
import Foundation

struct FriendModel{

    let friendId : String
    let name : String
    let profileImage : String

    init(json : JSON){

        friendId = json["_id"].stringValue
        name = json["name"].stringValue
        profileImage = json["profileImage"].stringValue
    }

    init(id : String, name : String, image : String){

        friendId = id
        self.name = name
        profileImage = self.image
    }
}
