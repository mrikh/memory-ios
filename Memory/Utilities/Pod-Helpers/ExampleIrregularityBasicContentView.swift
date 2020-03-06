//
//  ExampleIrregularityBasicContentView.swift
//  UL
//
//  Created by Mayank Rikh on 19/01/20.
//  Copyright © 2020 Mayank Rikh. All rights reserved.
//

import ESTabBarController_swift
import UIKit

class ExampleIrregularityBasicContentView: ExampleBouncesContentView {

    override init(frame: CGRect) {
        super.init(frame: frame)

        textColor = Colors.white
        highlightTextColor = Colors.white
        iconColor = Colors.white
        highlightIconColor = Colors.white
        backdropColor = Colors.bgColor
        highlightBackdropColor = Colors.bgColor
    }

    public required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
