//
//  SignUpViewModel.swift
//  Memory
//
//  Created by Mayank Rikh on 17/03/19.
//  Copyright © 2019 Mayank Rikh. All rights reserved.
//

import Foundation

class SignUpViewModel{

    private var dataSource = [TextFieldCellViewModel]()

    var numberOfRows : Int{
        return dataSource.count
    }

    init() {

        let dataSourceArray = [["placeholder" : StringConstants.name.localized, "value" : nil], ["placeholder" : StringConstants.email.localized, "value" : nil], ["placeholder" : StringConstants.username.localized, "value" : nil], ["placeholder" : StringConstants.password.localized, "value" : nil]]
        dataSourceArray.forEach { (dict) in
            dataSource.append(TextFieldCellViewModel(placeholder: dict["placeholder"] as? String, inputValue: dict["value"] as? String))
        }
    }

    func viewModel(at index : Int) -> TextFieldCellViewModel{
        return dataSource[index]
    }
}
