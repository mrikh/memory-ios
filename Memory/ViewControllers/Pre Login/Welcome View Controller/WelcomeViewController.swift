//
//  WelcomeViewController.swift
//  Memory
//
//  Created by Mayank Rikh on 11/03/19.
//  Copyright © 2019 Mayank Rikh. All rights reserved.
//

import UIKit

class WelcomeViewController: BaseViewController, KeyboardHandler {

    @IBOutlet weak var loginButton: MRAnimatingButton!
    @IBOutlet weak var facebookContainerView: UIView!
    @IBOutlet weak var googleContainerView: UIView!
    @IBOutlet weak var facebookButton: UIButton!
    @IBOutlet weak var googleButton: UIButton!
    @IBOutlet weak var emailTextField: MRTextField!
    @IBOutlet weak var passwordTextField: MRTextField!

    @IBOutlet weak var signUpLabel: UILabel!
    @IBOutlet weak var signUpButton: UIButton!
    @IBOutlet weak var orLabel: UILabel!
    @IBOutlet weak var skipButton: UIButton!
    @IBOutlet weak var skipLabel: UILabel!

    @IBOutlet weak var bottomConstraint: NSLayoutConstraint!

    var bottomConstraints: [NSLayoutConstraint]{
        return [bottomConstraint]
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        initialSetup()
    }

    override func viewWillAppear(_ animated: Bool) {

        super.viewWillAppear(animated)
        addKeyboardObservers()
    }

    override func viewWillDisappear(_ animated: Bool) {

        removeKeyboardObservers()
        super.viewWillDisappear(animated)
    }

    override func viewDidLayoutSubviews() {

        super.viewDidLayoutSubviews()
        facebookContainerView.layer.cornerRadius = facebookContainerView.bounds.width/2.0
        googleContainerView.layer.cornerRadius = googleContainerView.bounds.width/2.0
    }

    //MARK:- IBAction
    @IBAction func loginAction(_ sender: MRAnimatingButton) {
    }

    @IBAction func facebookAction(_ sender: UIButton) {
    }

    @IBAction func googleAction(_ sender: UIButton) {
    }

    @IBAction func signUpAction(_ sender: UIButton) {
    }

    @IBAction func skipAction(_ sender: UIButton) {
    }

    //MARK:- Private
    private func initialSetup(){

        loginButton.setTitle(StringConstants.login.localized, for: .normal)

        facebookContainerView.backgroundColor = Colors.fbColor
        googleContainerView.backgroundColor = Colors.googleColor

        facebookButton.setTitle("", for: .normal)
        facebookButton.setTitleColor(Colors.white, for: .normal)
        facebookButton.titleLabel?.font = CustomFonts.fontAwesomeBrands.withSize(21.0)

        googleButton.setTitle("", for: .normal)
        googleButton.setTitleColor(Colors.white, for: .normal)
        googleButton.titleLabel?.font = CustomFonts.fontAwesomeBrands.withSize(21.0)

        emailTextField.configure(with: StringConstants.email.localized)
        passwordTextField.configure(with: StringConstants.password.localized)

        signUpLabel.text = StringConstants.no_account.localized
        signUpLabel.textColor = Colors.white
        signUpLabel.font = CustomFonts.avenirMedium.withSize(12.0)

        signUpButton.setAttributedTitle(NSAttributedString(string : StringConstants.sign_up.localized, attributes : [.foregroundColor : Colors.bgColor, .font : CustomFonts.avenirHeavy.withSize(12.0), .underlineStyle : NSUnderlineStyle.single.rawValue]), for: .normal)

        orLabel.text = StringConstants.or.localized
        orLabel.font = CustomFonts.avenirMedium.withSize(12.0)
        orLabel.textColor = Colors.white

        skipButton.setAttributedTitle(NSAttributedString(string : StringConstants.explore.localized, attributes : [.foregroundColor : Colors.bgColor, .font : CustomFonts.avenirHeavy.withSize(12.0), .underlineStyle : NSUnderlineStyle.single.rawValue]), for: .normal)

        skipLabel.text = StringConstants.the_application.localized
        skipLabel.font = CustomFonts.avenirMedium.withSize(12.0)
        skipLabel.textColor = Colors.white
    }
}
