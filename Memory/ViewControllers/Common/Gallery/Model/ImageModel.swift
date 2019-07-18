//
//  ImageModel.swift
//  Memory
//
//  Created by Mayank Rikh on 18/07/19.
//  Copyright © 2019 Mayank Rikh. All rights reserved.
//

import UIKit

struct ImageModel{

    var image : UIImage
    var localId : String?

    init(image : UIImage, localId : String?){
        self.image = image
        self.localId = localId
    }
}
