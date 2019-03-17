//
//  MRSkyTextField.swift
//  Jhaiho
//
//  Created by Mayank on 11/10/18.
//  Copyright © 2018 Jhaiho. All rights reserved.
//

import SkyFloatingLabelTextField
import UIKit

class MRSkyTextField: SkyFloatingLabelTextField {

    func configure(with placeholder : String?){

        titleFormatter = {$0}

        selectedLineHeight = 1.25
        lineColor = Colors.inactiveButtonTitleColor
        selectedLineColor = Colors.activeButtonTitleColor
        selectedTitleColor = Colors.activeButtonTitleColor

        titleFont = CustomFonts.avenirMedium.withSize(11.0)
        placeholderFont = CustomFonts.avenirMedium.withSize(11.0)

        textColor = Colors.activeButtonTitleColor
        font = CustomFonts.avenirMedium.withSize(16.0)
        self.placeholder = placeholder
    }

    func startAnimating(){
        
        let activityIndicator = UIActivityIndicatorView()
        //hit and trial value
        activityIndicator.center.x = activityIndicator.center.x + 17.0
        activityIndicator.center.y = activityIndicator.center.y + 17.0
        activityIndicator.style = .gray
        activityIndicator.startAnimating()
        activityIndicator.hidesWhenStopped = true

        self.rightViewMode = .always
        self.rightView = createView(withView: activityIndicator)
    }
    
    func stopAnimating(){
        
        if let position = self.rightView?.subviews.index(where : {$0 is UIActivityIndicatorView}){
            
            let tempView = self.rightView?.subviews[position] as! UIActivityIndicatorView
            tempView.stopAnimating()
        }
        
        self.rightViewMode = .never
        self.rightView = nil
    }
    
    private func createView(withView view : UIView)->UIView{
        
        let tempView = UIView(frame: CGRect(x: 0, y: 0, width: 30, height: 20))
        tempView.addSubview(view)
        return tempView
    }
}
