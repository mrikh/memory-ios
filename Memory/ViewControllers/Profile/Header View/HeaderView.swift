//
//  HeaderView.swift
//  GullyBeatsBeta
//
//  Created by Mayank on 28/11/18.
//  Copyright © 2018 Appinventiv. All rights reserved.
//

import FontAwesome_swift
import UIKit

class HeaderView: UIView {

    var upcomingAction : (()->())?
    var invitedAction : (()->())?
    var completedAction : (()->())?

    @IBOutlet weak var underlineView: UIView!
    @IBOutlet weak var mainImageView: UIImageView!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var upcomingButton: UIButton!
    @IBOutlet weak var invitedButton: UIButton!
    @IBOutlet weak var completedButton: UIButton!

    override func awakeFromNib() {

        super.awakeFromNib()

        nameLabel.font = CustomFonts.avenirHeavy.withSize(16.0)
        nameLabel.textColor = Colors.bgColor

        mainImageView.layer.cornerRadius = 10.0

        underlineView.backgroundColor = Colors.bgColor
        configureButton(button: upcomingButton, text: .calendarCheck)
        configureButton(button: invitedButton, text: .calendarPlus)
        configureButton(button: completedButton, text: .checkDouble, style : .solid)
    }

    func configure(name : String?, imageUrl : String?){

        nameLabel.text = name

        if let urlString = imageUrl{
            mainImageView.setImageWithCompletion(urlString)
        }
    }

    //MARK:- IBAction
    @IBAction func upcomingAction(_ sender: UIButton) {
        upcomingAction?()
    }

    @IBAction func invitedAction(_ sender: UIButton) {
        invitedAction?()
    }

    @IBAction func completedAction(_ sender: UIButton) {
        completedAction?()
    }

    //MARK:- Private
    private func configureButton(button : UIButton, text : FontAwesome, style : FontAwesomeStyle = .regular){

        button.titleLabel?.font = UIFont.fontAwesome(ofSize: 20.0, style: style)
        button.setTitleColor(Colors.bgColor, for: .normal)
        button.setTitle(String.fontAwesomeIcon(name: text), for: .normal)
    }
}
