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

        galleryButton.setTitleColor(Colors.bgColor, for: .normal)
        galleryButton.titleLabel?.font = UIFont.fontAwesome(ofSize: CGFloat(42.0).getFontSize, style: FontAwesomeStyle.solid)
        galleryButton.setTitle(String.fontAwesomeIcon(name: FontAwesome.cameraRetro), for: .normal)
    }

    @IBAction func galleryAction(_ sender: UIButton) {

        action?()
    }
}
