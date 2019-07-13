//
//  CreateViewController.swift
//  Memory
//
//  Created by Mayank Rikh on 08/07/19.
//  Copyright © 2019 Mayank Rikh. All rights reserved.
//

import UIKit

class PhoneNumberViewController: BaseViewController {

    @IBOutlet weak var phoneNumberTextField: MRTextField!
    @IBOutlet weak var countryCodeTextField: UITextField!
    @IBOutlet weak var infoLabel: UILabel!
    @IBOutlet weak var doneButton: MRAnimatingButton!

    let viewModel = PhoneNumberViewModel()

    override func viewDidLoad() {
        super.viewDidLoad()

        initialSetup()
    }

    override func viewWillAppear(_ animated: Bool) {

        super.viewWillAppear(animated)
        navigationController?.view.backgroundColor = Colors.white
        navigationController?.setNavigationBarHidden(false, animated: true)
    }

    //MARK:- IBAction

    @IBAction func doneAction(_ sender: MRAnimatingButton) {

        viewModel.startNumberVerification(number: phoneNumberTextField.text)
    }

    //MARK:- Private
    private func initialSetup(){

        navigationItem.title = StringConstants.phone_title.localized
        navigationItem.largeTitleDisplayMode = .always

        infoLabel.text = StringConstants.phone_info.localized
        infoLabel.textColor = Colors.black
        infoLabel.font = CustomFonts.avenirMedium.withSize(16.0)

        doneButton.setTitle(StringConstants.done.localized, for: .normal)

        countryCodeTextField.font = CustomFonts.avenirMedium.withSize(16.0)
        countryCodeTextField.textColor = Colors.bgColor
        phoneNumberTextField.configure(with: StringConstants.phone_number.localized, text: nil, primaryColor: Colors.bgColor, unselectedBottomColor: Colors.bgColor.withAlphaComponent(0.25))

        countryCodeTextField.text = viewModel.fetcUserCountryCode()

        viewModel.delegate = self
    }
}

extension PhoneNumberViewController : UITextFieldDelegate{

    func textFieldShouldBeginEditing(_ textField: UITextField) -> Bool {

        if textField == countryCodeTextField{

            let viewController = CountryCodeViewController.instantiate(fromAppStoryboard: .Main)
            viewController.delegate = self
            navigationController?.pushViewController(viewController, animated: true)

            return false
        }

        return true
    }

    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {

        if string.containsEmoji {return false}

        if let temp = textField as? MRTextField{
            temp.errorString = nil
            temp.hideErrorMessage()
        }
        
        return true
    }
}

extension PhoneNumberViewController : CountryCodeViewControllerDelegate{

    func didSelectCountry(with iSOCode: String) {

        countryCodeTextField.text = viewModel.countryCodeNumber(for: iSOCode)
    }
}

extension PhoneNumberViewController : PhoneNumberViewModelDelegate{

    func willHitApi() {

        doneButton.startAnimating()
    }

    func gotResponse() {

        doneButton.stopAnimating()
    }

    func textFieldError(errorString: String) {

        phoneNumberTextField.errorString = errorString
        phoneNumberTextField.shakeIfNeeded()
        phoneNumberTextField.showErrorMessage()
    }

    func success(number : String) {

        let viewController = OTPViewController.instantiate(fromAppStoryboard: .Main)
        viewController.viewModel = OTPViewModel(number: number)
        navigationController?.pushViewController(viewController, animated: true)
    }
}
