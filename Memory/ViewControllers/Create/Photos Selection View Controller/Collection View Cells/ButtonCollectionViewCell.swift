//
//  ButtonCollectionViewCell.swift
//  Memory
//
//  Created by Mayank Rikh on 17/07/19.
//  Copyright © 2019 Mayank Rikh. All rights reserved.
//

import UIKit

class ButtonCollectionViewCell: UICollectionViewCell {

    @IBOutlet weak var mainButton: UIButton!
    var buttonAction : (()->())?

    //MARK:- IBAction
    @IBAction func mainAction(_ sender: UIButton) {

        buttonAction?()
    }
}
