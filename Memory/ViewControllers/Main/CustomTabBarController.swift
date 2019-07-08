//
//  CustomTabBarController.swift
//  Memory
//
//  Created by Mayank Rikh on 08/07/19.
//  Copyright © 2019 Mayank Rikh. All rights reserved.
//

import FontAwesome_swift
import UIKit

class CustomTabBarController: UITabBarController {

    private var firstTime = true

    override func viewDidLoad() {
        super.viewDidLoad()

        initialSetup()
    }

    override func viewWillAppear(_ animated: Bool) {

        super.viewWillAppear(animated)
        if firstTime{
            tabBar.tintColor = Colors.bgColor
            if let items = tabBar.items{
                for (index, item) in items.enumerated(){
                    if index == 0{
                        item.title = StringConstants.home.localized
                        item.image = UIImage.fontAwesomeIcon(name: FontAwesome.home, style: .solid, textColor: Colors.black, size: CGSize(width: 28.0, height : 28.0))
                    }else if index == 1{
                        item.title = StringConstants.explore.localized
                        item.image = UIImage.fontAwesomeIcon(name: FontAwesome.search, style: .solid, textColor: Colors.black, size: CGSize(width: 28.0, height : 28.0))
                    }else if index == 2{
                        item.title = StringConstants.create.localized
                        item.image = UIImage.fontAwesomeIcon(name: FontAwesome.pen, style: .solid, textColor: Colors.black, size: CGSize(width: 28.0, height : 28.0))
                    }
                }
            }

            firstTime = false
        }
    }

    //MARK:- Private
    private func initialSetup(){

        if !UserModel.current.phoneVerified{
            if let navigationController = viewControllers?[2] as? UINavigationController{
                let viewController = PhoneNumberViewController.instantiate(fromAppStoryboard: .PreLogin)
                navigationController.setViewControllers([viewController], animated: true)
            }
        }
    }
}
