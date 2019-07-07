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

    static var authenticationToken = Defaults.value(forKey: .token)?.stringValue ?? ""
    static var headers : [String : String]{
        return ["Authorization" : "Bearer \(authenticationToken)"]
    }

    static func updateUser(params : [String : Any], completion : ((JSON?, Error?)->())?){

        NetworkingManager.PATCH(endPoint: .update, parameters: params, headers: headers, success: { (dict) in
            completion?(JSON(dict), nil)
        }) { (error) in
            completion?(nil, error)
        }
    }

    static func signUpUser(params : [String : Any], completion : ((JSON?, Error?)->())?){

        NetworkingManager.POST(endPoint: .signUp, parameters: params, success: { (dict) in
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
