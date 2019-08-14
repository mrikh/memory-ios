//
//  ExploreEventTableViewCell.swift
//  Memory
//
//  Created by Mayank Rikh on 14/08/19.
//  Copyright © 2019 Mayank Rikh. All rights reserved.
//

import UIKit

class ExploreEventTableViewCell: UITableViewCell {

    @IBOutlet weak var containerView: UIView!
    @IBOutlet weak var mainImageView: UIImageView!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var addressLabel: UILabel!
    @IBOutlet weak var dateLabel: UILabel!
    @IBOutlet weak var joinContainerView: UIView!
    @IBOutlet weak var joinButton: UIButton!

    var joinAction : (()->())?

    override func awakeFromNib() {
        super.awakeFromNib()

        containerView.addShadow(3.0)

        nameLabel.textColor = Colors.black
        nameLabel.font = CustomFonts.avenirMedium.withSize(17.0)

        addressLabel.textColor = Colors.black
        addressLabel.font = CustomFonts.avenirLight.withSize(14.0)

        dateLabel.textColor = Colors.black
        dateLabel.font = CustomFonts.avenirLight.withSize(14.0)

        joinContainerView.addShadow(3.0)

        joinButton.setTitle(StringConstants.join.localized, for: .normal)
        joinButton.setTitleColor(Colors.black, for: .normal)
        joinButton.titleLabel?.font = CustomFonts.avenirMedium.withSize(14.0)
        joinContainerView.backgroundColor = Colors.white
    }

    override func prepareForReuse() {

        super.prepareForReuse()

        joinButton.setTitleColor(Colors.black, for: .normal)
        joinContainerView.backgroundColor = Colors.white
    }

    func configure(model : EventDetailModel){

        
    }

    //MARK:- IBAction
    @IBAction func joinButtonAction(_ sender: UIButton) {

        joinAction?()
    }
}
