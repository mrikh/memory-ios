//
//  UserModel.swift
//  Memory
//
//  Created by Mayank on 03/12/18.
//  Copyright © 2018 Mayank Rikh. All rights reserved.
//

import SwiftyJSON
import Foundation

struct UserModel{
    
    static var current = UserModel(Defaults.value(forKey: .userInfo) ?? JSON())
    
    let user_id: String
    var name: String
    let email: String
    let username: String
    var emailVerified : Bool
    var phoneVerified : Bool
    var profilePhoto : String
    var phoneNumber : String
    
    init (_ json: JSON) {
        
        user_id = json["_id"].stringValue
        name = json["name"].stringValue
        email = json["email"].stringValue
        username = json["username"].stringValue
        emailVerified = json["emailVerified"].boolValue
        profilePhoto = json["profilePhoto"].stringValue
        phoneVerified = json["phoneVerified"].boolValue
        phoneNumber = json["phoneNumber"].stringValue
    }
    
    func saveToUserDefaults() {
        
        let dict = ["_id" : user_id, "name" : name, "email" : email, "username" : username, "emailVerified" : emailVerified, "profilePhoto" : profilePhoto, "phoneVerified" : phoneVerified, "phoneNumber" : phoneNumber] as [String : Any]
        Defaults.save(value: dict, forKey: .userInfo)
    }
}
