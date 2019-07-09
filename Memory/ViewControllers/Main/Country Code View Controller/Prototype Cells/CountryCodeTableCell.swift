//
//  CountryCodeTableCell.swift
//  Memory
//
//  Created by Mayank Rikh on 09/07/19.
//  Copyright © 2019 Mayank Rikh. All rights reserved.
//

import UIKit

class CountryCodeTableCell: UITableViewCell {

    @IBOutlet weak var countryNameLabel: UILabel!
    @IBOutlet weak var flagImageView: UIImageView!
    
    override func awakeFromNib() {
        super.awakeFromNib()

        setColorsAndFonts()
        countryNameLabel.text = nil
    }

    override func prepareForReuse() {
        super.prepareForReuse()
        countryNameLabel.text = ""
    }

    //MARK:- Private
    private func setColorsAndFonts() {

        countryNameLabel.textColor = Colors.bgColor
        countryNameLabel.font = CustomFonts.avenirMedium.withSize(14.0)
    }
}
