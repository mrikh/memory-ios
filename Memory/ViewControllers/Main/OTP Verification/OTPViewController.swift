//
//  OTPViewController.swift
//  Memory
//
//  Created by Mayank Rikh on 10/07/19.
//  Copyright © 2019 Mayank Rikh. All rights reserved.
//

import UIKit

class OTPViewController: BaseViewController {

    @IBOutlet weak var timerLabel: UILabel!
    @IBOutlet weak var infoLabel: UILabel!
    @IBOutlet weak var infoContainerView: UIView!
    @IBOutlet weak var firstTextField: CustomBackTextField!
    @IBOutlet weak var secondTextField: CustomBackTextField!
    @IBOutlet weak var thirdTextField: CustomBackTextField!
    @IBOutlet weak var fourthTextField: CustomBackTextField!
    @IBOutlet weak var resendButton: UIButton!
    @IBOutlet weak var doneButton: MRAnimatingButton!

    private var timer : Timer?
    private var counter = 300.0
    var viewModel = OTPViewModel()

    override func viewDidLoad() {
        super.viewDidLoad()

        initialSetup()
    }

    override func viewDidAppear(_ animated: Bool) {

        super.viewDidAppear(animated)

        if isMovingToParent || isBeingPresented{
            timer = Timer.scheduledTimer(timeInterval: 1.0, target: self, selector: #selector(updateLabel), userInfo: nil, repeats: true)
        }
    }

    //MARK:- IBAction
    @IBAction func resendAction(_ sender: UIButton) {
        
        viewModel.resend()
    }

    @IBAction func doneAction(_ sender: MRAnimatingButton) {

        viewModel.verify()
    }

    //MARK:- Private
    private func initialSetup(){

        navigationItem.title = StringConstants.enter_otp.localized

        infoContainerView.addShadow(3.0, opacity : 0.25)

        infoLabel.text = StringConstants.phone_info.localized
        infoLabel.textColor = Colors.black
        infoLabel.font = CustomFonts.avenirMedium.withSize(12.0)

        doneButton.setTitle(StringConstants.done.localized, for: .normal)

        resendButton.setTitle(StringConstants.resend.localized, for: .normal)
        resendButton.setTitleColor(Colors.bgColor.withAlphaComponent(0.25), for: .disabled)
        resendButton.setTitleColor(Colors.bgColor, for: .normal)
        resendButton.titleLabel?.font = CustomFonts.avenirMedium.withSize(12.0)
        resendButton.isEnabled = false

        timerLabel.text = counter.timerString
        timerLabel.textColor = Colors.black
        timerLabel.font = CustomFonts.avenirMedium.withSize(12.0)

        viewModel.delegate = self

        configure(textField: firstTextField)
        configure(textField: secondTextField)
        configure(textField: thirdTextField)
        configure(textField: fourthTextField)
    }

    @objc func updateLabel(){

        if counter == 0.0{
            timer?.invalidate()
            timer = nil
            counter = 600.0
            resendButton.isEnabled = true
            return
        }

        counter -= 1.0
        timerLabel.text = counter.timerString
    }

    private func configure(textField : CustomBackTextField){

        textField.isSecureTextEntry = true
        textField.backgroundColor = Colors.textFieldBackgroundColor
        textField.layer.borderWidth = 1.0
        textField.layer.borderColor = Colors.textFieldBorderColor.cgColor
        textField.layer.cornerRadius = 10.0
        textField.textAlignment = .center
        textField.clipsToBounds = true
        textField.textColor = Colors.bgColor
        textField.font = CustomFonts.avenirHeavy.withSize(23.0)
        textField.delegate = self
        textField.myDelegate = self
        textField.keyboardType = .numberPad
    }
}

extension OTPViewController : OTPViewModelDelegate{

    func verificationSuccess(message : String) {

        showAlert(StringConstants.success.localized, withMessage: message) { [weak self] in
            self?.dismiss(animated: true, completion: nil)
        }
    }

    func verificationStarted() {

        doneButton.startAnimating()
    }

    func verificationCompleted() {

        doneButton.stopAnimating()
    }

    func resendSuccess() {

        showAlert(StringConstants.success.localized, withMessage: StringConstants.new_sent.localized) { [weak self] in
            guard let strongSelf = self else {return}

            strongSelf.resendButton.isEnabled = false

            if strongSelf.timer != nil{
                strongSelf.timer?.invalidate()
                strongSelf.timer = nil
            }

            strongSelf.timer = Timer.scheduledTimer(timeInterval: 1.0, target: strongSelf, selector: #selector(strongSelf.updateLabel), userInfo: nil, repeats: true)
        }
    }
}

extension OTPViewController : UITextFieldDelegate, CustomBackTextFieldDelegate{

    func textFieldDidDelete(_ textField : CustomBackTextField) {

        textField.text = ""

        if textField == firstTextField{
            viewModel.otpArray[0] = ""
        }else if textField == secondTextField{
            viewModel.otpArray[1] = ""
            firstTextField.becomeFirstResponder()
        }else if textField == thirdTextField{
            viewModel.otpArray[2] = ""
            secondTextField.becomeFirstResponder()
        }else if textField == fourthTextField{
            viewModel.otpArray[3] = ""
            thirdTextField.becomeFirstResponder()
        }
    }

    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {

        if textField == firstTextField{
            if range.length == 0{
                textField.text = string
                viewModel.otpArray[0] = string
                secondTextField.becomeFirstResponder()
            } else {
                textField.text = ""
                viewModel.otpArray[0] = ""
            }
        } else if textField == secondTextField{
            if range.length == 0{
                textField.text = string
                viewModel.otpArray[1] = string
                thirdTextField.becomeFirstResponder()
            } else {
                textField.text = ""
                viewModel.otpArray[1] = ""
                firstTextField.becomeFirstResponder()
            }
        } else if textField == thirdTextField{
            if range.length == 0{
                textField.text = string
                viewModel.otpArray[2] = string
                fourthTextField.becomeFirstResponder()
            } else {
                textField.text = ""
                viewModel.otpArray[2] = ""
                secondTextField.becomeFirstResponder()
            }
        } else if textField == fourthTextField{
            if range.length == 0{
                textField.text = string
                viewModel.otpArray[3] = string
                view.endEditing(true)
            } else {
                textField.text = ""
                viewModel.otpArray[3] = ""
                thirdTextField.becomeFirstResponder()
            }
        }

        return false
    }
}
