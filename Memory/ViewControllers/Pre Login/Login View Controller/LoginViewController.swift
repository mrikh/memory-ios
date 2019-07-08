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

    @IBOutlet weak var forgotPassword: UIButton!
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

        viewModel.startLogin()
    }

    @IBAction func facebookAction(_ sender: UIButton) {
    }

    @IBAction func googleAction(_ sender: UIButton) {
    }

    @IBAction func signUpAction(_ sender: UIButton) {

        let viewController = SignUpViewController.instantiate(fromAppStoryboard: .PreLogin)
        navigationController?.setViewControllers([viewController], animated: true)
    }

    @IBAction func forgotAction(_ sender: UIButton) {

        let viewController = ForgotPasswordViewController.instantiate(fromAppStoryboard: .PreLogin)
        navigationController?.pushViewController(viewController, animated: true)
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

        emailTextField.configure(with: StringConstants.email.localized, text: nil, primaryColor: Colors.bgColor, unselectedBottomColor: Colors.bgColor.withAlphaComponent(0.25))
        passwordTextField.configure(with: StringConstants.password.localized, text: nil, primaryColor: Colors.bgColor, unselectedBottomColor: Colors.bgColor.withAlphaComponent(0.25))

        signUpLabel.text = StringConstants.no_account.localized
        signUpLabel.textColor = Colors.black
        signUpLabel.font = CustomFonts.avenirMedium.withSize(12.0)

        signUpButton.setAttributedTitle(NSAttributedString(string : StringConstants.sign_up.localized, attributes : [.foregroundColor : Colors.bgColor, .font : CustomFonts.avenirHeavy.withSize(12.0), .underlineStyle : NSUnderlineStyle.single.rawValue]), for: .normal)

        orLabel.text = StringConstants.or.localized
        orLabel.font = CustomFonts.avenirMedium.withSize(12.0)
        orLabel.textColor = Colors.black

        skipButton.setAttributedTitle(NSAttributedString(string : StringConstants.explore.localized, attributes : [.foregroundColor : Colors.bgColor, .font : CustomFonts.avenirHeavy.withSize(12.0), .underlineStyle : NSUnderlineStyle.single.rawValue]), for: .normal)

        forgotPassword.setAttributedTitle(NSAttributedString(string : "\(StringConstants.forgot_pass.localized)?", attributes : [.foregroundColor : Colors.bgColor, .font : CustomFonts.avenirHeavy.withSize(12.0), .underlineStyle : NSUnderlineStyle.single.rawValue]), for: .normal)

        skipLabel.text = StringConstants.the_application.localized
        skipLabel.font = CustomFonts.avenirMedium.withSize(12.0)
        skipLabel.textColor = Colors.black

        viewModel.delegate = self

        viewModel.emailError.bind { [weak self] (string) in
            self?.emailTextField.errorString = string

            if let _ = string{
                self?.emailTextField.shakeIfNeeded()
                self?.emailTextField.showErrorMessage()
            }else{
                self?.emailTextField.hideErrorMessage()
            }
        }

        viewModel.passwordError.bind { [weak self] (string) in
            self?.passwordTextField.errorString = string

            if let _ = string{
                self?.passwordTextField.shakeIfNeeded()
                self?.passwordTextField.showErrorMessage()
            }else{
                self?.passwordTextField.hideErrorMessage()
            }
        }
    }
}

extension LoginViewController : UITextFieldDelegate{

    func textFieldShouldReturn(_ textField: UITextField) -> Bool {

        if textField == emailTextField{
            passwordTextField.becomeFirstResponder()
        }else{
            view.endEditing(true)
        }

        return false
    }

    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {

        if string.containsEmoji {return false}

        let currentText = textField.text ?? ""
        let replacedText = (currentText as NSString).replacingCharacters(in: range, with: string)

        if textField == emailTextField{
            viewModel.email.value = replacedText
        }else{
            viewModel.password.value = replacedText
        }

        if let temp = textField as? MRTextField{
            temp.errorString = nil
            temp.hideErrorMessage()
        }

        return true
    }

    func textFieldDidEndEditing(_ textField: UITextField) {

        if textField == emailTextField{
            viewModel.validateEmail(text: textField.text ?? "")
        }else{
            viewModel.validatePassword(text: textField.text ?? "")
        }
    }
}

extension LoginViewController : LoginVewModelDelegate{

    func resentMail(message: String) {
        showAlert(StringConstants.success.localized, withMessage: message, withCompletion: nil)
    }

    func validationSuccess() {
        loginButton.startAnimating()
    }

    func success() {
        FlowManager.gotToLandingScreen()
    }

    func receivedResponse() {
        loginButton.stopAnimating()
    }

    func emailNotVerified(email : String, message : String) {

        showAlert(StringConstants.alert.localized, withMessage: message, andShowCancel: true, okayTitle : StringConstants.resend_email.localized) { [weak self] in

            self?.viewModel.resendEmail(email : email)
        }
    }
}
