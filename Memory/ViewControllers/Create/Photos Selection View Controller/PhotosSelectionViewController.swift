//
//  PhotosSelectionViewController.swift
//  Memory
//
//  Created by Mayank Rikh on 17/07/19.
//  Copyright © 2019 Mayank Rikh. All rights reserved.
//

import UIKit

class PhotosSelectionViewController: BaseViewController {

    @IBOutlet weak var mainCollectionView: UICollectionView!
    @IBOutlet weak var cardView: UIView!
    @IBOutlet weak var questionLabel: UILabel!

    var create : CreateModel?
    var selectedImages = [String]()

    override func viewDidLoad() {
        super.viewDidLoad()

        initialSetup()
    }

    //MARK:- Private
    private func initialSetup(){

        questionLabel.text = StringConstants.select_venue_photos.localized
        questionLabel.textColor = Colors.bgColor
        questionLabel.font = CustomFonts.avenirHeavy.withSize(18.0)

        mainCollectionView.layer.cornerRadius = 10.0
        cardView.layer.cornerRadius = 10.0
        cardView.addShadow(3.0, opacity: 0.3)
    }
}

extension PhotosSelectionViewController : UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout{

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {

        if indexPath.item == selectedImages.count{
            if selectedImages.isEmpty{
                return CGSize(width : collectionView.bounds.width, height : collectionView.bounds.height - 70.0)
            }else{
                return CGSize(width : collectionView.bounds.width, height : 70.0)
            }
        }else{
            let width = collectionView.bounds.width/3.0
            return CGSize(width : width, height : width)
        }
    }

    func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {

        guard let header = collectionView.dequeueReusableSupplementaryView(ofKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: PhotoHeaderCollectionReusableView.identifier, for: indexPath) as? PhotoHeaderCollectionReusableView else {return UICollectionReusableView(frame: CGRect.zero)}

        return header
    }

    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {

        return selectedImages.count + 1
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {

        if indexPath.item == selectedImages.count{

            guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: ButtonCollectionViewCell.identifier, for: indexPath) as? ButtonCollectionViewCell else { return UICollectionViewCell(frame: CGRect.zero) }

            if selectedImages.isEmpty{

                cell.buttonAction = {

                }

                cell.mainButton.setAttributedTitle(NSAttributedString(string : StringConstants.or_skip.localized, attributes : [.foregroundColor : Colors.bgColor, .font : CustomFonts.avenirHeavy.withSize(15.0), .underlineStyle : NSUnderlineStyle.single.rawValue]), for: .normal)
            }else{

                cell.buttonAction = {

                }

                cell.mainButton.setAttributedTitle(NSAttributedString(string : StringConstants.continue.localized, attributes : [.foregroundColor : Colors.bgColor, .font : CustomFonts.avenirHeavy.withSize(15.0), .underlineStyle : NSUnderlineStyle.single.rawValue]), for: .normal)
            }

            return cell
        }else{
            return UICollectionViewCell()
        }
    }
}
