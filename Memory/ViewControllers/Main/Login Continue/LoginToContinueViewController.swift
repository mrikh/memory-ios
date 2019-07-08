//
//  LoginToContinueViewController.swift
//  Memory
//
//  Created by Mayank Rikh on 09/07/19.
//  Copyright © 2019 Mayank Rikh. All rights reserved.
//

import UIKit

class LoginToContinueViewController: BaseViewController {

    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var infoLabel: UILabel!
    @IBOutlet weak var doneButton: MRAnimatingButton!

    override func viewDidLoad() {

        super.viewDidLoad()

        initialSetup()
    }

    override func viewWillAppear(_ animated: Bool) {

        super.viewWillAppear(animated)
        navigationController?.setNavigationBarHidden(true, animated: true)
    }

    //MARK:- IBAction
    @IBAction func doneAction(_ sender: MRAnimatingButton) {
        
        FlowManager.goToLogin()
    }

    //MARK:- Private
    private func initialSetup(){

        titleLabel.text = StringConstants.oops.localized
        titleLabel.textColor = Colors.black
        titleLabel.font = CustomFonts.avenirHeavy.withSize(28.0)

        infoLabel.text = StringConstants.info_login_continue.localized
        infoLabel.textColor = Colors.black
        infoLabel.font = CustomFonts.avenirMedium.withSize(16.0)

        doneButton.setTitle(StringConstants.login.localized, for: .normal)
    }
}
