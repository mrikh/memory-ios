//
//  NoAccessView.swift
//  Memory
//
//  Created by Mayank Rikh on 07/08/19.
//  Copyright © 2019 Mayank Rikh. All rights reserved.
//

import UIKit

class NoAccessView: UIView {

    @IBOutlet weak var infoLabel: UILabel!
    @IBOutlet weak var mainButton: UIButton!

    private var action : (()->())?

    override func awakeFromNib() {

        super.awakeFromNib()

        infoLabel.font = CustomFonts.avenirMedium.withSize(16.0)
        infoLabel.textColor = Colors.bgColor
    }

    func configure(infoText : String?, with buttonText : String?, action : (()->())?){

        infoLabel.text = infoText

        if let text = buttonText{
            mainButton.isHidden = false
            mainButton.setAttributedTitle(NSAttributedString(string : text, attributes : [.foregroundColor : Colors.bgColor, .font : CustomFonts.avenirHeavy.withSize(12.0), .underlineStyle : NSUnderlineStyle.single.rawValue]), for: .normal)
        }else{
            mainButton.isHidden = true
        }

        self.action = action
    }

    //MARK:- IBAction
    @IBAction func mainAction(_ sender: UIButton) {
        action?()
    }
}
