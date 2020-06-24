//
//  ExploreViewController.swift
//  Memory
//
//  Created by Mayank Rikh on 24/06/20.
//  Copyright © 2020 Mayank Rikh. All rights reserved.
//

import UIKit

class ExploreViewController: BaseViewController {

    private var isFirstTime = true

    override func viewDidLoad() {
        super.viewDidLoad()
    }

    override func viewWillAppear(_ animated: Bool) {

        super.viewWillAppear(animated)
        navigationController?.setNavigationBarHidden(true, animated: true)
    }

    override func viewDidAppear(_ animated: Bool) {

        super.viewDidAppear(animated)

        if isFirstTime{
            isFirstTime = false
            if LocationManager.shared.locationEnabled.notAsked{
                let viewController = LocationReasonViewController.instantiate(fromAppStoryboard: .Common)
                present(viewController, animated: true, completion: nil)
            }
        }
    }
}
