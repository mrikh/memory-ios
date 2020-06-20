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

    enum PageNumber : Int {
        case first
        case second
        case third

        var title : String{
            switch self{
            case .first : return "Want to create some memories?"
            case .second: return "Nothing to do?"
            case .third: return "Had a good time?"
            }
        }

        var subtitle : String{
            switch self{
            case .first: return "Host an event! You can have only your friends join or meet new people, make it public!"
            case .second: return "Why not try something new?"
            case .third: return "Find your photos after the event is over!"
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

    var currentPage : PageNumber = .first{
        didSet{
            setupItems()
        }
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        setupItems()
    }

    //MARK:- Private
    private func setupItems(){

        titleLabel.text = currentPage.title
        infoLabel.text = currentPage.subtitle
        mainImageView.image = currentPage.image
    }
}
