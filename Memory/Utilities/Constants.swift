//
//  Constants.swift
//  Memory
//
//  Created by Mayank Rikh on 25/01/19.
//  Copyright © 2019 Mayank Rikh. All rights reserved.
//

import UIKit

struct DeviceInfo{
    
    static let deviceId = UIDevice.current.identifierForVendor?.uuidString
    static var deviceToken = ""
    static let platform = "2"
}
