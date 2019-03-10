//
//  ViewController + General.swift
//  Memory
//
//  Created by Mayank Rikh on 25/01/19.
//  Copyright © 2019 Mayank Rikh. All rights reserved.
//

import UIKit

extension UIViewController{
    
    /// This was done so that the back button doesnt show the title of the view controller
    func clearBackTitle(){
        navigationItem.backBarButtonItem = UIBarButtonItem(title: " ", style: .plain, target: nil, action: nil)
    }
}
