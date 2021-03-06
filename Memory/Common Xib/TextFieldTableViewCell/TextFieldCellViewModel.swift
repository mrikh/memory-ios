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
        case error
        case checking
    }

    private var item : DispatchWorkItem?

    var type : ViewModelType?
    var availability : Binder<Availability> = Binder(.none)
    var placeholder : Binder<String?> = Binder(nil)
    var errorString : Binder<String?> = Binder(nil)
    var inputValue : String?{
        didSet{
            inputValueDidSet?(inputValue)

            if type == .username{
                //reset availability
                availability.value = .none
                performRequest()
            }
        }
    }

    var inputValueDidSet : ((String?)->())?

    convenience init(placeholder : String?, inputValue : String?, type : Int?) {

        self.init()
        self.placeholder.value = placeholder
        self.inputValue = inputValue
        self.type = ViewModelType(rawValue: type ?? 0)
    }

    private func performRequest(){

        item?.cancel()
        let work = DispatchWorkItem(block: { [weak self] in
            self?.checkUserName()
        })
        item = work
        DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + 0.5, execute: work)
    }

    private func checkUserName(){

        guard let name = inputValue, !name.isEmpty else{
            availability.value = .none
            return
        }

        guard availability.value != .checking else {return}
        availability.value = .checking

        APIManager.checkUserName(name: name) { [weak self] (json, error) in
            if let _ = json{
                self?.availability.value = .available
            }else{
                self?.errorString.value = error?.localizedDescription ?? StringConstants.username_not_available.localized
                self?.availability.value = .error
            }
        }
    }
}
