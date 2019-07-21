//
//  Utilities.swift
//  Memory
//
//  Created by Mayank Rikh on 25/01/19.
//  Copyright © 2019 Mayank Rikh. All rights reserved.
//

import Foundation
import MapKit

class Utilities{

    static var uniqueName : String{
        return "\(UserModel.current.userId)\(Int64(Date().timeIntervalSince1970 * 1000))"
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

    static func openMaps(_ latitude : Double, andLongitude longitude: Double, title : String?){

        let coordinate = CLLocationCoordinate2DMake(latitude,longitude)

        let placemark = MKPlacemark(coordinate: coordinate)

        let mapItem = MKMapItem(placemark: placemark)
        mapItem.name = title

        mapItem.openInMaps(launchOptions: nil)
    }
}
