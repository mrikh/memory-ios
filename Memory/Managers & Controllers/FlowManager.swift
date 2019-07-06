//
//  FlowManager.swift
//  Memory
//
//  Created by Mayank Rikh on 30/11/18.
//  Copyright © 2018 Mayank Rikh. All rights reserved.
//

import UIKit

class FlowManager{
    
    /// This method will check various properties to determine which screen we need to open.
    static func checkAppInitializationFlow(){

        configureNavigationBar()

        if let _ = Defaults.value(forKey: Defaults.Key.userInfo){
            //user exists
        }
    }

    static func createNavigationController(_ viewController : UIViewController) -> UINavigationController{

        let navigationController = UINavigationController(rootViewController: viewController)
        navigationController.setNavigationBarHidden(true, animated: false)
        return navigationController
    }

    static func gotToLandingScreen(){

//        let storyboard = UIStoryboard(name: "Main", bundle: nil)
//        guard let tabbar = storyboard.instantiateViewController(withIdentifier: "CustomTabBarController") as? CustomTabBarController else {return}
//
//        let window = (UIApplication.shared.delegate as? AppDelegate)?.window
//        window?.rootViewController = tabbar
//        window?.makeKeyAndVisible()
    }
    
    static func goToLogin(){

//        let viewController = WelcomeViewController.instantiate(fromAppStoryboard: .Main)
//        let window = (UIApplication.shared.delegate as? AppDelegate)?.window
//        window?.rootViewController = viewController
//        window?.makeKeyAndVisible()
    }

    static func clearAllData(){

        UserModel.current = UserModel(JSON())
        Defaults.removeValue(forKey: .userInfo)
    }

    static func configureNavigationBar(){

        let navigationBarAppearance = UINavigationBar.appearance()

        navigationBarAppearance.shadowImage = UIImage()
        navigationBarAppearance.barTintColor = .white
        navigationBarAppearance.tintColor = .black
        navigationBarAppearance.prefersLargeTitles = true
        navigationBarAppearance.isTranslucent = false
        navigationBarAppearance.titleTextAttributes = [.foregroundColor: Colors.bgColor, .font: CustomFonts.avenirHeavy.withSize(16.0)]
        navigationBarAppearance.largeTitleTextAttributes = [.foregroundColor: Colors.bgColor, .font: CustomFonts.avenirHeavy.withSize(34.0)]
    }
}
