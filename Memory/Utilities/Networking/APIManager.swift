//
//  APIManager.swift
//  Memory
//
//  Created by Mayank Rikh on 25/01/19.
//  Copyright © 2019 Mayank Rikh. All rights reserved.
//

import SwiftyJSON
import Foundation
import Alamofire

class APIManager {

    static var authenticationToken = Defaults.value(forKey: .token)?.stringValue ?? ""
    static var headers : HTTPHeaders{
        return ["Authorization" : "Bearer \(authenticationToken)"]
    }

    static func updateAttending(eventId : String, isAttending : Bool, completion : ((JSON?, Error?)->())?){

        NetworkingManager.PATCH(endPoint: .attending, parameters: ["eventId" : eventId, "isAttending" : isAttending], headers: headers, success: { (dict) in
            completion?(JSON(dict), nil)
        }) { (error) in
            completion?(nil, error)
        }
    }

    static func eventDetails(id : String, completion : ((JSON?, Error?)->())?){

        NetworkingManager.GET(endPoint: .eventDetails, parameters: ["eventId": id, "userId" : UserModel.current.userId], success: { (dict) in
            completion?(JSON(dict), nil)
        }) { (error) in
            completion?(nil, error)
        }
    }

    static func createEvent(params : [String : Any], completion: ((JSON?, Error?)->())?){

        NetworkingManager.POST(endPoint: .create, parameters: params, headers : headers, success: { (dict) in
            completion?(JSON(dict), nil)
        }) { (error) in
            completion?(nil, error)
        }
    }

    //user id passed manually as we will have explore feature so to get user id, this is done.
    static func getEvents(lat : Double, long : Double, status : Int, skip : Int, completion: ((JSON?, Error?)->())?){

        NetworkingManager.GET(endPoint: .getEvents, parameters: ["lat" : lat, "long" : long, "distance" : UserModel.current.distance, "limit" : 10, "skip" : skip, "eventStatus" : status, "userId" : UserModel.current.userId], success: { (dict) in

            completion?(JSON(dict), nil)
        }) { (error) in
            completion?(nil, error)
        }
    }

    static func verifyOTP(otp : String, completion: ((JSON?, Error?)->())?){

        NetworkingManager.POST(endPoint: .verifyOTP, parameters: ["token" : otp], headers : headers, success: { (dict) in
            completion?(JSON(dict), nil)
        }) { (error) in
            completion?(nil, error)
        }
    }

    static func sendOTP(phone : String, completion: ((JSON?, Error?)->())?){

        NetworkingManager.POST(endPoint: .sendOTP, parameters: ["phoneNumber" : phone], headers : headers, success: { (dict) in
            completion?(JSON(dict), nil)
        }) { (error) in
            completion?(nil, error)
        }
    }

    static func resendEmail(email : String, completion: ((JSON?, Error?)->())?){
        
        NetworkingManager.POST(endPoint: .resendVerification, parameters: ["email" : email], success: { (dict) in
            completion?(JSON(dict), nil)
        }) { (error) in
            completion?(nil, error)
        }
    }

    static func forgotPass(params : [String : Any],  completion : ((JSON?, Error?)->())?){

        NetworkingManager.POST(endPoint: .forgotPass, parameters: params, success: { (dict) in
            completion?(JSON(dict), nil)
        }) { (error) in
            completion?(nil, error)
        }
    }

    static func login(params : [String : Any],  completion : ((JSON?, Error?)->())?){

        NetworkingManager.POST(endPoint: .login, parameters: params, success: { (dict) in
            completion?(JSON(dict), nil)
        }) { (error) in
            completion?(nil, error)
        }
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
