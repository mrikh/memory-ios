//
//  Timeinterval + Date.swift
//  Memory
//
//  Created by Mayank Rikh on 14/07/19.
//  Copyright © 2019 Mayank Rikh. All rights reserved.
//

import Foundation

extension Date{

    var dateString : String?{

        let formatter = DateFormatter()
        formatter.dateFormat = DateFormat.displayDateFormat
        return formatter.string(from: self)
    }
}
