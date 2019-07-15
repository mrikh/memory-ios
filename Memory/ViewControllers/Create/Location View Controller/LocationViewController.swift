//
//  LocationViewController.swift
//  Memory
//
//  Created by Mayank Rikh on 15/07/19.
//  Copyright © 2019 Mayank Rikh. All rights reserved.
//

import MapKit
import UIKit

class LocationViewController: BaseViewController, KeyboardHandler {

    @IBOutlet weak var bottomConstraint: NSLayoutConstraint!
    @IBOutlet weak var searchTableView: UITableView!
    @IBOutlet weak var mapView: MKMapView!

    private lazy var searchBar : UISearchBar = {
        let temp = UISearchBar()
        temp.delegate = self
        temp.showsCancelButton = true

        return temp
    }()

    var bottomConstraints: [NSLayoutConstraint]{
        return [bottomConstraint]
    }

    private lazy var request : MKLocalSearch.Request = MKLocalSearch.Request()
    private let searchCompleter = MKLocalSearchCompleter()
    private var searchResults = [MKLocalSearchCompletion]()

    override func viewDidLoad() {
        super.viewDidLoad()

        initialSetup()
    }

    override func viewWillAppear(_ animated: Bool) {

        super.viewWillAppear(animated)
        addKeyboardObservers()
        navigationController?.navigationBar.shadowImage = nil
    }

    override func viewDidLayoutSubviews() {

        super.viewDidLayoutSubviews()
        extraPadding = view.safeAreaInsets.bottom
    }

    override func viewWillDisappear(_ animated: Bool) {

        removeKeyboardObservers()
        super.viewWillDisappear(animated)
    }

    //MARK:- Private
    private func initialSetup(){

        LocationManager.shared.delegate = self

        if LocationManager.shared.locationEnabled{
            if let current = LocationManager.shared.currentLocation{
                focus(coordinate: current.coordinate)
            }
        }

        navigationItem.titleView = searchBar
        searchBar.delegate = self

        searchCompleter.delegate = self
        searchTableView.isHidden = true

        searchBar.searchBarStyle = .minimal
    }

    private func focus(coordinate : CLLocationCoordinate2D){

        let radius = 500.0
        let coordinateRegion = MKCoordinateRegion(center: coordinate, latitudinalMeters: radius, longitudinalMeters: radius)
        mapView.setRegion(coordinateRegion, animated: false) 
    }
}

extension LocationViewController : LocationManagerDelegate{

    func didFetchLocation() {

        guard let current = LocationManager.shared.currentLocation else {return}
        focus(coordinate: current.coordinate)
    }
}

extension LocationViewController : UISearchBarDelegate {

    func searchBarShouldBeginEditing(_ searchBar: UISearchBar) -> Bool {
        searchTableView.isHidden = false
        return true
    }

    func searchBarShouldEndEditing(_ searchBar: UISearchBar) -> Bool {
        searchTableView.isHidden = true
        return true
    }

    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        searchBar.isLoading = true
        searchCompleter.queryFragment = searchText
    }

    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {

        searchBar.resignFirstResponder()
        searchTableView.isHidden = true
    }
}


extension LocationViewController : MKLocalSearchCompleterDelegate{

    func completerDidUpdateResults(_ completer: MKLocalSearchCompleter) {

        searchBar.isLoading = false
        searchResults = completer.results
        searchTableView.reloadData()
    }

    func completer(_ completer: MKLocalSearchCompleter, didFailWithError error: Error) {

        searchBar.isLoading = false
        searchResults.removeAll()
        searchTableView.reloadData()
    }
}

extension LocationViewController : UITableViewDelegate, UITableViewDataSource{

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {

        return searchResults.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let searchResult = searchResults[indexPath.row]
        let cell = UITableViewCell(style: .subtitle, reuseIdentifier: nil)
        cell.textLabel?.text = searchResult.title
        cell.detailTextLabel?.text = searchResult.subtitle
        return cell
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {

        let searchResult = searchResults[indexPath.row]

        request = MKLocalSearch.Request(completion: searchResult)
        indicator?.startAnimating()
        let search = MKLocalSearch(request: request)
        search.start { [weak self] (response, error) in

            if let coordinate = response?.mapItems.first?.placemark.coordinate{
                self?.focus(coordinate: coordinate)
            }

            self?.searchBar.text = response?.mapItems.first?.name
            self?.indicator?.stopAnimating()
            self?.searchTableView.isHidden = true
            self?.searchBar.resignFirstResponder()
        }
    }
}
