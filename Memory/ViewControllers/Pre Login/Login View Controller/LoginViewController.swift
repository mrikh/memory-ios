//
//  LoginViewController.swift
//  Memory
//
//  Created by Mayank Rikh on 11/03/19.
//  Copyright © 2019 Mayank Rikh. All rights reserved.
//

import FontAwesome_swift
import UIKit

class LoginViewController: BaseViewController, KeyboardHandler {

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

    let viewModel = LoginViewModel()

    override func viewDidLoad() {
        super.viewDidLoad()

        initialSetup()
    }

    override func viewWillAppear(_ animated: Bool) {

        super.viewWillAppear(animated)
        addKeyboardObservers()
        navigationController?.setNavigationBarHidden(true, animated: true)
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

        sender.startAnimating()
    }

    @IBAction func facebookAction(_ sender: UIButton) {
    }

    @IBAction func googleAction(_ sender: UIButton) {
    }

    @IBAction func signUpAction(_ sender: UIButton) {

        let viewController = SignUpViewController.instantiate(fromAppStoryboard: .PreLogin)
        navigationController?.setViewControllers([viewController], animated: true)
    }

    @IBAction func skipAction(_ sender: UIButton) {

        FlowManager.gotToLandingScreen()
    }

    //MARK:- Private
    private func initialSetup(){

        loginButton.setTitle(StringConstants.login.localized, for: .normal)

        facebookContainerView.backgroundColor = Colors.fbColor
        googleContainerView.backgroundColor = Colors.googleColor

        facebookButton.setTitle(String.fontAwesomeIcon(name: FontAwesome.facebookF), for: .normal)
        facebookButton.setTitleColor(Colors.white, for: .normal)
        facebookButton.titleLabel?.font = UIFont.fontAwesome(ofSize: CGFloat(21.0).getFontSize, style: FontAwesomeStyle.brands)

        googleButton.setTitle(String.fontAwesomeIcon(name: FontAwesome.google), for: .normal)
        googleButton.setTitleColor(Colors.white, for: .normal)
        googleButton.titleLabel?.font = UIFont.fontAwesome(ofSize: CGFloat(21.0).getFontSize, style: FontAwesomeStyle.brands)

        emailTextField.configure(with: StringConstants.email.localized, text: nil, primaryColor: Colors.activeButtonTitleColor, unselectedBottomColor: Colors.inactiveButtonColor)
        passwordTextField.configure(with: StringConstants.password.localized, text: nil, primaryColor: Colors.activeButtonTitleColor, unselectedBottomColor: Colors.inactiveButtonColor)

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

extension LoginViewController : UITextFieldDelegate{

    func textFieldShouldReturn(_ textField: UITextField) -> Bool {

        if textField == emailTextField{
            passwordTextField.becomeFirstResponder()
        }else{
            view.endEditing(true)
        }

        return true
    }

    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {

        if string.containsEmoji {return false}

        if let temp = textField as? MRTextField{
            temp.errorString = nil
        }

        return true
    }

    func textFieldDidEndEditing(_ textField: UITextField) {

        if textField == emailTextField{
            emailTextField.errorString = viewModel.validateEmail(text: textField.text ?? "")
        }else{
            passwordTextField.errorString = viewModel.validatePassword(text: textField.text ?? "")
        }
    }
}
