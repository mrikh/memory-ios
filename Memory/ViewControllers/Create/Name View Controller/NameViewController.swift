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

    @IBOutlet weak var bottomConstraint: NSLayoutConstraint!
    @IBOutlet weak var questionLabel: UILabel!
    @IBOutlet weak var cardView: UIView!
    @IBOutlet weak var mainTextField: MRTextField!
    @IBOutlet weak var nextButton: UIButton!

    var createModel : CreateModel?
    weak var delegate : NameViewControllerDelegate?

    override func viewDidLoad() {
        super.viewDidLoad()

        initialSetup()
    }
    

    //MARK:- IBAction
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

        questionLabel.text = StringConstants.name_question.localized
        questionLabel.textColor = Colors.bgColor
        questionLabel.font = CustomFonts.avenirHeavy.withSize(18.0)

        cardView.layer.cornerRadius = 10.0
        cardView.addShadow(3.0, opacity: 0.3)

        mainTextField.configure(with: StringConstants.enter_name.localized, text: createModel?.name, primaryColor: Colors.bgColor, unselectedBottomColor: Colors.bgColor.withAlphaComponent(0.25))

        nextButton.layer.cornerRadius = 5.0
        nextButton.addShadow(3.0, opacity: 0.3)

        nextButton.setAttributedTitle(NSAttributedString(string : StringConstants.go_next.localized, attributes : [.foregroundColor : Colors.bgColor, .font : CustomFonts.avenirHeavy.withSize(15.0), .underlineStyle : NSUnderlineStyle.single.rawValue]), for: .normal)
    }
}

extension NameViewController : UITextFieldDelegate{

    func textFieldShouldReturn(_ textField: UITextField) -> Bool {

        view.endEditing(true)
        return false
    }

    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {

        mainTextField.hideErrorMessage(true)
        mainTextField.errorString = nil
        
        return true
    }
}
