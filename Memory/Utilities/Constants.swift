//
//  Constants.swift
//  Memory
//
//  Created by Mayank Rikh on 25/01/19.
//  Copyright © 2019 Mayank Rikh. All rights reserved.
//

import UIKit

struct ValidationConstants{

    static let eventNameLimit = 30
    static let imageCountLimit = 10
    static let additionalInfoTextLimit = 200
}

struct APIKeys{
    static let googleKey = "AIzaSyAz_ArHWhBwbKkUTp70dooETgqVJ33TSSQ"
    static let openWeather = "157d003cf7a8fb8ed865b0ade9f8d134"
}

struct DeviceInfo{
    
    static let deviceId = UIDevice.current.identifierForVendor?.uuidString
    static var deviceToken = ""
    static let platform = "2"
}

struct AWSKeys{

    static let pool_id = "eu-west-1:ac02e7b7-588d-4189-981c-2007e52009f9"
    static let bucket_name = "memories-app-ios"
    static let s3BaseUrl = "https://s3.eu-west-1.amazonaws.com/"
}

struct DateFormat{

    static let displayDateFormat = "EEE, MMM dd, yyyy h:mm a"
    static let timeFormat = "h:mm a"
    static let isoFormat = "yyyy-MM-dd'T'HH:mm:ss.SSS'Z'"
}

struct NotificationKeys{

    static let eventCreated = "eventCreated"
}

struct LocationConstants{

    static let defaultLat = 28.6139
    static let defaultLong = 77.2090
}
