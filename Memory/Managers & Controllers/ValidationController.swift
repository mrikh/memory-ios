//
//  ValidationController.swift
//  GullyBeatsBeta
//
//  Created by Mayank on 03/12/18.
//  Copyright © 2018 Mayank Rikh. All rights reserved.
//

import Foundation

class ValidationController{

    static func validateName(_ string : String) -> String?{
        
        if string.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty{
            return StringConstants.name_empty_error.localized
        }
        
        return nil
    }
    
    static func validateEmail(_ string : String) -> String?{
        
        if string.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty{
            return StringConstants.email_not_empty.localized
        }
        
        let matchResult = string.matches(pattern: "(?:[\\p{L}0-9!#$%\\&'*+/=?\\^_`{|}~-]+(?:\\.[\\p{L}0-9!#$%\\&'*+/=?\\^_`{|}" + "~-]+)*|\"(?:[\\x01-\\x08\\x0b\\x0c\\x0e-\\x1f\\x21\\x23-\\x5b\\x5d-\\" +
            "x7f]|\\\\[\\x01-\\x09\\x0b\\x0c\\x0e-\\x7f])*\")@(?:(?:[\\p{L}0-9](?:[a-" +
            "z0-9-]*[\\p{L}0-9])?\\.)+[\\p{L}0-9](?:[\\p{L}0-9-]*[\\p{L}0-9])?|\\[(?:(?:25[0-5" +
            "]|2[0-4][0-9]|[01]?[0-9][0-9]?)\\.){3}(?:25[0-5]|2[0-4][0-9]|[01]?[0-" +
            "9][0-9]?|[\\p{L}0-9-]*[\\p{L}0-9]:(?:[\\x01-\\x08\\x0b\\x0c\\x0e-\\x1f\\x21" +
            "-\\x5a\\x53-\\x7f]|\\\\[\\x01-\\x09\\x0b\\x0c\\x0e-\\x7f])+)\\])")
        let isAlphanumeric = "\(string.prefix(1))".isAlphanumeric
        
        if !matchResult || !isAlphanumeric{
            return StringConstants.invalid_email.localized
        }
        
        return nil
    }
    
    static func validatePassword(_ string : String) -> String?{
        
        if string.count < 8{
            return StringConstants.invalid_password.localized
        }
        
        return nil
    }
}
