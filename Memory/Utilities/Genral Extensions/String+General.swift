//
//  String+General.swift
//  Memory
//
//  Created by Mayank Rikh on 25/01/19.
//  Copyright © 2019 Mayank Rikh. All rights reserved.
//

import Foundation
import UIKit

extension String {
    
    /// Convert to double string without using number formatter
    var doubleVal : Double{
        
        if self.isEmpty{ return 0.0 }
        
        if let val = Double(self){
            return val
        }else{
            return 0.0
        }
    }
    
    
    /// Check if string is numeric or contains other characters
    ///
    /// - Returns: Return true if string is only numeric
    func isStringNumeric() -> Bool {
        
        let removingWhiteSpaces = self.trimmingCharacters(in: .whitespacesAndNewlines)
        
        let digits = CharacterSet(charactersIn: "0123456789").inverted
        let modifiedMobileString = removingWhiteSpaces.components(separatedBy: digits).joined(separator: "")
        
        return modifiedMobileString.count == self.count
    }
    
    var localized : String {
        
        return NSLocalizedString(self, tableName: nil, bundle: Bundle.main, value: "", comment: "")
    }
    
    
    /// Check if string contains emoji
    var containsEmoji: Bool {
        for scalar in unicodeScalars {
            switch scalar.value {
            case  0x1F600...0x1F64F, // Emoticons
            0x1F300...0x1F5FF, // Misc Symbols and Pictographs
            0x1F680...0x1F6FF, // Transport and Map
            0x1F1E6...0x1F1FF, // Regional country flags
            0x2600...0x26FF,   // Misc symbols
            0x2700...0x27BF,   // Dingbats
            0xFE00...0xFE0F,   // Variation Selectors
            0x1F900...0x1F9FF,  // Supplemental Symbols and Pictographs
            127000...127600, // Various asian characters
            65024...65039, // Variation selector
            9100...9300, // Misc items
            8400...8447: // Combining Diacritical Marks for Symbols
                return true
            default:
                continue
            }
        }
        return false
    }
    
    /// Get color from hex string
    ///
    /// - Returns: Color value from hex string
    func getColorFromHexString() -> UIColor {
        
        var cString:String = self.trimmingCharacters(in: .whitespacesAndNewlines).uppercased()
        
        if (cString.hasPrefix("#")) {
            cString.remove(at: cString.startIndex)
        }
        
        if ((cString.count) != 6) {
            return UIColor.gray
        }
        
        var rgbValue:UInt32 = 0
        Scanner(string: cString).scanHexInt32(&rgbValue)
        
        return UIColor(
            red: CGFloat((rgbValue & 0xFF0000) >> 16) / 255.0,
            green: CGFloat((rgbValue & 0x00FF00) >> 8) / 255.0,
            blue: CGFloat(rgbValue & 0x0000FF) / 255.0,
            alpha: CGFloat(1.0)
        )
    }
    
    func matches(pattern: String) -> Bool {
        return range(of: pattern, options: String.CompareOptions.regularExpression, range: nil, locale: nil) != nil
    }
    
    /// Check if string contains one or more letters.
    public var hasLetters: Bool {
        return rangeOfCharacter(from: .letters, options: .numeric, range: nil) != nil
    }
    
    /// Check if string contains one or more numbers.
    public var hasNumbers: Bool {
        return rangeOfCharacter(from: .decimalDigits, options: .literal, range: nil) != nil
    }
    
    /// Check if alphabetic or not
    public var isAlphabetic: Bool {
        return hasLetters && !hasNumbers
    }
    
    /// Add the passed image to the text and returns an Attributed String
    ///
    /// - Parameters:
    ///   - image: image to set
    ///   - width: width of the image to set
    ///   - height: height of the image to set
    ///   - yOffset: Spacing from the top for the image as sometimes images are not aligned with the text
    /// - Returns: Returns an instance of attributed string containing image and text
    func addImageToLabel(_ image : UIImage, withWidth width : CGFloat, withHeight height : CGFloat, yOffset : CGFloat = 2.0) -> NSAttributedString{
        
        let attachment = NSTextAttachment()
        attachment.image = image
        
        attachment.bounds = CGRect(x : 0, y: yOffset, width:width, height:height);
        let attachmentString = NSAttributedString(attachment: attachment)
        
        let finalString = NSMutableAttributedString(string: self + " ")
        let returnString = NSMutableAttributedString()
        
        returnString.append(finalString)
        returnString.append(attachmentString)
        
        return returnString
    }

    /// Decode string to base 64
    var base64Decoded: String {
        if let data = Data(base64Encoded: self) {
            return String(data: data, encoding: .utf8) ?? ""
        }
        return ""
    }
    
    /// Encode string to base 64
    var base64Encoded: String {
        return Data(self.utf8).base64EncodedString()
    }
    
    /// Remove unicode characters from string
    var unicodeRemovedString : String{
        
        if let data = self.data(using: .utf8, allowLossyConversion: false){
            let tempString = try? NSAttributedString(data: data, options: [.documentType: NSAttributedString.DocumentType.html], documentAttributes: nil)
            return tempString?.string ?? self
        }
        
        return self
    }
    
    /// Check if string is alpha numeric
    var isAlphanumeric: Bool {
        return !isEmpty && range(of: "[^a-zA-Z0-9]", options: .regularExpression) == nil
    }

    ///get width of text based on height and font
    func width(withConstrainedHeight height: CGFloat, font: UIFont) -> CGFloat {
        let constraintRect = CGSize(width: .greatestFiniteMagnitude, height: height)
        let boundingBox = self.boundingRect(with: constraintRect, options: .usesLineFragmentOrigin, attributes: [NSAttributedString.Key.font: font], context: nil)

        return ceil(boundingBox.width)
    }
}
