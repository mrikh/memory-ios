//
//  InviteFriendsViewController.swift
//  Memory
//
//  Created by Mayank Rikh on 19/07/19.
//  Copyright © 2019 Mayank Rikh. All rights reserved.
//

import UIKit

protocol InviteFriendsViewControllerDelegate : AnyObject{

    func didPressNext()
}

class InviteFriendsViewController: BaseViewController, TableViewHeaderFooterResizeProtocol{

    @IBOutlet weak var nextButton: UIButton!
    @IBOutlet weak var mainTableView: UITableView!
    @IBOutlet weak var questionLabel: UILabel!
    @IBOutlet weak var cardView: UIView!

    weak var delegate : InviteFriendsViewControllerDelegate?
    var create : CreateModel?

    override func viewDidLoad() {
        super.viewDidLoad()

        #warning("friends api integration pending")
        initialSetup()
    }

    //MARK:- IBAction
    @IBAction func nextAction(_ sender: UIButton) {

        delegate?.didPressNext()
    }

    //MARK:- Private
    private func initialSetup(){

        emptyDataSetString = StringConstants.no_friends.localized
        isLoading = false
        mainTableView.tableFooterView = UIView()
        emptyDataSourceDelegate(tableView: mainTableView)

        questionLabel.text = StringConstants.select_friends.localized
        questionLabel.textColor = Colors.bgColor
        questionLabel.font = CustomFonts.avenirHeavy.withSize(18.0)

        mainTableView.layer.cornerRadius = 10.0
        cardView.layer.cornerRadius = 10.0
        cardView.addShadow(3.0, opacity: 0.3)

        nextButton.backgroundColor = Colors.bgColor
        nextButton.setAttributedTitle(NSAttributedString(string : StringConstants.or_skip.localized, attributes : [.foregroundColor : Colors.white, .font : CustomFonts.avenirHeavy.withSize(15.0), .underlineStyle : NSUnderlineStyle.single.rawValue]), for: .normal)
    }
}

extension InviteFriendsViewController : UITableViewDelegate, UITableViewDataSource{

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {

        return 0
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {

        return UITableViewCell()
    }
}
