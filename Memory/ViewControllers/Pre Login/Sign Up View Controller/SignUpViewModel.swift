//
//  SignUpViewModel.swift
//  Memory
//
//  Created by Mayank Rikh on 17/03/19.
//  Copyright © 2019 Mayank Rikh. All rights reserved.
//

import Foundation

protocol SignUpViewModelDelegate : BaseProtocol {

    func reloadTable()
    func success(message : String)
    func responseReceived()
}

class SignUpViewModel{

    weak var delegate : SignUpViewModelDelegate?
    private var dataSource = [TextFieldCellViewModel]()

    var numberOfRows : Int{
        return dataSource.count
    }

    init() {

        let dataSourceArray = [["placeholder" : StringConstants.name.localized, "value" : nil, "type" : 0], ["placeholder" : StringConstants.username.localized, "value" : nil, "type" : 1], ["placeholder" : StringConstants.email.localized, "value" : nil, "type" : 2], ["placeholder" : StringConstants.password.localized, "value" : nil, "type" : 3]]
        dataSourceArray.forEach { (dict) in
            dataSource.append(TextFieldCellViewModel(placeholder: dict["placeholder"] as? String, inputValue: dict["value"] as? String, type: dict["type"] as? Int))
        }
    }

    func viewModel(at index : Int) -> TextFieldCellViewModel{
        return dataSource[index]
    }

    func selectPosition(after viewModel : TextFieldCellViewModel) -> Int?{

        if let index = dataSource.firstIndex(where: {$0.type == viewModel.type}){
            return index + 1 == dataSource.count ? nil : index + 1
        }else{
            return nil
        }
    }

    func validate(_ viewModel : TextFieldCellViewModel?){

        guard let model = viewModel, let type = model.type else {return}

        switch type {
        case .name:
            viewModel?.errorString.value = ValidationController.validateName(model.inputValue ?? "")
        case .email:
            viewModel?.errorString.value = ValidationController.validateEmail(model.inputValue ?? "")
        case .password:
            viewModel?.errorString.value = ValidationController.validatePassword(model.inputValue ?? "")
        case .username:
            break
        }
    }

    func startSubmit(){

        var errorOccurred = false
        var name : String?
        var username : String?
        var password : String?
        var email : String?

        dataSource.forEach { (viewModel) in

            if let type = viewModel.type{
                switch type{
                case .email:
                    email = viewModel.inputValue
                    if let error = viewModel.errorString.value, !error.isEmpty{
                        errorOccurred = true
                    }
                case .name:
                    name = viewModel.inputValue
                    if let error = viewModel.errorString.value, !error.isEmpty{
                        errorOccurred = true
                    }
                case .password:
                    password = viewModel.inputValue
                    if let error = viewModel.errorString.value, !error.isEmpty{
                        errorOccurred = true
                    }
                case .username:
                    username = viewModel.inputValue
                    if viewModel.availability.value != .available{
                        errorOccurred = true
                    }
                }
            }
        }

        if errorOccurred{
            delegate?.reloadTable()
            delegate?.errorOccurred(errorString: StringConstants.one_or_more_fields.localized)
            return
        }

        let params = ["name" : name, "username" : username, "password" : password, "email" : email].compactMapValues({$0?.trimmingCharacters(in: .whitespacesAndNewlines)})

        APIManager.signUpUser(params: params) { [weak self] (dict, error) in
            self?.delegate?.responseReceived()
            if let tempDict = dict?["data"]{

                APIManager.authenticationToken = tempDict["token"].stringValue
                self?.delegate?.success(message : dict?["message"].stringValue ?? StringConstants.success.localized)
            }else{
                self?.delegate?.errorOccurred(errorString: error?.localizedDescription)
            }
        }
    }
}
