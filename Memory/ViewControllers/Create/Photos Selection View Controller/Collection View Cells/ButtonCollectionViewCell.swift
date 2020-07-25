//
//  ButtonCollectionViewCell.swift
//  Memory
//
//  Created by Mayank Rikh on 17/07/19.
//  Copyright © 2019 Mayank Rikh. All rights reserved.
//

import FontAwesome_swift
import UIKit

class ButtonCollectionViewCell: UICollectionViewCell {

    @IBOutlet weak var plusImageView: UIImageView!
    @IBOutlet weak var containerView: UIView!

    override func awakeFromNib() {

        super.awakeFromNib()

        containerView.layer.cornerRadius = 10.0
        containerView.backgroundColor = Colors.textFieldBorderColor.withAlphaComponent(0.7)

        plusImageView.image = UIImage.fontAwesomeIcon(name: .plus, style: .solid, textColor: Colors.white, size: CGSize(width : 25.0, height : 25.0))
    }
}
