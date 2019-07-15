//
//  WhenViewController.swift
//  Memory
//
//  Created by Mayank Rikh on 13/07/19.
//  Copyright © 2019 Mayank Rikh. All rights reserved.
//

import UIKit

protocol WhenViewControllerDelegate : AnyObject{

    func userDidCompleteForm()
}

class WhenViewController: BaseViewController, KeyboardHandler {

    @IBOutlet weak var questionLabel: UILabel!
    @IBOutlet weak var scrollViewBottomConstraint: NSLayoutConstraint!
    @IBOutlet weak var cardView: UIView!
    @IBOutlet weak var startDateTextField: MRTextField!
    @IBOutlet weak var endDateTextField: MRTextField!
    @IBOutlet weak var nextButton: UIButton!

    weak var delegate : WhenViewControllerDelegate?
    private var datePicker : MRDatePicker?
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

        guard let start = createModel?.startDate, let end = createModel?.endDate else {
            showAlert(StringConstants.alert.localized, withMessage: StringConstants.select_dates.localized, withCompletion: nil)
            return
        }

        if start == end{
            showAlert(StringConstants.oops.localized, withMessage: StringConstants.not_same.localized, withCompletion: nil)
            return
        }

        if start > end{
            showAlert(StringConstants.oops.localized, withMessage: StringConstants.cannot_end_before.localized, withCompletion: nil)
            return
        }

        delegate?.userDidCompleteForm()
    }

    //MARK:- Private
    private func initialSetup(){

        questionLabel.text = StringConstants.when_party.localized
        questionLabel.textColor = Colors.bgColor
        questionLabel.font = CustomFonts.avenirHeavy.withSize(18.0)

        cardView.layer.cornerRadius = 10.0
        cardView.addShadow(3.0, opacity: 0.3)

        startDateTextField.configure(with: StringConstants.start_time.localized, text: createModel?.startDate?.dateString, primaryColor: Colors.bgColor, unselectedBottomColor: Colors.bgColor.withAlphaComponent(0.25))
        endDateTextField.configure(with: StringConstants.end_time.localized, text: createModel?.endDate?.dateString, primaryColor: Colors.bgColor, unselectedBottomColor: Colors.bgColor.withAlphaComponent(0.25))

        nextButton.layer.cornerRadius = 5.0
        nextButton.addShadow(3.0, opacity: 0.3)

        nextButton.setAttributedTitle(NSAttributedString(string : StringConstants.enter_location.localized, attributes : [.foregroundColor : Colors.bgColor, .font : CustomFonts.avenirHeavy.withSize(15.0), .underlineStyle : NSUnderlineStyle.single.rawValue]), for: .normal)

        cardView.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(handleTap)))

        datePicker = MRDatePicker(mode : .dateAndTime, doneAction: { [weak self] (date) in

            let formatter = DateFormatter()
            formatter.dateFormat = DateFormat.displayDateFormat
            let string = formatter.string(from: date)

            if let responder = self?.startDateTextField.isFirstResponder, responder{
                self?.startDateTextField.text = string
                self?.createModel?.startDate = date.timeIntervalSince1970
                self?.endDateTextField.becomeFirstResponder()
            }else{
                
                self?.endDateTextField.text = string
                self?.createModel?.endDate = date.timeIntervalSince1970
                self?.view.endEditing(true)
            }
        }, cancelAction: { [weak self] in

            self?.view.endEditing(true)
        })

        startDateTextField.inputView = datePicker
        endDateTextField.inputView = datePicker
        startDateTextField.inputAccessoryView = datePicker?.toolbar
        endDateTextField.inputAccessoryView = datePicker?.toolbar
    }

    @objc func handleTap(){
        
        view.endEditing(true)
    }
}
