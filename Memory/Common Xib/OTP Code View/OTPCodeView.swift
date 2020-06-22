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
            field.keyboardType = .numberPad
        }

        underlines.forEach { (view) in
            view.backgroundColor = Colors.bgColor.withAlphaComponent(0.40)
        }

        textFields[3].returnKeyType = .done
    }

    private func enableUnderline(index : Int){

        underlines.forEach { (view) in
            if index != -1, underlines[index] == view{
                view.backgroundColor = Colors.bgColor
            }else{
                view.backgroundColor = Colors.bgColor.withAlphaComponent(0.40)
            }
        }
    }
}

extension OTPCodeView : UITextFieldDelegate, CustomBackTextFieldDelegate{

    func textFieldDidBeginEditing(_ textField: UITextField) {

        if let index = textFields.firstIndex(where: {$0 == textField}){
            enableUnderline(index: index)
        }
    }

    func textFieldDidEndEditing(_ textField: UITextField) {

        if textFields.firstIndex(where: {$0.isFirstResponder}) == nil{

            enableUnderline(index: -1)
        }
    }

    func textFieldDidDelete(_ textField: CustomBackTextField) {

        textField.text = ""
        if let index = textFields.firstIndex(where: {$0 == textField}){
            otpArray[index] = ""

            if index > 0{
                textFields[index - 1].becomeFirstResponder()
                enableUnderline(index: index - 1)
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
                    enableUnderline(index: index + 1)
                }else{
                    textField.resignFirstResponder()
                    enableUnderline(index: -1)
                }
            }else{
                textField.text = ""
                otpArray[index] = ""
                if index > 0{
                    textFields[index - 1].becomeFirstResponder()
                    enableUnderline(index: index - 1)
                }
            }
        }

        return false
    }
}
