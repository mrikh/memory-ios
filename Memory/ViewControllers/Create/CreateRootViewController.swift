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
    @IBOutlet weak var shadowView: UIView!
    @IBOutlet weak var containerView: UIView!

    override func viewDidLoad() {
        super.viewDidLoad()

        initialSetup()
    }

    //MARK:- IBAction
    @IBAction func crossAction(_ sender: UIButton) {

        dismiss(animated: true, completion: nil)
    }

    //MARK:- Private
    private func initialSetup(){

        view.insertOnFullScreen(MRCustomBlur(effect: UIBlurEffect(style: .regular), intensity: 0.25), atIndex: 0)

        containerView.layer.cornerRadius = 15.0
        containerView.clipsToBounds = true
        shadowView.addShadow(3.0)
    }
}
