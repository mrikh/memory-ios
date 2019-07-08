//
//  CreateViewController.swift
//  Memory
//
//  Created by Mayank Rikh on 08/07/19.
//  Copyright © 2019 Mayank Rikh. All rights reserved.
//

import UIKit

class PhoneNumberViewController: BaseViewController, KeyboardHandler {

    @IBOutlet weak var scrollBottomConstraint: NSLayoutConstraint!
    @IBOutlet weak var phoneNumberTextField: MRTextField!
    @IBOutlet weak var countryCodeTextField: UITextField!
    @IBOutlet weak var infoLabel: UILabel!
    @IBOutlet weak var doneButton: MRAnimatingButton!

    var bottomConstraints: [NSLayoutConstraint]{
        return [scrollBottomConstraint]
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        initialSetup()
    }

    override func viewWillAppear(_ animated: Bool) {

        super.viewWillAppear(animated)
        addKeyboardObservers()
        navigationController?.setNavigationBarHidden(false, animated: true)
    }

    override func viewWillDisappear(_ animated: Bool) {

        removeKeyboardObservers()
        super.viewWillDisappear(animated)
    }

    //MARK:- IBAction

    @IBAction func doneAction(_ sender: MRAnimatingButton) {

    }

    //MARK:- Private
    private func initialSetup(){

        navigationItem.title = StringConstants.phone_title.localized
        navigationItem.largeTitleDisplayMode = .always

        infoLabel.text = StringConstants.phone_info.localized
        infoLabel.textColor = Colors.black
        infoLabel.font = CustomFonts.avenirMedium.withSize(16.0)

        doneButton.setTitle(StringConstants.done.localized, for: .normal)

        phoneNumberTextField.configure(with: StringConstants.phone_number.localized, text: nil, primaryColor: Colors.bgColor, unselectedBottomColor: Colors.bgColor.withAlphaComponent(0.25))

        let gesture = UITapGestureRecognizer(target: self, action: #selector(handleTap))
        view.addGestureRecognizer(gesture)
    }

    @objc func handleTap(){
        view.endEditing(true)
    }
}
