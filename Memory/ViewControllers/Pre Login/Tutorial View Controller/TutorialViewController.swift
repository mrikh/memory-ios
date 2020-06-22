//
//  TutorialViewController.swift
//  Memory
//
//  Created by Mayank Rikh on 20/06/20.
//  Copyright © 2020 Mayank Rikh. All rights reserved.
//

import UIKit

class TutorialViewController: BaseViewController {

    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var infoLabel: UILabel!
    @IBOutlet weak var mainImageView: UIImageView!

    enum PageNumber : Int, CaseIterable {
        case first
        case second
        case third

        var title : String{
            switch self{
            case .first : return StringConstants.first_title.localized
            case .second: return StringConstants.second_title.localized
            case .third: return StringConstants.third_title.localized
            }
        }

        var subtitle : String{
            switch self{
            case .first: return StringConstants.first_info.localized
            case .second: return StringConstants.second_info.localized
            case .third: return StringConstants.third_info.localized
            }
        }

        var image : UIImage{
            switch self{
            case .first: return #imageLiteral(resourceName: "first-tutorial")
            case .second: return #imageLiteral(resourceName: "second-tutorial")
            case .third: return #imageLiteral(resourceName: "third-tutorial")
            }
        }
    }

    var currentPage : PageNumber = .first

    override func viewDidLoad() {
        super.viewDidLoad()

        setupItems()
    }

    //MARK:- Private
    private func setupItems(){

        titleLabel.font = CustomFonts.avenirHeavy.withSize(18.0)
        titleLabel.textColor = Colors.bgColor

        infoLabel.font = CustomFonts.avenirMedium.withSize(14.0)
        infoLabel.textColor = Colors.bgColor

        titleLabel.text = currentPage.title
        infoLabel.text = currentPage.subtitle
        mainImageView.image = currentPage.image
    }
}
