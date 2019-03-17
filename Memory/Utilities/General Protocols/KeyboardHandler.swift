//
//  KeyboardHandler.swift
//  Memory
//
//  Created by Mayank Rikh on 25/01/19.
//  Copyright © 2019 Mayank Rikh. All rights reserved.
//

import Foundation
import UIKit

protocol KeyboardHandler : NSObjectProtocol{
    
    /// Array of bottom constraints to update
    var bottomConstraints : [NSLayoutConstraint] {get}
    
    
    /// This will add the keyboard will appear and keyboard will disappear notifications
    func addKeyboardObservers()
    
    
    /// This will add the keyboard will appear and keyboard will disappear notifications
    ///
    /// - Parameters:
    ///   - appearanceSelector: Pass a custom selector to handle updates on keyboard appearance
    ///   - disappearanceSelector: Pass a custom selector to handle updates on keyboard disappearance
    func addKeyboardObservers(appearanceSelector : Selector?, disappearanceSelector: Selector?)
}

//MARK:- To pass custom selector
extension KeyboardHandler{
    
    var bottomConstraints : [NSLayoutConstraint]{
        return []
    }
    
    func addKeyboardObservers(appearanceSelector : Selector?, disappearanceSelector: Selector?){
        if let selector = appearanceSelector{
            NotificationCenter.default.addObserver(self, selector: selector, name: UIResponder.keyboardWillShowNotification, object: nil)
        }
        
        if let selector = disappearanceSelector{
            NotificationCenter.default.addObserver(self, selector: selector, name: UIResponder.keyboardWillHideNotification, object: nil)
        }
    }
}

//MARK:- Handle automatic scroll up
extension KeyboardHandler where Self : UIViewController{

    func addKeyboardObservers(){

        NotificationCenter.default.addObserver(forName: UIResponder.keyboardWillShowNotification, object: nil, queue: nil) { [weak self] (notification) in
            self?.keyboardWillShow(notification)
        }
        
        NotificationCenter.default.addObserver(forName: UIResponder.keyboardWillHideNotification, object: nil, queue: nil) { [weak self] (notification) in
            self?.keyboardWillHide()
        }
    }

    func removeKeyboardObservers(){
        NotificationCenter.default.removeObserver(self, name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.removeObserver(self, name: UIResponder.keyboardWillHideNotification, object: nil)
    }
    
    //MARK: Private
    private func keyboardWillShow(_ notification : Notification){
        if let keyboardSize = (notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue)?.cgRectValue {
            animateConstraints(withConstraintValue: keyboardSize.size.height)
        }
    }
    
    private func keyboardWillHide(){
        animateConstraints(withConstraintValue: 0)
    }
    
    private func animateConstraints(withConstraintValue value : CGFloat){

        bottomConstraints.forEach { (constraint) in
            constraint.constant = value
        }

        view.layoutIfNeeded()
    }
}
