//
//  LocationViewController.swift
//  Memory
//
//  Created by Mayank Rikh on 15/07/19.
//  Copyright © 2019 Mayank Rikh. All rights reserved.
//

import MapKit
import UIKit

protocol LocationViewControllerDelegate : AnyObject{

    func userDidPickLocation(coordinate : CLLocationCoordinate2D, addressTitle : String, subtitle : String)
}

class LocationViewController: BaseViewController, KeyboardHandler {

    @IBOutlet weak var bottomConstraint: NSLayoutConstraint!
    @IBOutlet weak var searchTableView: UITableView!
    @IBOutlet weak var mapView: MKMapView!

    private var userDragged = false
    private var workItem : DispatchWorkItem?
    private var geocodeWorkItem : DispatchWorkItem?

    var coordinate : CLLocationCoordinate2D?
    var addressTitle : String?
    var subTitle : String?

    weak var delegate : LocationViewControllerDelegate?

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
        navigationController?.setNavigationBarHidden(false, animated: true)
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

        navigationItem.largeTitleDisplayMode = .never

        isLoading = false
        emptyDataSourceDelegate(tableView: searchTableView, message: StringConstants.no_search_result.localized)
        LocationManager.shared.delegate = self

        if let coordinate = self.coordinate{
            focus(coordinate: coordinate, title: nil, subTitle: nil)
            reverseGeoCode(coordinate: coordinate)
        }else{
            let locationStatus = LocationManager.shared.locationEnabled
            if locationStatus.granted{
                if let current = LocationManager.shared.currentLocation{
                    focus(coordinate: current.coordinate, title: nil, subTitle: nil)
                    reverseGeoCode(coordinate: current.coordinate)
                }
            }
        }

        searchTableView.tableFooterView = UIView()
        navigationItem.titleView = searchBar
        searchBar.delegate = self

        searchCompleter.delegate = self
        searchTableView.isHidden = true

        searchBar.searchBarStyle = .minimal

        mapView.delegate = self

        let pan = UIPanGestureRecognizer(target: self, action: #selector(handlePan(_:)))
        pan.delegate = self
        mapView.addGestureRecognizer(pan)

        let doneButton = UIBarButtonItem(barButtonSystemItem: .done, target: self, action: #selector(handleDone))
        navigationItem.rightBarButtonItem = doneButton
    }

    @objc func handleDone(){

        guard let cord = coordinate, let name = addressTitle, let desc = subTitle else {
            showAlert(StringConstants.alert.localized, withMessage: StringConstants.something_wrong.localized, withCompletion: nil)
            return
        }

        delegate?.userDidPickLocation(coordinate: cord, addressTitle: name, subtitle: desc)
        navigationController?.popViewController(animated: true)
    }

    private func geocode(coordinate : CLLocationCoordinate2D){

        geocodeWorkItem?.cancel()
        let item = DispatchWorkItem{ [weak self] in
            self?.reverseGeoCode(coordinate : coordinate)
        }

        geocodeWorkItem = item
        DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + 2.0, execute: item)
    }

    private func reverseGeoCode(coordinate : CLLocationCoordinate2D){

        let geocoder = CLGeocoder()
        searchBar.isLoading = true

        geocoder.reverseGeocodeLocation(CLLocation(latitude: coordinate.latitude, longitude: coordinate.longitude)) { [weak self] (placemarks, error) in

            if let temp = placemarks?.first{
                self?.addressTitle = temp.name
                self?.searchBar.text = temp.name

                let array = [temp.subLocality, temp.locality, temp.subAdministrativeArea, temp.administrativeArea]
                self?.subTitle = array.compactMap({$0}).joined(separator: ", ")
                self?.coordinate = coordinate
            }else{
                self?.showAlert(StringConstants.alert.localized, withMessage: error?.localizedDescription ?? StringConstants.something_wrong.localized, withCompletion: nil)
            }

            self?.searchBar.isLoading = false
        }
    }

    private func focus(coordinate : CLLocationCoordinate2D, title : String?, subTitle : String?){

        workItem?.cancel()
        let item = DispatchWorkItem{ [weak self] in
            self?.show(coordinate : coordinate, title : title, subTitle : subTitle)
        }

        workItem = item
        DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + 0.5, execute: item)
    }

    private func show(coordinate : CLLocationCoordinate2D, title : String?, subTitle : String?){
        let radius = 500.0
        let coordinateRegion = MKCoordinateRegion(center: coordinate, latitudinalMeters: radius, longitudinalMeters: radius)
        mapView.setRegion(coordinateRegion, animated: true)
        dropPin(coordinate: coordinate, title: title, subTitle: subTitle)
    }

    private func dropPin(coordinate : CLLocationCoordinate2D, title : String?, subTitle : String?){

        mapView.removeAnnotations(mapView.annotations)
        let annotation = Annotation(title: title, subTitle: subTitle, coordinate: coordinate)
        mapView.addAnnotation(annotation)
    }
}

extension LocationViewController : UIGestureRecognizerDelegate{

    func gestureRecognizer(_ gestureRecognizer: UIGestureRecognizer, shouldRecognizeSimultaneouslyWith otherGestureRecognizer: UIGestureRecognizer) -> Bool {
        return true
    }

    @objc func handlePan(_ gesture : UIPanGestureRecognizer){

        if gesture.state == .ended{
            userDragged = true
        }
    }
}

extension LocationViewController : LocationManagerDelegate{

    func statusChangedToAllowed() {}

    func didFetchLocation() {

        guard let current = LocationManager.shared.currentLocation else {return}
        focus(coordinate: current.coordinate, title: nil, subTitle: nil)
        reverseGeoCode(coordinate: current.coordinate)
    }

    func locationFetchError() {}
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
                self?.focus(coordinate: coordinate, title: searchResult.title, subTitle: searchResult.subtitle)

                self?.searchBar.text = response?.mapItems.first?.name
                self?.indicator?.stopAnimating()
                self?.searchTableView.isHidden = true
                self?.searchBar.resignFirstResponder()

                self?.coordinate = coordinate
                self?.addressTitle = searchResult.title
                self?.subTitle = searchResult.subtitle
            }
        }
    }
}

extension LocationViewController : MKMapViewDelegate{

    func mapView(_ mapView: MKMapView, regionDidChangeAnimated animated: Bool) {

        let center = mapView.centerCoordinate
        dropPin(coordinate: center, title: nil, subTitle: nil)

        if userDragged{
            reverseGeoCode(coordinate: center)
            userDragged = false
        }
    }
}
