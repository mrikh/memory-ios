//
//  UserModel.swift
//  GullyBeatsBeta
//
//  Created by Mayank on 03/12/18.
//  Copyright © 2018 Appinventiv. All rights reserved.
//

import Foundation

struct UserModel{
    
    static var current = UserModel(Defaults.value(forKey: .userInfo))
    
    let user_id: Int
    var full_name: String
    let email: String
    
    init (_ dict: [String : Any]? = [String : Any]()) {
        
        user_id = dict["user_id"] as? Int ?? 0
        full_name = dict["full_name"] as? String ?? ""
        email = dict["email"] as? String ?? ""
    }
    
    func saveToUserDefaults() {
        
        let dict = ["user_id" : user_id, "full_name" : full_name, "email" : email] as [String : Any]
        Defaults.save(value: dict, forKey: .userInfo)
    }
}
