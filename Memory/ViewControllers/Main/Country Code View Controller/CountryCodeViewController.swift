//
//  CountryCodeViewController.swift
//  Memory
//
//  Created by Mayank Rikh on 09/07/19.
//  Copyright © 2019 Mayank Rikh. All rights reserved.
//

import FlagKit
import UIKit

protocol CountryCodeViewControllerDelegate : class {

    func didSelectCountry(with iSOCode : String)
}

class CountryCodeViewController: BaseViewController, KeyboardHandler, TableViewHeaderFooterResizeProtocol {

    @IBOutlet weak var countryCodeTableView: UITableView!
    @IBOutlet weak var tableViewBottom: NSLayoutConstraint!

    let searchController = UISearchController(searchResultsController: nil)
    var countryCodeViewModel = CountryCodeViewModel()
    weak var delegate : CountryCodeViewControllerDelegate?

    var bottomConstraints: [NSLayoutConstraint]{
        return [tableViewBottom]
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        initialSetup()
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.setNavigationBarHidden(false, animated: true)
        addKeyboardObservers()
    }

    override func viewDidLayoutSubviews() {

        super.viewDidLayoutSubviews()
        extraPadding = view.safeAreaInsets.bottom
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    override func viewWillDisappear(_ animated: Bool) {

        searchController.isActive = false
        removeKeyboardObservers()
        super.viewWillDisappear(animated)
    }

    //MARK:- Private
    private func initialSetup() {

        countryCodeTableView.tableFooterView = UIView(frame: .zero)
        emptyDataSourceDelegate(tableView: countryCodeTableView, message: StringConstants.no_search_result.localized)

        navigationItem.title = StringConstants.country_code.localized
        countryCodeTableView.estimatedRowHeight = 60
        countryCodeTableView.rowHeight = UITableView.automaticDimension

        searchController.dimsBackgroundDuringPresentation = false
        searchController.searchBar.placeholder = StringConstants.search_country.localized
        searchController.searchResultsUpdater = self
        searchController.hidesNavigationBarDuringPresentation = true
        searchController.searchBar.searchBarStyle = .minimal
        navigationItem.searchController = searchController

        countryCodeViewModel.delegate = self
    }
}


extension CountryCodeViewController : UITableViewDataSource, UITableViewDelegate {

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {

        return countryCodeViewModel.filteredCountryArray.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {

        guard let cell = tableView.dequeueReusableCell(withIdentifier: CountryCodeTableCell.identifier, for: indexPath) as? CountryCodeTableCell else { return UITableViewCell() }

        let model = countryCodeViewModel.filteredCountryArray[indexPath.row]
        let isSelected = countryCodeViewModel.isSelectedCountry(index: indexPath.row)
        cell.accessoryType = isSelected ? .checkmark : .none
        cell.countryNameLabel.text = countryCodeViewModel.countryNameAndCode(for: indexPath.row)

        let flag = Flag(countryCode: model.iSOCode)
        cell.flagImageView.image = flag?.originalImage

        if isSelected{
            tableView.selectRow(at: indexPath, animated: false, scrollPosition: .none)
        }else{
            tableView.deselectRow(at: indexPath, animated: false)
        }

        return cell
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let cell = tableView.cellForRow(at: indexPath)
        cell?.accessoryType = .checkmark

        countryCodeViewModel.selectCountry(at: indexPath.row)
    }
}

//MARK:- CountryCodeControllerDelegate
extension CountryCodeViewController : CountryCodeViewModelDelegate {

    func didFilteredData() {

        isLoading = false
        countryCodeTableView.reloadData()
    }

    func didSelectCountryWith(iSOCode: String) {

        delegate?.didSelectCountry(with: iSOCode)

        view.endEditing(true)
        
        if searchController.isActive{
            searchController.isActive = false
        }

        DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + 0.3) { [weak self] in
            self?.navigationController?.popViewController(animated: true)
        }
    }
}

extension CountryCodeViewController : UISearchResultsUpdating {

    func updateSearchResults(for searchController: UISearchController) {
        let text = searchController.searchBar.text ?? ""
        countryCodeViewModel.filterCountry(for: text)
    }
}
