//
//  MRToolbar.swift
//  MWPC
//
//  Created by Mayank Rikh on 19/06/19.
//  Copyright © 2019 Mayank Rikh. All rights reserved.
//

import UIKit

class MRToolbar: UIToolbar {

    private var doneAction : (()->())?
    private var cancelAction : (()->())?

    convenience init(doneTitle : String = StringConstants.done.localized, doneAction : (()->())?, cancelAction : (()->())?){

        self.init()

        //ToolBar
        let spaceButton = UIBarButtonItem(barButtonSystemItem: UIBarButtonItem.SystemItem.flexibleSpace, target: nil, action: nil)
        let doneButton = UIBarButtonItem(title: doneTitle, style: .done, target: self, action: #selector(done))
        sizeToFit()

        if let _ = cancelAction{
            let cancelButton = UIBarButtonItem(title: StringConstants.cancel.localized, style: .plain, target: self, action: #selector(cancel))
            setItems([cancelButton, spaceButton, doneButton], animated: false)
        }else{
            setItems([spaceButton, doneButton], animated: false)
        }

        self.doneAction = doneAction
        self.cancelAction = cancelAction
    }

    @objc private func done(){
        doneAction?()
    }

    @objc private func cancel(){
        cancelAction?()
    }
}
