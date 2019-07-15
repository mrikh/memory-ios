//
//  WhereViewController.swift
//  Memory
//
//  Created by Mayank Rikh on 13/07/19.
//  Copyright © 2019 Mayank Rikh. All rights reserved.
//

import KMPlaceholderTextView
import UIKit

protocol WhereViewControllerDelegate : AnyObject{

    func userDidCompleteForm()
}

class WhereViewController: BaseViewController, KeyboardHandler {

    @IBOutlet weak var questionLabel: UILabel!
    @IBOutlet weak var cardView: UIView!
    @IBOutlet weak var whereTextField: MRTextField!
    @IBOutlet weak var suggestionsTableView: UITableView!
    @IBOutlet weak var tableHeightConstraint: NSLayoutConstraint!
    @IBOutlet weak var nextButton: UIButton!
    @IBOutlet weak var scrollViewBottomConstraint: NSLayoutConstraint!
    @IBOutlet weak var nearbyTextView: KMPlaceholderTextView!
    
    weak var delegate : WhenViewControllerDelegate?
    var createModel : CreateModel?

    var bottomConstraints: [NSLayoutConstraint]{
        return [scrollViewBottomConstraint]
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        initialSetup()
    }

    override func viewWillAppear(_ animated: Bool) {

        super.viewWillAppear(animated)
        addKeyboardObservers()
    }

    override func viewDidLayoutSubviews() {

        super.viewDidLayoutSubviews()
        //done as in case of iphone x there was extra padding when keyboard comes up and it was annoying me
        extraPadding = view.safeAreaInsets.bottom
    }

    override func viewWillDisappear(_ animated: Bool) {

        removeKeyboardObservers()
        super.viewWillDisappear(animated)
    }

    //MARK:- IBAction
    @IBAction func nextAction(_ sender: UIButton) {

    }

    //MARK:- Private
    private func initialSetup(){

        questionLabel.text = StringConstants.where_event.localized
        questionLabel.textColor = Colors.bgColor
        questionLabel.font = CustomFonts.avenirHeavy.withSize(18.0)


        nearbyTextView.layer.cornerRadius = 8.0
        nearbyTextView.addBorder(withColor: Colors.textFieldBorderColor, andWidth: 1.0)
        nearbyTextView.text = ""
        nearbyTextView.placeholder = StringConstants.nearby_landmarks.localized
        nearbyTextView.textColor = Colors.bgColor
        nearbyTextView.font = CustomFonts.avenirMedium.withSize(14.0)

        cardView.layer.cornerRadius = 10.0
        cardView.addShadow(3.0, opacity: 0.3)

        whereTextField.configure(with: StringConstants.enter_location.localized, text: createModel?.address, primaryColor: Colors.bgColor, unselectedBottomColor: Colors.bgColor.withAlphaComponent(0.25))

        nextButton.layer.cornerRadius = 5.0
        nextButton.addShadow(3.0, opacity: 0.3)

        nextButton.setAttributedTitle(NSAttributedString(string : StringConstants.go_next.localized, attributes : [.foregroundColor : Colors.bgColor, .font : CustomFonts.avenirHeavy.withSize(15.0), .underlineStyle : NSUnderlineStyle.single.rawValue]), for: .normal)

        cardView.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(handleTap)))
    }

    @objc func handleTap(){

        view.endEditing(true)
    }
}

extension WhereViewController : UITableViewDelegate, UITableViewDataSource{

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {

        return 0
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {

        return UITableViewCell()
    }
}
