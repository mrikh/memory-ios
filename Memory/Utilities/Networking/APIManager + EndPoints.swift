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

        case forgetPassword
        
        var path : String {

            let url = "http://18.232.109.183:3001"
            return url + self.rawValue
        }
    }
}



