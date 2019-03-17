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
    }

    func configure(viewModel : TextFieldCellViewModel){

        self.viewModel = viewModel

        mainTextField.text = viewModel.inputValue
        mainTextField.placeholder = viewModel.placeholder.value
        mainTextField.returnKeyType = viewModel.type?.returnButton ?? .default
        mainTextField.keyboardType = viewModel.type?.keyboardType ?? .default
        mainTextField.textContentType = viewModel.type?.contentType ?? .none

        viewModel.placeholder.bind { [weak self] (string) in
            self?.mainTextField.placeholder = string
        }

        viewModel.errorString.bind { [weak self] (string) in
            self?.mainTextField.errorString = string
        }
    }
}

extension TextFieldTableViewCell : UITextFieldDelegate{

    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {

        if string.containsEmoji {return false}

        let currentText = textField.text ?? ""
        let replacedText = (currentText as NSString).replacingCharacters(in: range, with: string)

        viewModel?.inputValue = replacedText
        return true
    }

    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        didPressReturn?(viewModel)
        return true
    }
}
