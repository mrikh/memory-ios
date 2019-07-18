//
//  ImageCollectionViewCell.swift
//  Memory
//
//  Created by Mayank Rikh on 18/07/19.
//  Copyright © 2019 Mayank Rikh. All rights reserved.
//

import UIKit

class ImageCollectionViewCell: UICollectionViewCell {

    @IBOutlet weak var checkBoxButton: MRCheckBoxButton!
    @IBOutlet weak var mainImageView: UIImageView!
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!


    override func awakeFromNib() {

        super.awakeFromNib()
        checkBoxButton.tickBackgroundFillColor = Colors.bgColor.withAlphaComponent(0.5)
        checkBoxButton.tickColor = Colors.white
        checkBoxButton.tickWidth = 8.0
    }

    override func prepareForReuse() {

        super.prepareForReuse()
        checkBoxButton.updateSelection(select: false)
    }

    func updateLoader(animate : Bool){
        
        animate ? activityIndicator.startAnimating() : activityIndicator.stopAnimating()
    }

    func configure(currentSelected : Bool, animated : Bool){
    
        checkBoxButton.updateSelection(select: currentSelected, animated: animated)
    }
}
