//
//  TextFieldCellViewModel.swift
//  Memory
//
//  Created by Mayank Rikh on 17/03/19.
//  Copyright © 2019 Mayank Rikh. All rights reserved.
//

import Foundation

class TextFieldCellViewModel{

    enum Availability{
        case none
        case available
        case notAvailable
        case apiError
        case checking
    }

    var placeholder : Binder<String?> = Binder(nil)
    var errorString : Binder<String?> = Binder(nil)
    var availability : Binder<Availability> = Binder(.none)
    var inputValue : String?{
        didSet{
            //reset availability
            availability.value = .none
            inputValueDidSet?(inputValue)
        }
    }

    var inputValueDidSet : ((String?)->())?

    convenience init(placeholder : String?, inputValue : String?) {

        self.init()
        self.placeholder.value = placeholder
        self.inputValue = inputValue
    }
}
