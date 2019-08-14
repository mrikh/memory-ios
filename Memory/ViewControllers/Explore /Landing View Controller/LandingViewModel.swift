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
}

class LandingViewModel{

    weak var delegate : LandingViewModelDelegate?

    private var coordinate : CLLocationCoordinate2D?
    var addressTitle : Binder<String?> = Binder(nil)
    var addressSubtitle : Binder<String?> = Binder(nil)


    func startLocationFetch(){
        LocationManager.shared.delegate = self
    }

    func updateLocation(coordinate: CLLocationCoordinate2D, addressTitle: String, subtitle: String){

        self.coordinate = coordinate
        self.addressSubtitle.value = subtitle
        self.addressTitle.value = addressTitle
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
