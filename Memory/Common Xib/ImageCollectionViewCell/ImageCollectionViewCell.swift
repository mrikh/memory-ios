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

    @IBOutlet weak var checkBoxContainer: UIView!
    @IBOutlet weak var deleteContainer: UIView!
    @IBOutlet weak var deleteButton: UIButton!
    @IBOutlet weak var checkBoxButton: MRCheckBoxButton!
    @IBOutlet weak var mainImageView: UIImageView!
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!

    var deleteAction : (()->())?

    override func awakeFromNib() {

        super.awakeFromNib()

        checkBoxContainer.backgroundColor = Colors.clear

        checkBoxButton.tickColor = Colors.white
        checkBoxButton.tickWidth = 2.0
        checkBoxButton.tickBackgroundFillColor = Colors.bgColor.withAlphaComponent(0.5)
        checkBoxButton.borderWidth = 0.0
        checkBoxContainer.isHidden = true

        activityIndicator.backgroundColor = Colors.bgColor.withAlphaComponent(0.5)
        deleteContainer.isHidden = true

        deleteContainer.layer.borderColor = Colors.white.cgColor
        deleteContainer.layer.borderWidth = 1.0

        deleteButton.setImage(UIImage.fontAwesomeIcon(name: FontAwesome.times, style: .solid, textColor: Colors.white, size: CGSize(width: 15.0, height : 15.0)), for: .normal)
    }

    override func layoutSubviews() {

        super.layoutSubviews()
        deleteContainer.layer.cornerRadius = deleteContainer.bounds.height/2.0
        checkBoxButton.layer.cornerRadius = checkBoxButton.bounds.height/2.0
    }

    override func prepareForReuse() {

        checkBoxContainer.isHidden = true
        deleteContainer.isHidden = true
        super.prepareForReuse()
    }

    func updateDeleteLoaderCell(image : UIImage, animate : Bool){

        checkBoxContainer.isHidden = true
        updateLoader(animate: animate)
        mainImageView.image = image
        deleteContainer.isHidden = false
    }

    func updateLoader(animate : Bool){
        animate ? activityIndicator.startAnimating() : activityIndicator.stopAnimating()
    }

    func configureSelectionCell(currentSelected : Bool, animated : Bool){

        deleteContainer.isHidden = true
        checkBoxContainer.isHidden = false

        UIView.animate(withDuration: animated ? 0.3 : 0.0) { [weak self] in
            if currentSelected{
                self?.checkBoxContainer.backgroundColor = Colors.systemBlue.withAlphaComponent(0.4)
            }else{
                self?.checkBoxContainer.backgroundColor = Colors.clear
            }
        }

        checkBoxButton.updateSelection(select: currentSelected, animated: animated)
    }

    //MARK:- IBAction
    @IBAction func deleteAction(_ sender: UIButton) {

        deleteAction?()
    }
}
