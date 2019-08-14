//
//  ExtraInfoViewController.swift
//  Memory
//
//  Created by Mayank Rikh on 20/07/19.
//  Copyright © 2019 Mayank Rikh. All rights reserved.
//

import KMPlaceholderTextView
import FontAwesome_swift
import MRRadioButton
import UIKit

protocol ExtraInfoViewControllerDelegate : AnyObject{

    func didPressDone()
}

class ExtraInfoViewController: BaseViewController, KeyboardHandler {

    @IBOutlet weak var doneButton: UIButton!
    @IBOutlet weak var bottomConstraint: NSLayoutConstraint!
    @IBOutlet weak var scrollView: UIScrollView!
    @IBOutlet weak var cardView: UIView!
    @IBOutlet weak var optionQuestionLabel: UILabel!
    @IBOutlet weak var privateRadioButton: MRRadioButton!
    @IBOutlet weak var privateLabel: UILabel!
    @IBOutlet weak var publicRadioButton: MRRadioButton!
    @IBOutlet weak var publicLabel: UILabel!
    @IBOutlet weak var additionalInfoLabel: UILabel!
    @IBOutlet weak var additionalTextView: KMPlaceholderTextView!

    var bottomConstraints: [NSLayoutConstraint]{
        return [bottomConstraint]
    }

    weak var delegate : ExtraInfoViewControllerDelegate?
    var createModel : CreateModel?

    override func viewDidLoad() {
        super.viewDidLoad()

        initialSetup()
    }

    override func viewWillAppear(_ animated: Bool) {

        super.viewWillAppear(animated)
        addKeyboardObservers()
    }

    override func viewWillDisappear(_ animated: Bool) {

        super.viewWillDisappear(animated)
        removeKeyboardObservers()
    }

    //MARK:- IBAction
    @IBAction func doneAction(_ sender: UIButton) {

        createModel?.privacy = privateRadioButton.currentlySelected ? .selectedFriends : .anyone
        createModel?.otherDetails = additionalTextView.text

        delegate?.didPressDone()
    }

    @IBAction func privateRadioAction(_ sender: MRRadioButton) {

        publicRadioButton.updateSelection(select: false, animated : true)
        privateRadioButton.updateSelection(select: true, animated : true)
    }

    @IBAction func publicRadioAction(_ sender: MRRadioButton) {

        privateRadioButton.updateSelection(select: false, animated : true)
        publicRadioButton.updateSelection(select: true, animated : true)
    }

    //MARK:- Private
    private func initialSetup(){

        doneButton.backgroundColor = Colors.bgColor
        doneButton.setAttributedTitle(NSAttributedString(string : StringConstants.continue.localized, attributes : [.foregroundColor : Colors.white, .font : CustomFonts.avenirHeavy.withSize(15.0), .underlineStyle : NSUnderlineStyle.single.rawValue]), for: .normal)

        optionQuestionLabel.text = StringConstants.anyone_join.localized
        optionQuestionLabel.textColor = Colors.bgColor
        optionQuestionLabel.font = CustomFonts.avenirHeavy.withSize(18.0)

        privateLabel.text = StringConstants.selected_friends.localized
        privateLabel.textColor = Colors.bgColor
        privateLabel.font = CustomFonts.avenirMedium.withSize(13.0)

        publicLabel.text = StringConstants.anyone.localized
        publicLabel.textColor = Colors.bgColor
        publicLabel.font = CustomFonts.avenirMedium.withSize(13.0)

        scrollView.layer.cornerRadius = 10.0
        scrollView.clipsToBounds = true
        cardView.layer.cornerRadius = 10.0
        cardView.addShadow(3.0, opacity: 0.3)

        if let privacy = createModel?.privacy, privacy == .anyone{
            privateRadioButton.updateSelection(select: false, animated : false)
            publicRadioButton.updateSelection(select: true, animated : false)
        }else{
            privateRadioButton.updateSelection(select: true, animated : false)
            publicRadioButton.updateSelection(select: false, animated : false)
        }

        additionalInfoLabel.text = StringConstants.anything_else_add.localized
        additionalInfoLabel.textColor = Colors.bgColor
        additionalInfoLabel.font = CustomFonts.avenirHeavy.withSize(18.0)

        additionalTextView.text = nil
        additionalTextView.placeholder = StringConstants.write_here.localized
        additionalTextView.textColor = Colors.bgColor
        additionalTextView.font = CustomFonts.avenirMedium.withSize(13.0)

        cardView.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(handleTap)))
    }

    @objc func handleTap(){

        view.endEditing(true)
    }
}
