//
//  TextFieldTableViewCell.swift
//  Memory
//
//  Created by Mayank Rikh on 17/03/19.
//  Copyright © 2019 Mayank Rikh. All rights reserved.
//

import UIKit

class TextFieldTableViewCell: UITableViewCell {

    @IBOutlet weak var mainTextField : MRTextField!

    private weak var viewModel : TextFieldCellViewModel?
    var didPressReturn : ((TextFieldCellViewModel?)->())?
    var didEndEditing : ((TextFieldCellViewModel?)->())?

    override func awakeFromNib() {

        super.awakeFromNib()
        mainTextField.configure(with: nil, text : nil, primaryColor: Colors.bgColor, unselectedBottomColor: Colors.bgColor.withAlphaComponent(0.25))
        mainTextField.delegate = self
    }

    override func prepareForReuse() {

        super.prepareForReuse()
        viewModel = nil
        mainTextField.text = nil
        mainTextField.placeholder = nil
        mainTextField.isSecureTextEntry = false
        mainTextField.rightView = nil
    }

    func configure(viewModel : TextFieldCellViewModel){

        self.viewModel = viewModel

        mainTextField.text = viewModel.inputValue
        mainTextField.placeholder = viewModel.placeholder.value
        mainTextField.returnKeyType = viewModel.type?.returnButton ?? .default
        mainTextField.keyboardType = viewModel.type?.keyboardType ?? .default
        mainTextField.textContentType = viewModel.type?.contentType ?? .none
        mainTextField.errorString = viewModel.errorString.value

        if let type = viewModel.type, type == .password{
            mainTextField.isSecureTextEntry = true
            mainTextField.setupButton(buttonIcon: #imageLiteral(resourceName: "show-password"), andSelectedImage: #imageLiteral(resourceName: "hide-password"))
            mainTextField.rightAction = { [weak self] in
                if let tempSelf = self{
                    tempSelf.mainTextField.isSecureTextEntry = !tempSelf.mainTextField.isSecureTextEntry
                }
            }
        }

        viewModel.placeholder.bind { [weak self] (string) in
            self?.mainTextField.placeholder = string
        }

        viewModel.errorString.bind { [weak self] (string) in
            self?.showErrorMessageIfNeeded(string, animate: true)
        }

        viewModel.availability.bind { [weak self] (availability) in

            switch availability{
            case .checking: self?.mainTextField.startVerificationAnimating()
            case .error: self?.mainTextField.stopVerificationAnimating(isSuccess: false, continueStatus: true)
            case .available: self?.mainTextField.stopVerificationAnimating(isSuccess: true, continueStatus: true)
            default: self?.mainTextField.stopVerificationAnimating(isSuccess: false, continueStatus: true)
            }
        }
    }

    private func showErrorMessageIfNeeded(_ errorString : String?, animate : Bool){

        if let tempString = errorString{
            mainTextField.errorString = tempString
            mainTextField.shakeIfNeeded()
            mainTextField.showErrorMessage(animate)
        }else{
            mainTextField.errorString = nil
            mainTextField.hideErrorMessage(animate)
        }
    }
}

extension TextFieldTableViewCell : UITextFieldDelegate{

    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {

        if string.containsEmoji {return false}

        let currentText = textField.text ?? ""
        let replacedText = (currentText as NSString).replacingCharacters(in: range, with: string)

        viewModel?.inputValue = replacedText
        viewModel?.errorString.value = nil

        return true
    }

    func textFieldDidEndEditing(_ textField: UITextField) {
        didEndEditing?(viewModel)
    }

    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        didPressReturn?(viewModel)
        return true
    }
}
