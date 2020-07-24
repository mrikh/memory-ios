//
//  WhereViewController.swift
//  Memory
//
//  Created by Mayank Rikh on 13/07/19.
//  Copyright © 2019 Mayank Rikh. All rights reserved.
//

import GoogleMaps
import UIKit

protocol WhereViewControllerDelegate : AnyObject{

    func userDidCompleteWhereForm()
    func wherePreviousPage()
}

class WhereViewController: BaseViewController {

    @IBOutlet weak var textFieldSeperator: UIView!
    @IBOutlet weak var topTextContainer: UIView!
    @IBOutlet weak var previousButton: UIButton!
    @IBOutlet weak var mapView: GMSMapView!
    @IBOutlet weak var textField: UITextField!
    @IBOutlet weak var infoLabel: UILabel!
    @IBOutlet weak var questionLabel: UILabel!
    @IBOutlet weak var nextButton: UIButton!
    @IBOutlet weak var scrollViewBottomConstraint: NSLayoutConstraint!
    
    weak var delegate : WhereViewControllerDelegate?
    var createModel : CreateModel?
    private var marker : GMSMarker?
    private var firstTime = true

    override func viewDidLoad() {
        super.viewDidLoad()

        initialSetup()
    }

    override func viewWillAppear(_ animated: Bool) {

        super.viewWillAppear(animated)
        navigationController?.setNavigationBarHidden(true, animated: true)
    }

    override func viewDidLayoutSubviews() {

        super.viewDidLayoutSubviews()
        nextButton.layer.cornerRadius = nextButton.bounds.height/2.0
        previousButton.layer.cornerRadius = previousButton.bounds.height/2.0
    }

    override func viewDidAppear(_ animated: Bool) {

        super.viewDidAppear(animated)

        if firstTime{
            firstTime = false
            if let coordinate = LocationManager.shared.currentLocation?.coordinate{
                mapView.camera = GMSCameraPosition.camera(withLatitude: coordinate.latitude, longitude: coordinate.longitude, zoom: 15.0)
            }else{
                mapView.camera = GMSCameraPosition.camera(withLatitude: LocationConstants.defaultLat, longitude: LocationConstants.defaultLong, zoom: 15.0)
            }
        }
    }

    //MARK:- IBAction
    @IBAction func previousAction(_ sender: UIButton) {

        delegate?.wherePreviousPage()
    }

    @IBAction func nextAction(_ sender: UIButton) {

        guard let _ = createModel?.lat, let _ = createModel?.long, let _ = createModel?.addressTitle, let _ = createModel?.address else{

            showAlert(StringConstants.oops.localized, withMessage: StringConstants.enter_address.localized, withCompletion: nil)
            return
        }

        delegate?.userDidCompleteWhereForm()
    }

    //MARK:- Private
    private func initialSetup(){

        questionLabel.text = StringConstants.where_event.localized
        questionLabel.textColor = Colors.bgColor
        questionLabel.font = CustomFonts.avenirHeavy.withSize(22.0)

        infoLabel.text = StringConstants.where_info.localized
        infoLabel.textColor = Colors.bgColor
        infoLabel.font = CustomFonts.avenirLight.withSize(14.0)

        textField.delegate = self

        textFieldSeperator.backgroundColor = Colors.bgColor
        
        previousButton.configureArrowButton(name: .arrowLeft)
        nextButton.configureArrowButton(name: .arrowRight)

        textField.textColor = Colors.bgColor
        textField.font = CustomFonts.avenirMedium.withSize(16.0)
        textField.placeholder = StringConstants.enter_location_where.localized
        textField.text = createModel?.addressTitle

        topTextContainer.addShadow(3.0)
        mapView.isMyLocationEnabled = true

        view.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(handleTap)))

        if let styleURL = Bundle.main.url(forResource: "style", withExtension: "json") {
            mapView.mapStyle = try? GMSMapStyle(contentsOfFileURL: styleURL)
        }
    }

    @objc func handleTap(){

        view.endEditing(true)
    }
}

extension WhereViewController : UITextFieldDelegate{

    func textFieldShouldBeginEditing(_ textField: UITextField) -> Bool {

        let viewController = LocationViewController.instantiate(fromAppStoryboard: .Common)
        viewController.delegate = self
        viewController.addressTitle = createModel?.addressTitle
        viewController.subTitle = createModel?.address
        
        if let lat = createModel?.lat, let long = createModel?.long{
            viewController.coordinate = CLLocationCoordinate2D(latitude: lat, longitude: long)
        }

        navigationController?.pushViewController(viewController, animated: true)
        
        return false
    }
}

extension WhereViewController : LocationViewControllerDelegate{

    func userDidPickLocation(coordinate: CLLocationCoordinate2D, addressTitle: String, subtitle: String) {

        createModel?.addressTitle = addressTitle
        createModel?.lat = coordinate.latitude
        createModel?.long = coordinate.longitude
        createModel?.address = subtitle

        DispatchQueue.main.async{ [weak self] in
            self?.dropPin(coordinate: coordinate, title: addressTitle, subTitle: subtitle)
            self?.mapView.animate(toLocation: coordinate)
        }
        
        textField.text = addressTitle
    }

    private func dropPin(coordinate : CLLocationCoordinate2D, title : String?, subTitle : String?){

        if let _ = marker{
            marker?.position = coordinate
        }else{
            marker = GMSMarker(position: coordinate)
            marker?.appearAnimation = .pop
            marker?.map = mapView
        }

        marker?.title = title
        marker?.snippet = subTitle
    }
}

extension WhereViewController : UITextViewDelegate{

    func textViewDidChange(_ textView: UITextView) {

        createModel?.nearby = textView.text.trimmingCharacters(in: .whitespacesAndNewlines)
    }
}
