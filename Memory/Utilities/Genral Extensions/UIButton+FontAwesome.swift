//
//  UIButton+FontAwesome.swift
//  Memory
//
//  Created by Mayank Rikh on 20/06/20.
//  Copyright © 2020 Mayank Rikh. All rights reserved.
//

import FontAwesome_swift
import UIKit

extension UIButton{

    func configureFontAwesome(name : FontAwesome, titleColor : UIColor = Colors.bgColor, size : CGFloat, style : FontAwesomeStyle = FontAwesomeStyle.brands){

        setTitle(String.fontAwesomeIcon(name: name), for: .normal)
        setTitleColor(titleColor, for: .normal)
        titleLabel?.font = UIFont.fontAwesome(ofSize: size.getFontSize, style: style)
    }
}
