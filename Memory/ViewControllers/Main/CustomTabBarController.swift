//
//  CustomTabBarController.swift
//  Memory
//
//  Created by Mayank Rikh on 08/07/19.
//  Copyright © 2019 Mayank Rikh. All rights reserved.
//

import ESTabBarController_swift
import FontAwesome_swift
import UIKit

class CustomTabBarController: ESTabBarController {

    override func viewDidLoad() {
        super.viewDidLoad()

        initialSetup()
    }

    //MARK:- Private
    private func initialSetup(){

        tabBar.tintColor = Colors.bgColor

        //not logged in
        if !UserModel.isLoggedIn{
            if let navigationController = viewControllers?[2] as? UINavigationController{
                let viewController = LoginToContinueViewController.instantiate(fromAppStoryboard: .Main)
                navigationController.setViewControllers([viewController], animated: true)
            }

            if let navigationController = viewControllers?[3] as? UINavigationController{
                let viewController = LoginToContinueViewController.instantiate(fromAppStoryboard: .Main)
                navigationController.setViewControllers([viewController], animated: true)
            }

        }else if !UserModel.current.phoneVerified{
            if let navigationController = viewControllers?[2] as? UINavigationController{
                let viewController = PhoneNumberViewController.instantiate(fromAppStoryboard: .Main)
                navigationController.setViewControllers([viewController], animated: true)
            }
        }

        if let viewControllers = viewControllers{
            let exploreImage = UIImage.fontAwesomeIcon(name: FontAwesome.search, style: .solid, textColor: Colors.black, size: CGSize(width: 28.0, height : 28.0))
            let penImage = UIImage.fontAwesomeIcon(name: FontAwesome.pen, style: .solid, textColor: Colors.black, size: CGSize(width: 28.0, height : 28.0))
            let profileImage = UIImage.fontAwesomeIcon(name: FontAwesome.userCog, style: .solid, textColor: Colors.black, size: CGSize(width: 28.0, height : 28.0))
            let friendsImage = UIImage.fontAwesomeIcon(name: FontAwesome.userFriends, style: .solid, textColor: Colors.black, size: CGSize(width: 28.0, height : 28.0))

            viewControllers[0].tabBarItem = ESTabBarItem.init(ExampleBouncesContentView(), title: StringConstants.explore.localized, image: exploreImage, selectedImage: exploreImage, tag: 0)
            viewControllers[1].tabBarItem = ESTabBarItem.init (ExampleBouncesContentView(), title: StringConstants.friends.localized, image: friendsImage, selectedImage: friendsImage, tag: 1)
            viewControllers[2].tabBarItem = ESTabBarItem.init (ExampleBouncesContentView(), title: StringConstants.create.localized, image: penImage, selectedImage: penImage, tag: 2)
            viewControllers[3].tabBarItem = ESTabBarItem.init (ExampleBouncesContentView(), title: StringConstants.profile.localized, image: profileImage, selectedImage:
                profileImage, tag: 4)
        }
    }
}
