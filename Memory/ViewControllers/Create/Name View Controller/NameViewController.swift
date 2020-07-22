//
//  NameViewController.swift
//  Memory
//
//  Created by Mayank Rikh on 20/07/19.
//  Copyright © 2019 Mayank Rikh. All rights reserved.
//

import UIKit

protocol NameViewControllerDelegate : AnyObject{

    func userDidComplete()
}

class NameViewController: BaseViewController {

    @IBOutlet weak var nextButton: UIButton!
    @IBOutlet weak var infoLabel: UILabel!
    @IBOutlet weak var bottomConstraint: NSLayoutConstraint!
    @IBOutlet weak var questionLabel: UILabel!
    @IBOutlet weak var characterCountLabel: UILabel!
    @IBOutlet weak var mainTextField: MRTextField!

    var createModel : CreateModel?
    weak var delegate : NameViewControllerDelegate?

    override func viewDidLoad() {
        super.viewDidLoad()

        initialSetup()
    }

    override func viewDidLayoutSubviews() {

        super.viewDidLayoutSubviews()
        nextButton.layer.cornerRadius = nextButton.bounds.height/2.0
    }

    //MARK:- IBAction

    @IBAction func backgroundTapAction(_ sender: UIButton) {

        view.endEditing(true)
    }

    @IBAction func nextAction(_ sender: UIButton) {

        guard let text = mainTextField.text, !text.isEmpty else {

            mainTextField.errorString = StringConstants.name_empty_error.localized
            mainTextField.shakeIfNeeded()
            mainTextField.showErrorMessage(true)
            return
        }

        createModel?.name = text
        delegate?.userDidComplete()
    }

    //MARK:- Private
    private func initialSetup(){

        nextButton.backgroundColor = Colors.bgColor
        nextButton.configureFontAwesome(name: .arrowRight, titleColor: Colors.white, size: 20.0, style: .solid)
        nextButton.addShadow(3.0)

        questionLabel.text = StringConstants.name_question.localized
        questionLabel.textColor = Colors.bgColor
        questionLabel.font = CustomFonts.avenirHeavy.withSize(22.0)

        infoLabel.text = StringConstants.name_info.localized
        infoLabel.textColor = Colors.bgColor
        infoLabel.font = CustomFonts.avenirLight.withSize(14.0)

        mainTextField.configure(with: StringConstants.title.localized, text: createModel?.name, primaryColor: Colors.bgColor, unselectedBottomColor: Colors.bgColor.withAlphaComponent(0.25))

        characterCountLabel.text = "0/\(ValidationConstants.eventNameLimit)"
        characterCountLabel.textColor = Colors.bgColor
        characterCountLabel.font = CustomFonts.avenirMedium.withSize(12.0)
    }
}

extension NameViewController : UITextFieldDelegate{

    func textFieldShouldReturn(_ textField: UITextField) -> Bool {

        view.endEditing(true)
        return false
    }

    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {

        let currentText = textField.text ?? ""
        let replacedText = (currentText as NSString).replacingCharacters(in: range, with: string)

        if replacedText.count > ValidationConstants.eventNameLimit { return false }

        mainTextField.hideErrorMessage(true)
        mainTextField.errorString = nil
        
        createModel?.name = replacedText
        characterCountLabel.text = "\(replacedText.count)/\(ValidationConstants.eventNameLimit)"
        
        return true
    }
}
