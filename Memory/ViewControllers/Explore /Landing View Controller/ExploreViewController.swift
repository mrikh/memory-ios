//
//  ExploreViewController.swift
//  Memory
//
//  Created by Mayank Rikh on 24/06/20.
//  Copyright © 2020 Mayank Rikh. All rights reserved.
//

import FontAwesome_swift
import GoogleMaps
import UIKit

class ExploreViewController: BaseViewController {

    private var isFirstTime = true
    private let viewModel = ExploreViewModel()

    @IBOutlet weak var locationImageView: UIImageView!
    @IBOutlet weak var locationContainerView: UIView!
    @IBOutlet weak var whiteActivityIndicator: UIActivityIndicatorView!
    @IBOutlet weak var locationButton: UIButton!
    @IBOutlet weak var mapView: GMSMapView!
    @IBOutlet weak var carousel: iCarousel!

    override func viewDidLoad() {
        super.viewDidLoad()
        initialSetup()
    }

    override func viewWillAppear(_ animated: Bool) {

        super.viewWillAppear(animated)
        navigationController?.setNavigationBarHidden(true, animated: true)

        if isFirstTime{
            isFirstTime = false
            viewModel.startLocationFetch()
        }
    }

    override func viewDidLayoutSubviews() {

        super.viewDidLayoutSubviews()
        locationContainerView.layer.cornerRadius = locationContainerView.bounds.height/2.0
    }

    //MARK:- IBAction
    @IBAction func locationAction(_ sender: UIButton) {

        let viewController = LocationViewController.instantiate(fromAppStoryboard: .Common)
        viewController.delegate = self
        navigationController?.pushViewController(viewController, animated: true)
    }

    //MARK:- Private
    private func initialSetup(){

        carousel.type = .rotary
        viewModel.delegate = self

        search(start: true)
        locationButton.setTitleColor(Colors.black, for: .normal)
        locationButton.titleLabel?.font = CustomFonts.avenirMedium.withSize(14.0)

        mapView.isMyLocationEnabled = true
        mapView.camera = GMSCameraPosition.camera(withLatitude: 0.0, longitude: 0.0, zoom: 15.0)

        locationContainerView.clipsToBounds = true
        locationContainerView.insertOnFullScreen(MRCustomBlur(effect: UIBlurEffect(style: .regular), intensity: 0.25), atIndex: 0)

        if let styleURL = Bundle.main.url(forResource: "style", withExtension: "json") {
            mapView.mapStyle = try? GMSMapStyle(contentsOfFileURL: styleURL)
        }
    }

    private func search(start : Bool){

        start ? whiteActivityIndicator.startAnimating() : whiteActivityIndicator.stopAnimating()
    }
}

extension ExploreViewController : ExploreViewModelDelegate{

    func locationPermissionNotAsked() {

        let viewController = LocationReasonViewController.instantiate(fromAppStoryboard: .Common)
        present(viewController, animated: true, completion: nil)
    }

    func reloadData() {

    }

    func isFetchingLocation() {

        search(start: true)
    }

    func doneFetchingLocation(name : String) {

        locationButton.setTitle(name, for: .normal)
        search(start: false)
    }

    func locationUpdated(coordinate : CLLocationCoordinate2D) {

        mapView.animate(toLocation: coordinate)
    }

    func deniedLocation() {

        locationButton.setTitle(StringConstants.update_location.localized, for: .normal)
        search(start: false)
    }
}

extension ExploreViewController : LocationViewControllerDelegate{

    func userDidPickLocation(coordinate: CLLocationCoordinate2D, addressTitle: String, subtitle: String) {


    }
}
