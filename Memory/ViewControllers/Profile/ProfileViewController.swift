//
//  ProfileViewController.swift
//  Memory
//
//  Created by Mayank Rikh on 15/08/19.
//  Copyright © 2019 Mayank Rikh. All rights reserved.
//

import MXParallaxHeader
import UIKit

class ProfileViewController: BaseViewController {

    @IBOutlet weak var mainScrollView: UIScrollView!

    override func viewDidLoad() {
        super.viewDidLoad()

        initialSetup()
    }

    //MARK:- Private
    private func initialSetup(){

        navigationItem.largeTitleDisplayMode = .never
        navigationItem.title = UserModel.current.username

        let view = HeaderView.nib.instantiate(withOwner: nil, options: nil).first as? HeaderView
        view?.configure(name: UserModel.current.name, imageUrl: UserModel.current.profilePhoto)

        mainScrollView.parallaxHeader.view = view
        mainScrollView.parallaxHeader.height = UIScreen.main.bounds.height/2.0
        mainScrollView.parallaxHeader.mode = MXParallaxHeaderMode.fill
        mainScrollView.parallaxHeader.minimumHeight = 55.0
    }
}
