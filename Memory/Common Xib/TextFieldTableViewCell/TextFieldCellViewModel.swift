//
//  TextFieldCellViewModel.swift
//  Memory
//
//  Created by Mayank Rikh on 17/03/19.
//  Copyright © 2019 Mayank Rikh. All rights reserved.
//

import Foundation

class TextFieldCellViewModel{

    enum ViewModelType : Int{
        case name
        case username
        case email
        case password

        var keyboardType : UIKeyboardType{
            switch self {
            case .email:
                return UIKeyboardType.emailAddress
            default:
                return UIKeyboardType.default
            }
        }

        var returnButton : UIReturnKeyType{
            switch self {
            case .password:
                return UIReturnKeyType.done
            default:
                return UIReturnKeyType.next
            }
        }

        var contentType : UITextContentType{
            switch self {
            case .name:
                return UITextContentType.name
            case .username:
                return UITextContentType.username
            case .email:
                return UITextContentType.emailAddress
            case .password:
                return UITextContentType.password
            }
        }
    }

    enum Availability{
        case none
        case available
        case notAvailable
        case apiError
        case checking
    }

    var type : ViewModelType?
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

    convenience init(placeholder : String?, inputValue : String?, type : Int?) {

        self.init()
        self.placeholder.value = placeholder
        self.inputValue = inputValue
        self.type = ViewModelType(rawValue: type ?? 0)
    }
}
