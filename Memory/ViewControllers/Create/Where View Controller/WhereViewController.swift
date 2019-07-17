//
//  WhereViewController.swift
//  Memory
//
//  Created by Mayank Rikh on 13/07/19.
//  Copyright © 2019 Mayank Rikh. All rights reserved.
//

import KMPlaceholderTextView
import MapKit
import UIKit

protocol WhereViewControllerDelegate : AnyObject{

    func userDidCompleteWhereForm()
}

class WhereViewController: BaseViewController, KeyboardHandler {

    @IBOutlet weak var questionLabel: UILabel!
    @IBOutlet weak var cardView: UIView!
    @IBOutlet weak var whereTextField: MRTextField!
    @IBOutlet weak var nextButton: UIButton!
    @IBOutlet weak var scrollViewBottomConstraint: NSLayoutConstraint!
    @IBOutlet weak var nearbyTextView: KMPlaceholderTextView!
    
    weak var delegate : WhereViewControllerDelegate?
    var createModel : CreateModel?

    var bottomConstraints: [NSLayoutConstraint]{
        return [scrollViewBottomConstraint]
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        initialSetup()
    }

    override func viewWillAppear(_ animated: Bool) {

        super.viewWillAppear(animated)
        addKeyboardObservers()
        navigationController?.navigationBar.shadowImage = UIImage()
    }

    override func viewDidLayoutSubviews() {

        super.viewDidLayoutSubviews()
        //done as in case of iphone x there was extra padding when keyboard comes up and it was annoying me
        extraPadding = view.safeAreaInsets.bottom
    }

    override func viewWillDisappear(_ animated: Bool) {

        removeKeyboardObservers()
        super.viewWillDisappear(animated)
    }

    //MARK:- IBAction
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
        questionLabel.font = CustomFonts.avenirHeavy.withSize(18.0)

        nearbyTextView.text = ""
        nearbyTextView.placeholder = StringConstants.nearby_landmarks.localized
        nearbyTextView.textColor = Colors.bgColor
        nearbyTextView.font = CustomFonts.avenirMedium.withSize(14.0)
        nearbyTextView.addShadow(3.0, opacity : 0.3)

        cardView.layer.cornerRadius = 10.0
        cardView.addShadow(3.0, opacity: 0.3)

        whereTextField.configure(with: StringConstants.enter_location_where.localized, text: createModel?.address, primaryColor: Colors.bgColor, unselectedBottomColor: Colors.bgColor.withAlphaComponent(0.25))

        nextButton.layer.cornerRadius = 5.0
        nextButton.addShadow(3.0, opacity: 0.3)

        nextButton.setAttributedTitle(NSAttributedString(string : StringConstants.go_next.localized, attributes : [.foregroundColor : Colors.bgColor, .font : CustomFonts.avenirHeavy.withSize(15.0), .underlineStyle : NSUnderlineStyle.single.rawValue]), for: .normal)

        cardView.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(handleTap)))
    }

    @objc func handleTap(){

        view.endEditing(true)
    }
}

extension WhereViewController : UITextFieldDelegate{

    func textFieldShouldBeginEditing(_ textField: UITextField) -> Bool {

        let viewController = LocationViewController.instantiate(fromAppStoryboard: .Create)
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

        whereTextField.text = addressTitle
    }
}

extension WhereViewController : UITextViewDelegate{

    func textViewDidChange(_ textView: UITextView) {

        createModel?.nearby = textView.text.trimmingCharacters(in: .whitespacesAndNewlines)
    }
}