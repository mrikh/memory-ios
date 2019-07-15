//
//  ForgotPasswordViewController.swift
//  Memory
//
//  Created by Mayank Rikh on 08/07/19.
//  Copyright © 2019 Mayank Rikh. All rights reserved.
//

import UIKit

class ForgotPasswordViewController: BaseViewController, KeyboardHandler {

    @IBOutlet weak var bottomConstraint: NSLayoutConstraint!
    @IBOutlet weak var forgotTitle: UILabel!
    @IBOutlet weak var infoLabel: UILabel!
    @IBOutlet weak var emailTextField: MRTextField!
    @IBOutlet weak var confirmButton: MRAnimatingButton!

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
        navigationController?.setNavigationBarHidden(false, animated: true)
    }

    override func viewDidLayoutSubviews() {

        super.viewDidLayoutSubviews()
        extraPadding = view.safeAreaInsets.bottom
    }

    override func viewWillDisappear(_ animated: Bool) {

        removeKeyboardObservers()
        super.viewWillDisappear(animated)
    }

    //MARK:- IBAction
    @IBAction func confirmAction(_ sender: MRAnimatingButton) {

        let errorString = ValidationController.validateEmail(emailTextField.text?.trimmingCharacters(in: .whitespacesAndNewlines) ?? "")

        if let temp = errorString, !temp.isEmpty{
            emailTextField.errorString = errorString
            emailTextField.shakeIfNeeded()
            emailTextField.showErrorMessage(true)
            return
        }

        sender.startAnimating()
        APIManager.forgotPass(params: ["email" : emailTextField.text?.trimmingCharacters(in: .whitespacesAndNewlines) ?? ""]) { [weak self] (json, error) in
            sender.stopAnimating()
            if let tempJson = json{
                self?.showAlert(StringConstants.success.localized, withMessage: tempJson["message"].stringValue, withCompletion: { [weak self] in
                    self?.navigationController?.popViewController(animated: true)
                })
            }else{
                self?.showAlert(StringConstants.alert.localized, withMessage: error?.localizedDescription, withCompletion: nil)
            }
        }
    }

    //MARK:- Private
    private func initialSetup(){

        forgotTitle.text = StringConstants.forgot_pass.localized
        forgotTitle.textColor = Colors.black
        forgotTitle.font = CustomFonts.avenirHeavy.withSize(25.0)

        infoLabel.text = StringConstants.forgot_info.localized
        infoLabel.textColor = Colors.black
        infoLabel.font = CustomFonts.avenirMedium.withSize(14.0)

        emailTextField.configure(with: StringConstants.email.localized, text: nil, primaryColor: Colors.bgColor, unselectedBottomColor: Colors.bgColor.withAlphaComponent(0.25))

        confirmButton.setTitle(StringConstants.done.localized, for: .normal)

        navigationItem.title = nil

        let gesture = UITapGestureRecognizer(target: self, action: #selector(handleTap))
        view.addGestureRecognizer(gesture)
    }

    @objc func handleTap(){
        view.endEditing(true)
    }
}

extension ForgotPasswordViewController : UITextFieldDelegate{

    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {

        if string.containsEmoji {return false}
        emailTextField.errorString = nil
        emailTextField.hideErrorMessage()
        return true
    }

    func textFieldShouldReturn(_ textField: UITextField) -> Bool {

        view.endEditing(true)
        return false
    }
}
