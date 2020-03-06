//
//  ExploreEventTableViewCell.swift
//  Memory
//
//  Created by Mayank Rikh on 14/08/19.
//  Copyright © 2019 Mayank Rikh. All rights reserved.
//

import UIKit

class ExploreEventTableViewCell: UITableViewCell {

    @IBOutlet weak var imageContainerView: UIView!
    @IBOutlet weak var imageHeightConstraint: NSLayoutConstraint!
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

        imageContainerView.addShadow(3.0)

        nameLabel.textColor = Colors.bgColor
        nameLabel.font = CustomFonts.avenirMedium.withSize(17.0)

        addressLabel.textColor = Colors.bgColor
        addressLabel.font = CustomFonts.avenirLight.withSize(14.0)

        dateLabel.textColor = Colors.bgColor
        dateLabel.font = CustomFonts.avenirLight.withSize(14.0)

        setupJoinButton(joined: false)

        joinContainerView.isHidden = !UserModel.isLoggedIn
        imageHeightConstraint.constant = UIScreen.main.bounds.height/3.0

        mainImageView.layer.cornerRadius = 15.0

        joinButton.titleLabel?.font = CustomFonts.avenirHeavy.withSize(12.0)
        joinContainerView.layer.cornerRadius = joinContainerView.bounds.height/2.0
    }

    override func prepareForReuse() {

        super.prepareForReuse()

        setupJoinButton(joined: false)
    }

    func configure(model : EventModel){

        nameLabel.text = model.eventName

        let attributedString = NSMutableAttributedString(string: model.addressTitle, attributes: [.foregroundColor : Colors.black, .font : CustomFonts.avenirMedium.withSize(14.0)])
        attributedString.append(NSAttributedString(string: ", \(model.addressDetail)", attributes: [.foregroundColor : Colors.black, .font : CustomFonts.avenirLight.withSize(14.0)]))
        addressLabel.attributedText = attributedString

        let formatter = DateFormatter()
        formatter.dateFormat = DateFormat.displayDateFormat
        if let date = model.startDate{
            dateLabel.text = formatter.string(from: date)
        }else{
            dateLabel.text = StringConstants.something_wrong.localized
        }

        setupJoinButton(joined: model.isAttending)

        mainImageView.setImageWithCompletion(model.photos.first ?? "")
    }

    //MARK:- IBAction
    @IBAction func joinButtonAction(_ sender: UIButton) {

        joinAction?()
    }

    //MARK:- Private
    private func setupJoinButton(joined : Bool){

        if joined{
            joinButton.setTitle(StringConstants.joined.localized, for: .normal)
            joinContainerView.backgroundColor = Colors.white
            joinButton.setTitleColor(Colors.black, for: .normal)
            joinButton.layer.borderColor = Colors.black.cgColor
            joinButton.layer.borderWidth = 1.0
        }else{
            joinButton.setTitle(StringConstants.join.localized, for: .normal)
            joinContainerView.backgroundColor = Colors.black
            joinButton.setTitleColor(Colors.white, for: .normal)
            joinButton.layer.borderWidth = 0.0
            joinButton.layer.borderColor = Colors.clear.cgColor
        }
    }
}
