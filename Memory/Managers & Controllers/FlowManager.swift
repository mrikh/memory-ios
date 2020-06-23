//
//  FlowManager.swift
//  Memory
//
//  Created by Mayank Rikh on 30/11/18.
//  Copyright © 2018 Mayank Rikh. All rights reserved.
//

import SwiftyJSON
import UIKit

class FlowManager{
    
    /// This method will check various properties to determine which screen we need to open.
    static func checkAppInitializationFlow(){

        configureNavigationBar()

        if Defaults.value(forKey : Defaults.Key.tutorialDone) == nil{
            let window = (UIApplication.shared.delegate as? AppDelegate)?.window
            window?.rootViewController = createNavigationController(TutorialPageViewController.instantiate(fromAppStoryboard: .PreLogin))
            window?.makeKeyAndVisible()
        }else if let _ = Defaults.value(forKey: Defaults.Key.userInfo){
            gotToLandingScreen()
        }
    }

    static func createNavigationController(_ viewController : UIViewController) -> UINavigationController{

        let navigationController = UINavigationController(rootViewController: viewController)
        navigationController.setNavigationBarHidden(true, animated: false)
        return navigationController
    }

    static func gotToLandingScreen(){

        let nav = createNavigationController(CustomTabBarController.instantiate(fromAppStoryboard: .Main))
        let window = (UIApplication.shared.delegate as? AppDelegate)?.window
        window?.rootViewController = nav
        window?.makeKeyAndVisible()
    }
    
    static func goToLogin(){

        let viewController = createNavigationController(LoginViewController.instantiate(fromAppStoryboard: .PreLogin))
        let window = (UIApplication.shared.delegate as? AppDelegate)?.window
        window?.rootViewController = viewController
        window?.makeKeyAndVisible()
    }

    static func clearAllData(){

        UserModel.current = UserModel(JSON())
        Defaults.removeAllValues()
    }

    static func configureNavigationBar(){

        let navigationBarAppearance = UINavigationBar.appearance()

        navigationBarAppearance.tintColor = .black
        navigationBarAppearance.prefersLargeTitles = true
        navigationBarAppearance.titleTextAttributes = [.foregroundColor: Colors.bgColor, .font: CustomFonts.avenirHeavy.withSize(16.0)]
        navigationBarAppearance.largeTitleTextAttributes = [.foregroundColor: Colors.bgColor, .font: CustomFonts.avenirHeavy.withSize(34.0)]
    }
}
