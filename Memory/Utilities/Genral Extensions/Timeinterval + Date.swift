//
//  Timeinterval + Date.swift
//  Memory
//
//  Created by Mayank Rikh on 14/07/19.
//  Copyright © 2019 Mayank Rikh. All rights reserved.
//

import Foundation

extension TimeInterval{

    var dateString : String?{

        let formatter = DateFormatter()
        formatter.dateFormat = DateFormat.displayDateFormat
        return formatter.string(from: Date(timeIntervalSince1970: self))
    }
}
