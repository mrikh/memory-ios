//
//  LandingViewController.swift
//  Memory
//
//  Created by Mayank Rikh on 07/08/19.
//  Copyright © 2019 Mayank Rikh. All rights reserved.
//

import CoreLocation
import UIKit

class LandingViewController: BaseViewController, TableViewHeaderFooterResizeProtocol {

    @IBOutlet weak var fetchingIndicator: UIActivityIndicatorView!
    @IBOutlet weak var mainTableView: UITableView!
    @IBOutlet weak var addressLabel: UILabel!
    @IBOutlet weak var addressSubtitleLabel: UILabel!
    @IBOutlet weak var addressLabelView: UIView!
    @IBOutlet weak var updateButton: UIButton!
    @IBOutlet weak var addressSubtitleView: UIView!

    //this was done as assigning to table view isnt working
    private let viewModel = LandingViewModel()
    private var firstTime = true

    override func viewDidLoad() {
        super.viewDidLoad()

        initialSetup()
    }

    override func viewWillAppear(_ animated: Bool) {

        super.viewWillAppear(animated)
        navigationController?.setNavigationBarHidden(true, animated: true)

        if firstTime{
            firstTime = false
            viewModel.startLocationFetch()
        }
    }

    override func viewDidLayoutSubviews() {

        super.viewDidLayoutSubviews()

        if let view = mainTableView.tableHeaderView, let resized = resizeView(view){
            mainTableView.tableHeaderView = resized
        }
    }

    //MARK:- IBAction
    @IBAction func updateAction(_ sender: UIButton) {

        let viewController = LocationViewController.instantiate(fromAppStoryboard: .Common)
        viewController.delegate = self
        viewController.addressTitle = viewModel.addressTitle.value
        viewController.subTitle = viewModel.addressSubtitle.value

        if let coordinate = LocationManager.shared.currentLocation?.coordinate{
            viewController.coordinate = coordinate
        }

        navigationController?.pushViewController(viewController, animated: true)
    }

    //MARK:- Private
    private func initialSetup(){

        viewModel.delegate = self

        navigationItem.largeTitleDisplayMode = .never

        addressLabel.font = CustomFonts.avenirHeavy.withSize(15.0)
        addressLabel.textColor = Colors.bgColor
        addressSubtitleLabel.font = CustomFonts.avenirMedium.withSize(12.0)
        addressSubtitleLabel.textColor = Colors.bgColor

        emptyDataSourceDelegate(tableView: mainTableView, message: StringConstants.enable_location_services.localized, buttonText: StringConstants.enable_location.localized){ [weak self] in
            self?.showRedirectAlert(StringConstants.are_sure.localized, withMessage: StringConstants.redirect_location.localized)
        }
        
        addressLabelView.isHidden = true
        addressSubtitleView.isHidden = true

        viewModel.addressTitle.bind { [weak self] (text) in

            if let tempText = text{
                self?.addressLabel.text = tempText
                self?.addressLabelView.isHidden = false
                self?.emptyDataSetString = StringConstants.no_data_found.localized
            }else{
                //unable to fetch coordinates
                self?.addressLabel.text = nil
                self?.isLoading = false
                self?.addressLabelView.isHidden = true
                self?.emptyDataSetString = StringConstants.unable_fetch.localized
                self?.mainTableView.reloadData()
            }
        }

        viewModel.addressSubtitle.bind { [weak self] (text) in

            if let tempText = text{
                self?.addressSubtitleLabel.text = tempText
                self?.addressSubtitleView.isHidden = false
            }else{
                self?.addressSubtitleLabel.text = nil
                self?.addressSubtitleView.isHidden = true
            }
        }

        let refreshControl = MRRefreshControl { [weak self] in
            self?.viewModel.fetchEvents(skip: 0, showLoader: false)
        }

        mainTableView.refreshControl = refreshControl

        updateButton.setAttributedTitle(NSAttributedString(string : StringConstants.update_location.localized, attributes : [.foregroundColor : Colors.bgColor, .font : CustomFonts.avenirHeavy.withSize(12.0), .underlineStyle : NSUnderlineStyle.single.rawValue]), for: .normal)

        mainTableView.register(ExploreEventTableViewCell.nib, forCellReuseIdentifier: ExploreEventTableViewCell.identifier)
    }
}

extension LandingViewController : UITableViewDelegate, UITableViewDataSource{

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {

        return viewModel.rowCount
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {

        guard let cell = tableView.dequeueReusableCell(withIdentifier: ExploreEventTableViewCell.identifier) as? ExploreEventTableViewCell else { return UITableViewCell() }

        let vm = viewModel.model(at: indexPath.row)
        cell.configure(model: vm)
        cell.joinAction = { [weak self] in
//            self?.viewModel.updateAttending(id: <#T##String#>, attending: <#T##Bool#>)
        }

        return cell
    }

    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {

        if indexPath.row == viewModel.rowCount - 3{
            viewModel.fetchEvents(skip: viewModel.rowCount, showLoader: false)
        }
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {

        let model = viewModel.model(at: indexPath.row)

        let viewController = EventDetailViewController.instantiate(fromAppStoryboard: .Explore)
        viewController.viewModel = EventDetailViewModel(model: EventDetailModel(event: model), isDraft: false)
        viewController.delegate = self
        navigationController?.pushViewController(viewController, animated: true)
    }
}

extension LandingViewController : LandingViewModelDelegate{

    func locationFetch(fetching: Bool) {

        fetching ? fetchingIndicator.startAnimating() : fetchingIndicator.stopAnimating()
    }

    func locationGranted() {

        mainTableView.reloadData()
    }

    func endRefreshing() {
        mainTableView.refreshControl?.endRefreshing()
    }

    func reloadTable(){

        mainTableView.reloadData()
    }

    func enableLocationServices() {

        mainTableView.reloadData()
    }
}

extension LandingViewController : LocationViewControllerDelegate{

    func userDidPickLocation(coordinate: CLLocationCoordinate2D, addressTitle: String, subtitle: String) {

        //done to hide the empty view of location permission
        isLoading = true
        mainTableView.reloadData()

        viewModel.updateLocation(coordinate: coordinate, addressTitle: addressTitle, subtitle: subtitle)
    }
}

extension LandingViewController : EventDetailViewControllerDelegate{

    func updateJoinStatus(eventId: String, isAttending: Bool) {

        if let index = viewModel.updateAttending(id : eventId, attending : isAttending){
            mainTableView.reloadRows(at: [[0, index]], with: .automatic)
        }
    }
}
