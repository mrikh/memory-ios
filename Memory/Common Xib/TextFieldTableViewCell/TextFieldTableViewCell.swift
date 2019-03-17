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

    override func awakeFromNib() {

        super.awakeFromNib()
        mainTextField.configure(with: nil, text : nil, primaryColor: Colors.bgColor, unselectedBottomColor: Colors.bgColor.withAlphaComponent(0.25))
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

        viewModel.inputValueDidSet = { [weak self] (string) in
            self?.mainTextField.text = string
        }

        viewModel.placeholder.bind { [weak self] (string) in
            self?.mainTextField.placeholder = string
        }

        viewModel.errorString.bind { [weak self] (string) in
            self?.mainTextField.errorString = string
        }
    }
}
