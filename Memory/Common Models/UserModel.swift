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
    
    let userId: String
    var name: String
    let email: String
    let username: String
    var emailVerified : Bool
    var phoneVerified : Bool
    var profilePhoto : String
    var phoneNumber : String
    var distance : Double
    
    init (_ json: JSON) {
        
        userId = json["_id"].stringValue
        name = json["name"].stringValue
        email = json["email"].stringValue
        username = json["username"].stringValue
        emailVerified = json["emailVerified"].boolValue
        profilePhoto = json["profilePhoto"].stringValue
        phoneVerified = json["phoneVerified"].boolValue
        phoneNumber = json["phoneNumber"].stringValue
        //default value is 1000
        distance = json["distance"].double ?? 1000
    }
    
    func saveToUserDefaults() {
        
        let dict = ["_id" : userId, "name" : name, "email" : email, "username" : username, "emailVerified" : emailVerified, "profilePhoto" : profilePhoto, "phoneVerified" : phoneVerified, "phoneNumber" : phoneNumber, "distance" : distance] as [String : Any]
        Defaults.save(value: dict, forKey: .userInfo)
    }
}
