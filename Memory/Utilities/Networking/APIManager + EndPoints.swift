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
        
        var path : String {

            #if DEBUG
            let url = "http://127.0.0.1:3000"
            #else
            let url = "http://127.0.0.1:3000"
            #endif

            return url + rawValue
        }
    }
}



