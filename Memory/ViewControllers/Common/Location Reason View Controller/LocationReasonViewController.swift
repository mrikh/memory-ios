//
//  LocationReasonViewController.swift
//  Memory
//
//  Created by Mayank Rikh on 24/06/20.
//  Copyright © 2020 Mayank Rikh. All rights reserved.
//

import UIKit

class LocationReasonViewController: BaseViewController {

    @IBOutlet weak var cancelButton: UIButton!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var infoLabel : UILabel!
    @IBOutlet weak var doneButton : MRAnimatingButton!

    override func viewDidLoad() {
        super.viewDidLoad()

        initialSetup()
    }
    
    //MARK:- IBAction
    @IBAction func doneAction(_ sender : UIButton){

        //will ask permission
        LocationManager.shared.delegate = self
        LocationManager.shared.setupLocationManager()
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
        infoLabel.text = StringConstants.location_permission_info.localized

        doneButton.setTitle(StringConstants.allow.localized, for: .normal)
        doneButton.enableButton()

        cancelButton.setTitleColor(Colors.bgColor, for: .normal)
        cancelButton.setTitle(StringConstants.cancel.localized, for: .normal)
        cancelButton.setAttributedTitle(NSAttributedString(string : StringConstants.cancel.localized, attributes : [.foregroundColor : Colors.bgColor, .font : CustomFonts.avenirHeavy.withSize(12.0), .underlineStyle : NSUnderlineStyle.single.rawValue]), for: .normal)
    }
}

extension LocationReasonViewController : LocationManagerDelegate{

    func didFetchLocation() {}

    func locationFetchError() {}

    func statusChangedToAllowed() {}

    func didUpdatePermissionStatus() {
        dismiss(animated: true, completion: nil)
    }
}
