//
//  APIManager + EndPoints.swift
//  Memory
//
//  Created by Mayank Rikh on 25/01/19.
//  Copyright © 2019 Mayank Rikh. All rights reserved.
//
import Foundation

extension APIManager {

    enum EndPoint : String {

        case signUp = "/users/signUp"
        case checkInfo = "/users/checkInfo"
        case update = "/users/update"
        case login = "/users/login"
        case forgotPass = "/users/forgotPass"
        
        var path : String {

            #if DEBUG
            let url = "https://memory-node.herokuapp.com"
            #else
            let url = "https://memory-node.herokuapp.com"
            #endif

            return url + rawValue
        }
    }
}



