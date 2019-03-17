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

        let dataSourceArray = [["placeholder" : StringConstants.name.localized, "value" : nil, "type" : 0], ["placeholder" : StringConstants.username.localized, "value" : nil, "type" : 1], ["placeholder" : StringConstants.email.localized, "value" : nil, "type" : 2], ["placeholder" : StringConstants.password.localized, "value" : nil, "type" : 3]]
        dataSourceArray.forEach { (dict) in
            dataSource.append(TextFieldCellViewModel(placeholder: dict["placeholder"] as? String, inputValue: dict["value"] as? String, type: dict["type"] as? Int))
        }
    }

    func viewModel(at index : Int) -> TextFieldCellViewModel{
        return dataSource[index]
    }

    func selectPosition(after viewModel : TextFieldCellViewModel) -> Int?{

        if let index = dataSource.index(where: {$0.type == viewModel.type}){
            return index + 1 == dataSource.count ? nil : index + 1
        }else{
            return nil
        }
    }
}
