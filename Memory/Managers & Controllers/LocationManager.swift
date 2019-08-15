//
//  LocationManager.swift
//  Mid West Pilot Cars
//
//  Created by Mayank Rikh on 28/05/19.
//  Copyright © 2019 Mayank Rikh. All rights reserved.
//

import CoreLocation
import Foundation

protocol LocationManagerDelegate : AnyObject{

    func didFetchLocation()
    func locationFetchError()

    func statusChangedToAllowed()
}

class LocationManager : NSObject{

    static let shared = LocationManager()

    var locationManager : CLLocationManager?
    var currentLocation : CLLocation?
    var address : String?

    private var apiWorkItem : DispatchWorkItem?
    weak var delegate : LocationManagerDelegate?

    private override init(){

        super.init()
        setupLocationManager()
    }

    func setupLocationManager(){

        locationManager = CLLocationManager()
        locationManager?.delegate = self
        locationManager?.distanceFilter = 100.0
        locationManager?.desiredAccuracy = kCLLocationAccuracyNearestTenMeters
        locationManager?.requestWhenInUseAuthorization()
        locationManager?.startUpdatingLocation()
    }

    var locationEnabled : ( notAsked : Bool, denied : Bool, granted : Bool){

        if CLLocationManager.locationServicesEnabled() {
            switch(CLLocationManager.authorizationStatus()) {
            case .notDetermined:
                return (notAsked : true, denied : false, granted : false)
            case .denied, .restricted:
                return (notAsked : false, denied : true, granted : false)
            case .authorizedAlways, .authorizedWhenInUse:
                return (notAsked : false, denied : false, granted : true)
            @unknown default:
                return (notAsked : false, denied : true, granted : false)
            }
        } else {
            return (notAsked : false, denied : true, granted : false)
        }
    }
}

extension LocationManager : CLLocationManagerDelegate{

    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {

        guard let locationObject = locations.last else {return}

        //update to closest accuracy
        let threshold : CLLocationDistance = 10.0

        //dont update unless 2 meters distance difference atleast
        if let current = currentLocation, current.distance(from: locationObject) < threshold{ return }
        
        currentLocation = locationObject
        delegate?.didFetchLocation()
    }

    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {

        #if DEBUG
        print("Error : \(error.localizedDescription)")
        #endif
        delegate?.locationFetchError()
    }

    func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {

        if status == .authorizedAlways || status == .authorizedWhenInUse{
            delegate?.statusChangedToAllowed()
        }
    }
}
