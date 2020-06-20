//
//  PhotoHeaderCollectionReusableView.swift
//  Memory
//
//  Created by Mayank Rikh on 17/07/19.
//  Copyright © 2019 Mayank Rikh. All rights reserved.
//

import FontAwesome_swift
import UIKit

class PhotoHeaderCollectionReusableView: UICollectionReusableView {
        
    @IBOutlet weak var galleryButton: UIButton!

    var action : (()->())?

    override func awakeFromNib() {

        super.awakeFromNib()

        galleryButton.configureFontAwesome(name: .cameraRetro, titleColor: Colors.bgColor, size: 42.0, style: FontAwesomeStyle.solid)
    }

    @IBAction func galleryAction(_ sender: UIButton) {

        action?()
    }
}
