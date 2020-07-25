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

    @IBOutlet weak var questionLabel: UILabel!
    @IBOutlet weak var infoLabel: UILabel!
    @IBOutlet weak var hintLabel: UILabel!

    override func awakeFromNib() {

        super.awakeFromNib()

        backgroundColor = Colors.white

        questionLabel.text = StringConstants.select_venue_photos.localized
        questionLabel.textColor = Colors.bgColor
        questionLabel.font = CustomFonts.avenirHeavy.withSize(22.0)

        infoLabel.text = StringConstants.info_photos.localized
        infoLabel.textColor = Colors.bgColor
        infoLabel.font = CustomFonts.avenirLight.withSize(14.0)

        hintLabel.text = nil

        let string = NSMutableAttributedString(string: "\(StringConstants.hint.localized) ", attributes: [.foregroundColor : Colors.bgColor, .font: CustomFonts.avenirMedium.withSize(14.0)])
        string.append(NSAttributedString(string: StringConstants.awesome_setup.localized, attributes: [.foregroundColor : Colors.bgColor, .font : CustomFonts.avenirLight.withSize(14.0)]))

        hintLabel.attributedText = string
    }
}
