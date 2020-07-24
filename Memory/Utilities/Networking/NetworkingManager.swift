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

    static var sessionConfig : URLSessionConfiguration = {
        let configuration = URLSessionConfiguration.default
        configuration.timeoutIntervalForRequest = 20
        configuration.timeoutIntervalForResource = 20
        return configuration
    }()

    static var alamoFireManager = Session(configuration: sessionConfig)

    
    static func POST(endPoint : APIManager.EndPoint, parameters : [String : Any] = [:], headers : HTTPHeaders = [:], loader : Bool = true, success : @escaping ([String : Any]) -> Void, failure : @escaping (Error) -> Void) {
        
        request(URLString: endPoint.path, httpMethod: .post, parameters: parameters, headers: headers, loader: loader, success: success, failure: failure)
    }
    
    static func GET(endPoint : APIManager.EndPoint, parameters : [String : Any] = [:], headers : HTTPHeaders = [:], loader : Bool = true, success : @escaping ([String : Any]) -> Void, failure : @escaping (Error) -> Void) {
        
        request(URLString: endPoint.path, httpMethod: .get, parameters: parameters, encoding: URLEncoding.queryString, headers: headers, loader: loader, success: success, failure: failure)
    }
    
    static func PUT(endPoint : APIManager.EndPoint, parameters : [String : Any] = [:], headers : HTTPHeaders = [:], loader : Bool = true, success : @escaping ([String : Any]) -> Void, failure : @escaping (Error) -> Void) {
        
        request(URLString: endPoint.path, httpMethod: .put, parameters: parameters, headers: headers, loader: loader, success: success, failure: failure)
    }
    
    static func DELETE(endPoint : APIManager.EndPoint, parameters : [String : Any] = [:], headers : HTTPHeaders = [:], loader : Bool = true, success : @escaping ([String : Any]) -> Void, failure : @escaping (Error) -> Void) {
        
        request(URLString: endPoint.path, httpMethod: .delete, parameters: parameters, headers: headers, loader: loader, success: success, failure: failure)
    }
    
    static func PATCH(endPoint : APIManager.EndPoint, parameters : [String : Any] = [:], headers : HTTPHeaders = [:], loader : Bool = true, success : @escaping ([String : Any]) -> Void, failure : @escaping (Error) -> Void) {
        
        request(URLString: endPoint.path, httpMethod: .patch, parameters: parameters, headers: headers, loader: loader, success: success, failure: failure)
    }
    
    static func request(URLString : String, httpMethod : HTTPMethod, parameters : [String : Any] = [:], encoding: ParameterEncoding = JSONEncoding.default, headers : HTTPHeaders = [:], loader : Bool = true, manuallyHandleResponse : Bool = false, success : @escaping ([String : Any]) -> Void, failure : @escaping (Error) -> Void) {
        
        DispatchQueue.main.async{
            UIApplication.shared.isNetworkActivityIndicatorVisible = true
        }
        
        let request = alamoFireManager.request(URLString, method: httpMethod, parameters: parameters, encoding: encoding, headers: headers)


        request.responseJSON { (response) in
            
            DispatchQueue.main.async{
                UIApplication.shared.isNetworkActivityIndicatorVisible = false
            }
            
            switch(response.result) {
                
            case .success(let value):

                if let dict = value as? [String : Any]{

                    if manuallyHandleResponse{
                        success(dict)
                    }else{
                        if let code = dict["code"] as? Int, code == 200{
                            success(dict)
                        }else{
                            let error = NSError(domain: "", code: dict["code"] as? Int ?? 600, userInfo: [NSLocalizedDescriptionKey : dict["message"] as? String ?? StringConstants.something_wrong.localized, "response": dict["data"] ?? ""])
                            failure(error)
                        }
                    }
                }else{
                    let error = NSError(domain: "", code: 600, userInfo: [NSLocalizedDescriptionKey: StringConstants.something_wrong.localized, "response": ""])
                    failure(error)
                }
            case .failure(let e):
                print(e.localizedDescription)
                failure(e)
            }
        }
    }
}
