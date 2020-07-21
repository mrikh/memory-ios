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
        tabBar.barTintColor = Colors.white
        self.delegate = self

        if let viewControllers = viewControllers{

            if let navigationController = viewControllers[4] as? UINavigationController{
                let viewController = LoginToContinueViewController.instantiate(fromAppStoryboard: .Main)
                navigationController.setViewControllers([viewController], animated: true)
            }

            let exploreImage = UIImage.fontAwesomeIcon(name: FontAwesome.search, style: .solid, textColor: Colors.black, size: CGSize(width: 28.0, height : 28.0))
            let profileImage = UIImage.fontAwesomeIcon(name: FontAwesome.userCog, style: .solid, textColor: Colors.black, size: CGSize(width: 28.0, height : 28.0))
            let friendsImage = UIImage.fontAwesomeIcon(name: FontAwesome.userFriends, style: .solid, textColor: Colors.black, size: CGSize(width: 28.0, height : 28.0))
            let chatImage = UIImage.fontAwesomeIcon(name: FontAwesome.comments, style: .solid, textColor: Colors.black, size: CGSize(width: 28.0, height : 28.0))

            viewControllers[0].tabBarItem = ESTabBarItem.init(ExampleBouncesContentView(), title: nil, image: exploreImage, selectedImage: exploreImage, tag: 0)
            viewControllers[1].tabBarItem = ESTabBarItem.init (ExampleBouncesContentView(), title: nil, image: friendsImage, selectedImage: friendsImage, tag: 1)
            viewControllers[2].tabBarItem = UITabBarItem(title: nil, image: #imageLiteral(resourceName: "create_plus"), selectedImage: #imageLiteral(resourceName: "create_plus"))
            viewControllers[3].tabBarItem = ESTabBarItem.init (ExampleBouncesContentView(), title: nil, image: chatImage, selectedImage: chatImage, tag: 3)
            viewControllers[4].tabBarItem = ESTabBarItem.init (ExampleBouncesContentView(), title: nil, image: profileImage, selectedImage: profileImage, tag: 4)
        }
    }
}

extension CustomTabBarController : UITabBarControllerDelegate{

    func tabBarController(_ tabBarController: UITabBarController, shouldSelect viewController: UIViewController) -> Bool {

        if let index = tabBarController.viewControllers?.firstIndex(where: {$0 == viewController}), index == 2{

            if !UserModel.isLoggedIn{

                let viewController = LoginToContinueViewController.instantiate(fromAppStoryboard: .Main)
                viewController.showClose = true
                let navigationController = FlowManager.createNavigationController(viewController)
                present(navigationController, animated: true, completion: nil)

            }else if !UserModel.current.phoneVerified{

                let viewController = PhoneNumberViewController.instantiate(fromAppStoryboard: .Main)
                let navigationController = FlowManager.createNavigationController(viewController)
                present(navigationController, animated: true, completion: nil)
            }else{

                //present create screen
//                navigationController.transitioningDelegate = self
            }

            return false
        }

        return true
    }
}

extension CustomTabBarController : UIViewControllerTransitioningDelegate{

    func animationController(forPresented presented: UIViewController, presenting: UIViewController, source: UIViewController) -> UIViewControllerAnimatedTransitioning? {

        let animator = CircleFadeInAniamtor()
        let view = UIView(frame : self.view.frame)
        let tabbarItem = tabBar.subviews[2]
        if let frame = tabbarItem.subviews.first?.frame{
            let convert = tabbarItem.convert(frame, to: view)
            animator.triggerFrame = convert
            return animator
        }else{
            return nil
        }
    }

    func animationController(forDismissed dismissed: UIViewController) -> UIViewControllerAnimatedTransitioning? {

        let animator = CircularFadeOutAnimation()
        let view = UIView(frame : self.view.frame)
        let tabbarItem = tabBar.subviews[2]
        if let frame = tabbarItem.subviews.first?.frame{
            let convert = tabbarItem.convert(frame, to: view)
            animator.triggerFrame = convert
            return animator
        }else{
            return nil
        }
    }
}

