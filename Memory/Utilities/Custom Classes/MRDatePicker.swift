//
//  MRDatePicker.swift
//  Mid West Pilot Cars
//
//  Created by Mayank Rikh on 27/05/19.
//  Copyright © 2019 Mayank Rikh. All rights reserved.
//

import UIKit

class MRDatePicker: UIDatePicker {

    var toolbar = UIToolbar()

    private var doneAction : ((Date)->())?
    private var cancelAction : (()->())?

    convenience init(mode : UIDatePicker.Mode, doneAction : ((Date)->())?, cancelAction : (()->())?){

        self.init()

        datePickerMode = mode
        minimumDate = Date()

        //ToolBar
        let cancelButton = UIBarButtonItem(title: StringConstants.cancel.localized, style: .plain, target: self, action: #selector(cancelDatePicker))
        let spaceButton = UIBarButtonItem(barButtonSystemItem: UIBarButtonItem.SystemItem.flexibleSpace, target: nil, action: nil)
        let doneButton = UIBarButtonItem(title: StringConstants.done.localized, style: .done, target: self, action: #selector(doneDatePicker))
        toolbar.sizeToFit()
        toolbar.setItems([cancelButton, spaceButton, doneButton], animated: false)

        self.doneAction = doneAction
        self.cancelAction = cancelAction
    }

    @objc private func doneDatePicker(){

        doneAction?(date)
    }

    @objc private func cancelDatePicker(){

        cancelAction?()
    }
}
