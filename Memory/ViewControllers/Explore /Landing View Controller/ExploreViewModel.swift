//
//  ExploreViewModel.swift
//  Memory
//
//  Created by Mayank Rikh on 24/06/20.
//  Copyright © 2020 Mayank Rikh. All rights reserved.
//

import CoreLocation
import Foundation

protocol ExploreViewModelDelegate : BaseProtocol{

    func locationPermissionNotAsked()
    func reloadData()

    func isFetchingLocation()
    func doneFetchingLocation(name : String)
    func locationUpdated(coordinate : CLLocationCoordinate2D)
    func deniedLocation()
}

class ExploreViewModel{

    weak var delegate : ExploreViewModelDelegate?

    private var dataSource = [EventModel](){
        didSet{
            delegate?.reloadData()
        }
    }

    private var coordinate : CLLocationCoordinate2D?{
        didSet{
            if let tempCoordinate = coordinate{
                delegate?.locationUpdated(coordinate : tempCoordinate)
                reverseGeoCode(coordinate: tempCoordinate)
            }
        }
    }

    //no more data present unless coordinates changed
    private var noMore = false
    //if currently api being hit, dont hit again (in case of fast scrolling)
    private var isFetching = false

    var rowCount : Int{
        return dataSource.count
    }

    func model(at row : Int) -> EventModel{
        return dataSource[row]
    }

    func startLocationFetch(){

        LocationManager.shared.delegate = self
        checkStatus()
    }

    func fetchEvents(skip : Int, showLoader : Bool){

        guard let coordinate = self.coordinate else {
            delegate?.errorOccurred(errorString: StringConstants.unable_fetch.localized)
            return
        }

        if skip == 0 { noMore = false }
        if noMore || isFetching { return }

        isFetching = true

        if showLoader{
            delegate?.startLoader()
        }

        APIManager.getEvents(lat: coordinate.latitude, long: coordinate.longitude, status: 1, skip: skip) { [weak self] (json, error) in

            self?.delegate?.stopLoader()

            if let array = json?["data"].arrayValue{

                if skip == 0{
                    self?.dataSource = array.map({EventModel(json : $0)})
                }else{
                    self?.dataSource.append(contentsOf: array.map({EventModel(json : $0)}))
                }

                if array.isEmpty{
                    self?.noMore = true
                }

            }else{
                self?.delegate?.errorOccurred(errorString: error?.localizedDescription ?? StringConstants.something_wrong.localized)
            }

            self?.delegate?.reloadData()
            self?.isFetching = false
        }
    }

    //MARK:- Private
    private func reverseGeoCode(coordinate : CLLocationCoordinate2D){

        let geocoder = CLGeocoder()

        delegate?.isFetchingLocation()
        geocoder.reverseGeocodeLocation(CLLocation(latitude: coordinate.latitude, longitude: coordinate.longitude)) { [weak self] (placemarks, error) in

            self?.delegate?.doneFetchingLocation(name : placemarks?.first?.name ?? StringConstants.no_idea.localized)
            self?.fetchEvents(skip : 0, showLoader: true)
        }
    }

    private func checkStatus(){
        let locationStatus = LocationManager.shared.locationEnabled
        if locationStatus.notAsked{
            delegate?.locationPermissionNotAsked()
        }else if locationStatus.granted{
            if let current = LocationManager.shared.currentLocation{
                coordinate = current.coordinate
            }else if LocationManager.shared.locationManager == nil{
                LocationManager.shared.setupLocationManager()
            }
        }else{
            delegate?.deniedLocation()
        }
    }
}

extension ExploreViewModel : LocationManagerDelegate{

    func didUpdatePermissionStatus() {

        //something was selected, check what is the status and perform actions
        checkStatus()
    }

    func didFetchLocation() {

        coordinate = LocationManager.shared.currentLocation?.coordinate
    }

    func locationFetchError() {

        delegate?.deniedLocation()
    }

    func statusChangedToAllowed() {

        checkStatus()
    }
}
