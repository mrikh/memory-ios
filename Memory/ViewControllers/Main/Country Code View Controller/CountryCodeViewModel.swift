//
//  CountryCodeViewModel.swift
//  Memory
//
//  Created by Mayank Rikh on 09/07/19.
//  Copyright © 2019 Mayank Rikh. All rights reserved.
//

import Foundation

protocol CountryCodeViewModelDelegate : AnyObject{

    func didFilteredData()
    func didSelectCountryWith(iSOCode : String)
}

class CountryCodeViewModel{

    weak var delegate : CountryCodeViewModelDelegate?

    lazy var countryArray = [CountryCodeModel]()
    lazy var filteredCountryArray = [CountryCodeModel]()
    var selectedCountryModel : CountryCodeModel?

    init() {
        setupCountryDict()
    }

    //Function that filter the all country data by the provided search string
    func filterCountry(for searchString : String) {
        if searchString.isEmpty {
            filteredCountryArray = countryArray
        } else {
            filteredCountryArray = countryArray.filter({ (model) -> Bool in
                return model.countryEnglishName.localizedLowercase.starts(with: searchString.localizedLowercase) || "\(model.countryCode)".localizedCaseInsensitiveContains(searchString)
            })
        }

        delegate?.didFilteredData()
    }

    func isSelectedCountry(index : Int) -> Bool {
        if index < filteredCountryArray.count {
            return filteredCountryArray[index].countryID == selectedCountryModel?.countryID
        }
        return false
    }

    func countryNameAndCode(for index : Int) -> String? {
        if index < filteredCountryArray.count {
            let model = filteredCountryArray[index]
            return model.countryEnglishName + " (+\(model.countryCode))"
        }
        return nil
    }

    func setPreviousSelectedCountry(with iSOCode : String?) {
        if let value = iSOCode, let position = countryArray.firstIndex(where: {$0.iSOCode == value}) {
            selectedCountryModel = countryArray[position]
        }
    }

    func selectCountry(at index : Int) {
        if index < filteredCountryArray.count {
            let model = filteredCountryArray[index]
            selectedCountryModel = model
            delegate?.didSelectCountryWith(iSOCode: model.iSOCode)
        }
    }

    //MARK:- Private
    private func setupCountryDict(){

        guard let filePath = Bundle.main.path(forResource: "CountryData", ofType: "json") else {return}
        guard let data = try? Data(contentsOf: URL(fileURLWithPath: filePath)) else {return}
        guard let array = try? JSONSerialization.jsonObject(with: data, options: .mutableLeaves) as? [[String : Any]] else {return}

        countryArray = array.map({CountryCodeModel($0)})
        filteredCountryArray = countryArray
    }
}
