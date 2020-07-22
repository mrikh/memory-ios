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
}

struct APIKeys{
    static let googleKey = "AIzaSyAz_ArHWhBwbKkUTp70dooETgqVJ33TSSQ"
}

struct DeviceInfo{
    
    static let deviceId = UIDevice.current.identifierForVendor?.uuidString
    static var deviceToken = ""
    static let platform = "2"
}

struct AWSKeys{

    static let pool_id = "ap-south-1:070613da-8801-4c0d-9fd5-bc60fb469cb5"
    static let bucket_name = "memoryies-app"
    static let s3BaseUrl = "https://s3.ap-south-1.amazonaws.com/"
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
