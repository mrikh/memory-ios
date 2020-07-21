//
//  LocationReasonViewController.swift
//  Memory
//
//  Created by Mayank Rikh on 24/06/20.
//  Copyright © 2020 Mayank Rikh. All rights reserved.
//

import UIKit

protocol LocationReasonViewControllerDelegate : AnyObject {

    func didGrantPermission()
}

class LocationReasonViewController: BaseViewController {

    @IBOutlet weak var cancelButton: UIButton!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var infoLabel : UILabel!
    @IBOutlet weak var doneButton : MRAnimatingButton!

    weak var delegate : LocationReasonViewControllerDelegate?

    override func viewDidLoad() {
        super.viewDidLoad()

        initialSetup()
    }
    
    //MARK:- IBAction
    @IBAction func doneAction(_ sender : UIButton){

        //will ask permission
        let status = LocationManager.shared.locationEnabled
        LocationManager.shared.delegate = self

        if status.notAsked{
            LocationManager.shared.setupLocationManager()
        }else if status.denied{
            showRedirectAlert(StringConstants.are_sure.localized, withMessage: StringConstants.redirect_location.localized)
        }
    }

    @IBAction func cancelAction(_ sender: UIButton) {
        dismiss(animated: true, completion: nil)
    }

    //MARK:- Private
    private func initialSetup(){

        titleLabel.text = StringConstants.location_permission_title.localized
        titleLabel.textColor = Colors.bgColor
        titleLabel.font = CustomFonts.avenirMedium.withSize(18.0)

        infoLabel.textColor = Colors.bgColor
        infoLabel.font = CustomFonts.avenirMedium.withSize(13.0)

        doneButton.setTitle(StringConstants.allow.localized, for: .normal)
        doneButton.enableButton()

        cancelButton.setTitleColor(Colors.bgColor, for: .normal)
        cancelButton.setTitle(StringConstants.cancel.localized, for: .normal)
        cancelButton.setAttributedTitle(NSAttributedString(string : StringConstants.cancel.localized, attributes : [.foregroundColor : Colors.bgColor, .font : CustomFonts.avenirHeavy.withSize(12.0), .underlineStyle : NSUnderlineStyle.single.rawValue]), for: .normal)

        if LocationManager.shared.locationEnabled.denied{
            infoLabel.text = StringConstants.location_permission_redirect.localized
        }else{
            infoLabel.text = StringConstants.location_permission_info.localized
        }
    }
}

extension LocationReasonViewController : LocationManagerDelegate{

    func didFetchLocation() {}

    func locationFetchError() {}

    func statusChangedToAllowed() {
        
        delegate?.didGrantPermission()
    }

    func didUpdatePermissionStatus() {
        
        dismiss(animated: true, completion: nil)
    }
}
