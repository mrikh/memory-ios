//
//  OTPCodeStoryboardView.swift
//  Memory
//
//  Created by Mayank Rikh on 22/06/20.
//  Copyright © 2020 Mayank Rikh. All rights reserved.
//

import UIKit

class OTPCodeStoryboardView: UIView {

    private (set) var otpView : OTPCodeView?

    var startEditing : Bool = false{
        didSet{
            otpView?.startEditting = startEditing
        }
    }

    override func awakeFromNib() {

        super.awakeFromNib()
        otpView = OTPCodeView.nib.instantiate(withOwner: nil, options: nil)[0] as? OTPCodeView

        if let view = otpView{
            addOnFullScreen(view)
        }
    }
}
