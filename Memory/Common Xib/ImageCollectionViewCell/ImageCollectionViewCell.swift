//
//  ImageCollectionViewCell.swift
//  Memory
//
//  Created by Mayank Rikh on 18/07/19.
//  Copyright © 2019 Mayank Rikh. All rights reserved.
//

import FontAwesome_swift
import UIKit

class ImageCollectionViewCell: UICollectionViewCell {

    @IBOutlet weak var deleteButton: UIButton!
    @IBOutlet weak var checkBoxButton: MRCheckBoxButton!
    @IBOutlet weak var mainImageView: UIImageView!
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!

    var deleteAction : (()->())?

    override func awakeFromNib() {

        super.awakeFromNib()
        checkBoxButton.tickBackgroundFillColor = Colors.bgColor.withAlphaComponent(0.5)
        checkBoxButton.tickColor = Colors.white
        checkBoxButton.tickWidth = 8.0
        activityIndicator.backgroundColor = Colors.bgColor.withAlphaComponent(0.5)
        deleteButton.isHidden = true

        deleteButton.setImage(UIImage.fontAwesomeIcon(name: FontAwesome.times, style: .solid, textColor: Colors.black, size: CGSize(width: 30.0, height : 30.0)), for: .normal)
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

    //MARK:- IBAction
    @IBAction func deleteAction(_ sender: UIButton) {

        deleteAction?()
    }
}
