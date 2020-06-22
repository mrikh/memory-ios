//
//  VerifyEmailViewController.swift
//  Memory
//
//  Created by Mayank Rikh on 22/06/20.
//  Copyright © 2020 Mayank Rikh. All rights reserved.
//

import UIKit

class VerifyEmailViewController: BaseViewController, KeyboardHandler {

    @IBOutlet weak var bottomConstraint: NSLayoutConstraint!
    @IBOutlet weak var skipButton: UIButton!
    @IBOutlet weak var orLabel: UILabel!
    @IBOutlet weak var headingLabel: UILabel!
    @IBOutlet weak var infoLabel: UILabel!
    @IBOutlet weak var otpStoryboardView: OTPCodeStoryboardView!
    @IBOutlet weak var resendButton: UIButton!
    @IBOutlet weak var verifyButton: MRAnimatingButton!

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
        navigationController?.setNavigationBarHidden(true, animated: true)
    }

    override func viewDidLayoutSubviews() {

        super.viewDidLayoutSubviews()
        extraPadding = view.safeAreaInsets.bottom
    }

    override func viewDidAppear(_ animated: Bool) {

        super.viewDidAppear(animated)
        if isMovingToParent || isBeingPresented{
            otpStoryboardView.startEditing = true
        }
    }

    override func viewWillDisappear(_ animated: Bool) {

        removeKeyboardObservers()
        super.viewWillDisappear(animated)
    }
    

    //MARK:- IBAction
    @IBAction func resendAction(_ sender: UIButton) {

        showAlert(StringConstants.alert.localized, withMessage: StringConstants.resend_message.localized) {
            [weak self] in

            APIManager.resendEmail(email: UserModel.current.email) { [weak self] (json, error) in
                if let tempError = error{
                    self?.showAlert(StringConstants.alert.localized, withMessage: tempError.localizedDescription, withCompletion: nil)
                }
            }
        }
    }

    @IBAction func verifyAction(_ sender: UIButton) {

        verifyButton.startAnimating()
        APIManager.verifyEmail(otp: otpStoryboardView.otpView?.otpArray.joined() ?? "") { [weak self] (json, error) in
            self?.verifyButton.stopAnimating()
            if let _ = json{
                UserModel.current.emailVerified = true
                UserModel.current.saveToUserDefaults()
                let viewController = ProfilePhotoViewController.instantiate(fromAppStoryboard: .PreLogin)
                self?.navigationController?.setViewControllers([viewController], animated: true)
            }else{
                self?.showAlert(StringConstants.alert.localized, withMessage: error?.localizedDescription, withCompletion: nil)
            }
        }
    }

    @IBAction func skipAction(_ sender: UIButton) {

        let viewController = ProfilePhotoViewController.instantiate(fromAppStoryboard: .PreLogin)
        navigationController?.setViewControllers([viewController], animated: true)
    }

    //MARK:- Private
    private func initialSetup(){

        headingLabel.text = StringConstants.verify_email.localized
        headingLabel.textColor = Colors.black
        headingLabel.font = CustomFonts.avenirHeavy.withSize(25.0)

        infoLabel.text = StringConstants.verify_email_info.localized
        infoLabel.textColor = Colors.black
        infoLabel.font = CustomFonts.avenirMedium.withSize(14.0)

        resendButton.setTitle(StringConstants.resend_code.localized, for: .normal)
        resendButton.setTitleColor(Colors.bgColor, for: .normal)
        resendButton.titleLabel?.font = CustomFonts.avenirMedium.withSize(15.0)

        verifyButton.setTitle(StringConstants.confirm.localized, for: .normal)

        orLabel.text = StringConstants.or_do.localized
        orLabel.textColor = Colors.black
        orLabel.font = CustomFonts.avenirMedium.withSize(12.0)

        skipButton.setAttributedTitle(NSAttributedString(string : StringConstants.later.localized, attributes : [.foregroundColor : Colors.bgColor, .font : CustomFonts.avenirHeavy.withSize(12.0), .underlineStyle : NSUnderlineStyle.single.rawValue]), for: .normal)

        view.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(handleTap)))
    }

    @objc private func handleTap(){

        view.endEditing(true)
    }
}
