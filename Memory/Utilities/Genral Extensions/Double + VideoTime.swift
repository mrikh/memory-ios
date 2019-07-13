//
//  Double + VideoTime.swift
//  Memory
//
//  Created by Mayank Rikh on 11/12/18.
//  Copyright © 2018 Mayank Rikh. All rights reserved.
//

import Foundation

extension Double{

    var timerString : String{

        let minutes = Int((self / 60).truncatingRemainder(dividingBy: 60))
        let seconds = Int(self.truncatingRemainder(dividingBy: 60))
        return String(format:"%02i:%02i", minutes, seconds)
    }
}
