//
//  OTPViewController.swift
//  Memory
//
//  Created by Mayank Rikh on 10/07/19.
//  Copyright © 2019 Mayank Rikh. All rights reserved.
//

import UIKit

class OTPViewController: BaseViewController {

    @IBOutlet weak var infoLabel: UILabel!
    @IBOutlet weak var infoContainerView: UIView!
    @IBOutlet weak var firstTextField: UITextField!
    @IBOutlet weak var secondTextField: UITextField!
    @IBOutlet weak var thirdTextField: UITextField!
    @IBOutlet weak var fourthTextField: UITextField!
    @IBOutlet weak var resendButton: UIButton!
    @IBOutlet weak var doneButton: MRAnimatingButton!

    override func viewDidLoad() {
        super.viewDidLoad()

        initialSetup()
    }

    //MARK:- IBAction
    @IBAction func resendAction(_ sender: UIButton) {
    }

    @IBAction func doneAction(_ sender: MRAnimatingButton) {
    }

    //MARK:- Private
    private func initialSetup(){

        infoContainerView.addShadow(3.0)

        infoLabel.text = StringConstants.phone_info.localized
        infoLabel.textColor = Colors.black
        infoLabel.font = CustomFonts.avenirMedium.withSize(16.0)

        doneButton.setTitle(StringConstants.done.localized, for: .normal)

        resendButton.setTitle(StringConstants.resend.localized, for: .normal)
        resendButton.setTitleColor(Colors.bgColor.withAlphaComponent(0.25), for: .disabled)
        resendButton.setTitleColor(Colors.bgColor, for: .normal)
        resendButton.titleLabel?.font = CustomFonts.avenirMedium.withSize(12.0)
        resendButton.isEnabled = false
    }
}
