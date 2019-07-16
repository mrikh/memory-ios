//
//  Annotation.swift
//  Memory
//
//  Created by Mayank Rikh on 16/07/19.
//  Copyright © 2019 Mayank Rikh. All rights reserved.
//

import Foundation
import MapKit

class Annotation : NSObject, MKAnnotation{

    let title : String?
    let subTitle : String?

    let coordinate : CLLocationCoordinate2D

    init(title : String?, subTitle : String?, coordinate : CLLocationCoordinate2D){

        self.title = title
        self.subTitle = subTitle
        self.coordinate = coordinate
    }
}
