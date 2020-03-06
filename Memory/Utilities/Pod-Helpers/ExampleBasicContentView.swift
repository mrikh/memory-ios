//
//  ExampleBasicContentView.swift
//  UL
//
//  Created by Mayank Rikh on 17/01/20.
//  Copyright © 2020 Mayank Rikh. All rights reserved.
//

import ESTabBarController_swift
import UIKit

class ExampleBasicContentView: ESTabBarItemContentView {

    override init(frame: CGRect) {
        super.init(frame: frame)
        textColor = UIColor.init(white: 175.0 / 255.0, alpha: 1.0)
        highlightTextColor = Colors.bgColor
        iconColor = UIColor.init(white: 175.0 / 255.0, alpha: 1.0)
        highlightIconColor = Colors.bgColor
    }

    public required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
