//
//  Defaults.swift
//  Memory
//
//  Created by Mayank Rikh on 25/01/19.
//  Copyright © 2019 Mayank Rikh. All rights reserved.
//

import Foundation

enum Defaults { }

extension Defaults {
    
    enum Key : String {
        case userInfo
    }
}

extension Defaults {
    
    static func value(forKey key: Key, file : String = #file, line : Int = #line, function : String = #function) -> Any? {
        
        guard let value = UserDefaults.standard.object(forKey: key.rawValue) else { return nil }
        return value
    }
    
    static func save(value : Any, forKey key : Key) {
        
        UserDefaults.standard.set(value, forKey: key.rawValue)
        UserDefaults.standard.synchronize()
    }
    
    static func removeValue(forKey key : Key) {
        
        UserDefaults.standard.removeObject(forKey: key.rawValue)
        UserDefaults.standard.synchronize()
    }
    
    static func removeAllValues() {
        guard let appDomain = Bundle.main.bundleIdentifier else {return}
        UserDefaults.standard.removePersistentDomain(forName: appDomain)
        UserDefaults.standard.synchronize()
    }
}
