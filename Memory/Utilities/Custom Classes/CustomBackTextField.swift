//
//  CustomBackTextField.swift
//  Memory
//
//  Created by Mayank Rikh on 13/07/19.
//  Copyright © 2019 Mayank Rikh. All rights reserved.
//

import UIKit

protocol CustomBackTextFieldDelegate : class{
    
    func textFieldDidDelete(_ textField : CustomBackTextField)
}

class CustomBackTextField: UITextField {

    weak var myDelegate: CustomBackTextFieldDelegate?

    override func deleteBackward() {
        super.deleteBackward()
        myDelegate?.textFieldDidDelete(self)
    }

    override func canPerformAction(_ action: Selector, withSender sender: Any?) -> Bool {
        return false
    }
}
