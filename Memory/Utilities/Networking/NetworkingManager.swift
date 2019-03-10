//
//  NetworkingManager.swift
//  Memory
//
//  Created by Mayank Rikh on 25/01/19.
//  Copyright © 2019 Mayank Rikh. All rights reserved.
//

import Foundation
import Alamofire

class NetworkingManager {
    
    static var alamoFireManager : SessionManager = {
        
        let configuration = URLSessionConfiguration.default
        configuration.timeoutIntervalForRequest = 20
        configuration.timeoutIntervalForResource = 20
        return Alamofire.SessionManager(configuration: configuration)
    }()
    
    static func POST(endPoint : APIManager.EndPoint, parameters : [String : Any] = [:], headers : HTTPHeaders = [:], loader : Bool = true, success : @escaping (JSON) -> Void, failure : @escaping (Error) -> Void) {
        
        request(URLString: endPoint.path, httpMethod: .post, parameters: parameters, headers: headers, loader: loader, success: success, failure: failure)
    }
    
    static func GET(endPoint : APIManager.EndPoint, parameters : [String : Any] = [:], headers : HTTPHeaders = [:], loader : Bool = true, success : @escaping (JSON) -> Void, failure : @escaping (Error) -> Void) {
        
        request(URLString: endPoint.path, httpMethod: .get, parameters: parameters, encoding: URLEncoding.queryString, headers: headers, loader: loader, success: success, failure: failure)
    }
    
    static func PUT(endPoint : APIManager.EndPoint, parameters : [String : Any] = [:], headers : HTTPHeaders = [:], loader : Bool = true, success : @escaping (JSON) -> Void, failure : @escaping (Error) -> Void) {
        
        request(URLString: endPoint.path, httpMethod: .put, parameters: parameters, headers: headers, loader: loader, success: success, failure: failure)
    }
    
    static func DELETE(endPoint : APIManager.EndPoint, parameters : [String : Any] = [:], headers : HTTPHeaders = [:], loader : Bool = true, success : @escaping (JSON) -> Void, failure : @escaping (Error) -> Void) {
        
        request(URLString: endPoint.path, httpMethod: .delete, parameters: parameters, headers: headers, loader: loader, success: success, failure: failure)
    }
    
    static func PATCH(endPoint : APIManager.EndPoint, parameters : [String : Any] = [:], headers : HTTPHeaders = [:], loader : Bool = true, success : @escaping (JSON) -> Void, failure : @escaping (Error) -> Void) {
        
        request(URLString: endPoint.path, httpMethod: .patch, parameters: parameters, headers: headers, loader: loader, success: success, failure: failure)
    }
    
    private static func request(URLString : String, httpMethod : HTTPMethod, parameters : [String : Any] = [:], encoding: URLEncoding = URLEncoding.httpBody, headers : HTTPHeaders = [:], loader : Bool = true, success : @escaping (JSON) -> Void, failure : @escaping (Error) -> Void) {
        
        DispatchQueue.main.async{
            UIApplication.shared.isNetworkActivityIndicatorVisible = true
        }
        
        let request = alamoFireManager.request(URLString, method: httpMethod, parameters: parameters, encoding: encoding, headers: headers)
        
        request.responseJSON { (response:DataResponse<Any>) in
            
            DispatchQueue.main.async{
                UIApplication.shared.isNetworkActivityIndicatorVisible = false
            }
            
            switch(response.result) {
                
            case .success(let value):
                let json = JSON(value)
                if json["CODE"].intValue == 200{
                    success(json)
                }else{
                    let error = NSError(domain: "", code: json["CODE"].intValue, userInfo: [NSLocalizedDescriptionKey : json["MESSAGE"].stringValue, "response": json["RESULT"].dictionaryValue])

//                    if error.code == ErrorCodes.accountBlocked{
//                        FlowManager.clearAllData()
//                        FlowManager.goToLogin()
//                    }else{
                        failure(error)
//                    }
                }
            case .failure(let e):
                failure(e)
            }
        }
    }
}
