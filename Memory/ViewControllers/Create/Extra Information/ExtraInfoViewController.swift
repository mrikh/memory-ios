//
//  ExtraInfoViewController.swift
//  Memory
//
//  Created by Mayank Rikh on 20/07/19.
//  Copyright © 2019 Mayank Rikh. All rights reserved.
//

import KMPlaceholderTextView
import FontAwesome_swift
import UIKit

protocol ExtraInfoViewControllerDelegate : AnyObject{

    func didPressDone()
    func extraPrevious()
}

class ExtraInfoViewController: BaseViewController {

    @IBOutlet weak var nextButton: UIButton!
    @IBOutlet weak var previousButton: UIButton!
    @IBOutlet weak var privacySegmentControl: UISegmentedControl!
    @IBOutlet weak var privacyHintLabel: UILabel!
    @IBOutlet weak var privacyQuestionLabel: UILabel!
    @IBOutlet weak var characterCountLabel: UILabel!
    @IBOutlet weak var extraHintLabel: UILabel!
    @IBOutlet weak var extraTitleLabel: UILabel!
    @IBOutlet weak var scrollView: UIScrollView!
    @IBOutlet weak var additionalTextView: KMPlaceholderTextView!

    weak var delegate : ExtraInfoViewControllerDelegate?
    var createModel : CreateModel?

    override func viewDidLoad() {
        super.viewDidLoad()

        initialSetup()
    }

    override func viewDidLayoutSubviews() {

        super.viewDidLayoutSubviews()

        nextButton.layer.cornerRadius = nextButton.bounds.height/2.0
        previousButton.layer.cornerRadius = previousButton.bounds.height/2.0
    }

    //MARK:- IBAction
    @IBAction func previousAction(_ sender: UIButton) {

        delegate?.extraPrevious()
    }

    @IBAction func doneAction(_ sender: UIButton) {

        createModel?.privacy = privacySegmentControl.selectedSegmentIndex == 0 ? .selectedFriends : .anyone
        createModel?.otherDetails = additionalTextView.text

        delegate?.didPressDone()
    }

    //MARK:- Private
    private func initialSetup(){

        previousButton.configureArrowButton(name: .arrowLeft)
        nextButton.configureArrowButton(name: .arrowRight)

        extraTitleLabel.text = StringConstants.extra_title.localized
        extraTitleLabel.textColor = Colors.bgColor
        extraTitleLabel.font = CustomFonts.avenirHeavy.withSize(22.0)

        privacyQuestionLabel.text = StringConstants.privacy_title.localized
        privacyQuestionLabel.textColor = Colors.bgColor
        privacyQuestionLabel.font = CustomFonts.avenirHeavy.withSize(22.0)

        extraHintLabel.text = StringConstants.extra_hint.localized
        extraHintLabel.textColor = Colors.bgColor
        extraHintLabel.font = CustomFonts.avenirLight.withSize(14.0)

        privacyHintLabel.text = StringConstants.privacy_hint.localized
        privacyHintLabel.textColor = Colors.bgColor
        privacyHintLabel.font = CustomFonts.avenirLight.withSize(14.0)

        characterCountLabel.text = "0/\(ValidationConstants.additionalInfoTextLimit)"
        characterCountLabel.textColor = Colors.bgColor
        characterCountLabel.font = CustomFonts.avenirLight.withSize(12.0)

        additionalTextView.text = nil
        additionalTextView.placeholder = StringConstants.enter_desc.localized
        additionalTextView.textColor = Colors.bgColor
        additionalTextView.font = CustomFonts.avenirLight.withSize(13.0)
        additionalTextView.addShadow(3.0)

        privacySegmentControl.setTitle(CreateModel.Privacy.selectedFriends.displayString, forSegmentAt: 0)
        privacySegmentControl.setTitleTextAttributes([.foregroundColor : Colors.bgColor, .font : CustomFonts.avenirMedium.withSize(13.0)], for: .normal)
        privacySegmentControl.setTitleTextAttributes([.foregroundColor : Colors.bgColor, .font : CustomFonts.avenirMedium.withSize(13.0)], for: .selected)

        privacySegmentControl.setTitle(CreateModel.Privacy.anyone.displayString, forSegmentAt: 1)

        if let privacy = createModel?.privacy, privacy == .anyone{
            privacySegmentControl.selectedSegmentIndex = 1
        }else{
            privacySegmentControl.selectedSegmentIndex = 0
        }

        view.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(handleTap)))
    }

    @objc func handleTap(){

        view.endEditing(true)
    }
}

extension ExtraInfoViewController : UITextViewDelegate{

    
    func textView(_ textView: UITextView, shouldChangeTextIn range: NSRange, replacementText text: String) -> Bool {

        if text.count + textView.text.count > ValidationConstants.additionalInfoTextLimit { return false }

        return true
    }

    func textViewDidChange(_ textView: UITextView) {

        createModel?.otherDetails = textView.text
        characterCountLabel.text = "\(textView.text.count)/\(ValidationConstants.additionalInfoTextLimit)"
    }
}
