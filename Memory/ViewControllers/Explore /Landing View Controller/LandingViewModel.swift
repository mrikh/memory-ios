//
//  LandingController.swift
//  Memory
//
//  Created by Mayank Rikh on 07/08/19.
//  Copyright © 2019 Mayank Rikh. All rights reserved.
//

import CoreLocation
import Foundation

protocol LandingViewModelDelegate : BaseProtocol{

    func locationFetch(fetching : Bool)
    func locationGranted()

    func enableLocationServices()
    func reloadTable()
}

class LandingViewModel{

    weak var delegate : LandingViewModelDelegate?

    private var dataSource = [EventModel]()
    private var coordinate : CLLocationCoordinate2D?
    //no more data present unless coordinates changed
    private var noMore = false
    //if currently api being hit, dont hit again (in case of fast scrolling)
    private var isFetching = false
    
    var addressTitle : Binder<String?> = Binder(nil)
    var addressSubtitle : Binder<String?> = Binder(nil)

    var rowCount : Int{
        return dataSource.count
    }

    func model(at row : Int) -> EventModel{
        return dataSource[row]
    }

    func startLocationFetch(){

        let locationStatus = LocationManager.shared.locationEnabled
        LocationManager.shared.delegate = self

        if locationStatus.notAsked{
            
        }else if locationStatus.granted{
            //check if coordinate already present
            if let current = LocationManager.shared.currentLocation{
                coordinate = current.coordinate
                reverseGeoCode(coordinate: current.coordinate)
            }
        }else{
            delegate?.enableLocationServices()
        }
    }

    func updateLocation(coordinate: CLLocationCoordinate2D, addressTitle: String, subtitle: String){

        self.coordinate = coordinate
        self.addressSubtitle.value = subtitle
        self.addressTitle.value = addressTitle

        fetchEvents(skip : 0, showLoader: true)
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

        APIManager.getEvents(lat: coordinate.latitude, long: coordinate.longitude, status: 0, skip: skip) { [weak self] (json, error) in

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

            self?.delegate?.reloadTable()
            self?.isFetching = false
        }
    }

    //MARK:- Private
    private func reverseGeoCode(coordinate : CLLocationCoordinate2D){

        let geocoder = CLGeocoder()

        delegate?.locationFetch(fetching: true)
        geocoder.reverseGeocodeLocation(CLLocation(latitude: coordinate.latitude, longitude: coordinate.longitude)) { [weak self] (placemarks, error) in

            self?.delegate?.locationFetch(fetching: false)

            if let temp = placemarks?.first{
                let array = [temp.subLocality, temp.locality, temp.subAdministrativeArea, temp.administrativeArea]
                self?.addressSubtitle.value = array.compactMap({$0}).joined(separator: ", ")
                self?.addressTitle.value = temp.name
                self?.fetchEvents(skip : 0, showLoader: true)
            }else{
                self?.addressSubtitle.value = nil
                self?.addressTitle.value = nil
            }
        }
    }
}

extension LandingViewModel : LocationManagerDelegate{

    func didFetchLocation() {

        coordinate = LocationManager.shared.currentLocation?.coordinate
        if let tempCoordinate = coordinate{
            reverseGeoCode(coordinate: tempCoordinate)
        }
    }

    func locationFetchError() {
        
        addressTitle.value = nil
        addressSubtitle.value = nil
    }

    func statusChangedToAllowed() {

        delegate?.locationGranted()
    }
}
