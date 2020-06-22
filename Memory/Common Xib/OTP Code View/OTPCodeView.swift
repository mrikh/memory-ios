//
//  OTPCodeView.swift
//  Memory
//
//  Created by Mayank Rikh on 21/06/20.
//  Copyright © 2020 Mayank Rikh. All rights reserved.
//

import UIKit

class OTPCodeView: UIView{

    private (set) var otpArray = ["", "", "", ""]

    @IBOutlet var textFields: [CustomBackTextField]!
    @IBOutlet var underlines: [UIView]!

    //done as otherise the underline wasn't showing up properly. Only needed really to automatically make the textfield first responder once UI has been laid out.
    var startEditting : Bool = false{
        didSet{
            textFields[0].becomeFirstResponder()
        }
    }

    override func awakeFromNib() {

        super.awakeFromNib()

        textFields.forEach { (field) in
            field.delegate = self
            field.myDelegate = self
            field.font = CustomFonts.avenirHeavy.withSize(24.0)
            field.textColor = Colors.bgColor
            field.textAlignment = .center
            field.returnKeyType = .next
        }

        underlines.forEach { (view) in
            view.backgroundColor = Colors.bgColor.withAlphaComponent(0.40)
        }

        underlines[0].backgroundColor = Colors.bgColor
        textFields[3].returnKeyType = .done
    }
}

extension OTPCodeView : UITextFieldDelegate, CustomBackTextFieldDelegate{

    func textFieldDidDelete(_ textField: CustomBackTextField) {

        textField.text = ""
        if let index = textFields.firstIndex(where: {$0 == textField}){
            otpArray[index] = ""

            if index > 0{
                textFields[index - 1].becomeFirstResponder()
            }
        }
    }

    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {

        if let index = textFields.firstIndex(where: {$0 == textField}){
            if range.length == 0{
                otpArray[index] = string
                textField.text = string
                if index < 3{
                    textFields[index + 1].becomeFirstResponder()
                }else{
                    textField.resignFirstResponder()
                }
            }else{
                textField.text = ""
                otpArray[index] = ""
                if index > 0{
                    textFields[index - 1].becomeFirstResponder()
                }
            }
        }

        return false
    }
}
