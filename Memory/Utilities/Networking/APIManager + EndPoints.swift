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
        case resendVerification = "/users/resendVerification"
        case verifyEmail = "/users/verifyEmail"
        case sendOTP = "/users/sendOTP"
        case verifyOTP = "/users/verifyOTP"

        case create = "/event/create"
        case getEvents = "/event/list"
        case eventDetails = "/event/eventDetails"
        case attending = "/event/attending"
        #warning("Aggregate query for get events based on privacy status and if querying user is in invited array. Delete the invited key from results")

        #warning("add distance radius in profile")
        
        var path : String {

            #if DEBUG
            let url = "http://10.65.240.77:3000"
            #else
            let url = "https://memory-node.herokuapp.com"
            #endif

            return url + rawValue
        }
    }
}



