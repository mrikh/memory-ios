//
//  Utilities.swift
//  Memory
//
//  Created by Mayank Rikh on 25/01/19.
//  Copyright © 2019 Mayank Rikh. All rights reserved.
//

import Foundation

class Utilities{

    static var uniqueName : String{
        return "\(UserModel.current.user_id)\(Int64(Date().timeIntervalSince1970 * 1000))"
    }

    static func resizeImage(_ sourceImage : UIImage, toWidth scaledToWidth : CGFloat = 1024.0) -> UIImage? {

        let oldWidth = sourceImage.size.width
        let scaleFactor = scaledToWidth / oldWidth

        let newHeight = sourceImage.size.height * scaleFactor
        let newWidth = oldWidth * scaleFactor

        UIGraphicsBeginImageContext(CGSize(width:newWidth, height:newHeight))
        sourceImage.draw(in: CGRect(x:0, y:0, width:newWidth, height:newHeight))
        let newImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        return newImage
    }
}
