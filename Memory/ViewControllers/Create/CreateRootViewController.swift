//
//  CreateRootViewController.swift
//  Memory
//
//  Created by Mayank Rikh on 21/07/20.
//  Copyright © 2020 Mayank Rikh. All rights reserved.
//

import UIKit

class CreateRootViewController: BaseViewController {

    @IBOutlet weak var crossButton: UIButton!
    @IBOutlet weak var containerView: UIView!

    override func viewDidLoad() {
        super.viewDidLoad()

        view.insertOnFullScreen(MRCustomBlur(effect: UIBlurEffect(style: .regular), intensity: 0.25), atIndex: 0)
    }

    //MARK:- IBAction
    @IBAction func crossAction(_ sender: UIButton) {

        dismiss(animated: true, completion: nil)
    }
}
