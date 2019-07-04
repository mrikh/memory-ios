//
//  APIManager.swift
//  Memory
//
//  Created by Mayank Rikh on 25/01/19.
//  Copyright © 2019 Mayank Rikh. All rights reserved.
//

import SwiftyJSON
import Foundation

class APIManager {

    static var headers : [String : String]{
        return ["" : ""]
    }

    static func signUpUser(params : JSON, completion : ((JSON?, Error?)->())?){

        NetworkingManager.POST(endPoint: .signUp, success: { (dict) in
            completion?(JSON(dict), nil)
        }) { (error) in
            completion?(nil, error)
        }
    }

    static func checkUserName(name : String, completion : ((JSON?, Error?)->())?){

        NetworkingManager.GET(endPoint: .checkInfo, parameters: ["username" : name], success: { (dict) in
            completion?(JSON(dict), nil)
        }) { (error) in
            completion?(nil, error)
        }
    }
}
