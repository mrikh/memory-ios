//
//  SignUpViewController.swift
//  Memory
//
//  Created by Mayank Rikh on 17/03/19.
//  Copyright © 2019 Mayank Rikh. All rights reserved.
//

import UIKit

class SignUpViewController: BaseViewController, KeyboardHandler{

    @IBOutlet weak var mainTableView: UITableView!
    @IBOutlet weak var tableViewBottomConstraint: NSLayoutConstraint!

    var bottomConstraints: [NSLayoutConstraint]{
        return [tableViewBottomConstraint]
    }

    private var viewModel = SignUpViewModel()

    override func viewDidLoad() {
        super.viewDidLoad()

        initialSetup()
    }

    override func viewWillAppear(_ animated: Bool) {

        super.viewWillAppear(animated)
        addKeyboardObservers()
        navigationController?.setNavigationBarHidden(false, animated: true)
    }

    override func viewWillDisappear(_ animated: Bool) {

        removeKeyboardObservers()
        super.viewWillAppear(animated)
    }

    //MARK:- IBAction
    @IBAction func loginAction(_ sender: UIButton) {

        let viewController = WelcomeViewController.instantiate(fromAppStoryboard: .PreLogin)
        navigationController?.setViewControllers([viewController], animated: true)
    }

    //MARK:- Private
    private func initialSetup(){

        navigationItem.title = StringConstants.sign_up.localized

        mainTableView.estimatedRowHeight = 80.0
        mainTableView.rowHeight = UITableView.automaticDimension

        mainTableView.register(TextFieldTableViewCell.nib, forCellReuseIdentifier: TextFieldTableViewCell.identifier)
        
//        nameTextField.configure(with: StringConstants.name.localized, primaryColor: Colors.bgColor, unselectedBottomColor: Colors.bgColor.withAlphaComponent(0.25))
//        emailTextField.configure(with: StringConstants.email.localized, primaryColor: Colors.bgColor, unselectedBottomColor: Colors.bgColor.withAlphaComponent(0.25))
//        passwordTextField.configure(with: StringConstants.password.localized, primaryColor: Colors.bgColor, unselectedBottomColor: Colors.bgColor.withAlphaComponent(0.25))
//        userNameTextField.configure(with: StringConstants.username.localized, primaryColor: Colors.bgColor, unselectedBottomColor: Colors.bgColor.withAlphaComponent(0.25))
//
//        loginLabel.textColor = Colors.black
//        loginLabel.font = CustomFonts.avenirMedium.withSize(12.0)
//        loginLabel.text = StringConstants.already_account.localized
//
//        loginButton.setAttributedTitle(NSAttributedString(string : StringConstants.login.localized, attributes : [.font : CustomFonts.avenirHeavy.withSize(12.0), .foregroundColor : Colors.bgColor, .underlineStyle : NSUnderlineStyle.single.rawValue]), for: .normal)

        mainTableView.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(handleTap)))
    }

    @objc private func handleTap(){
        view.endEditing(true)
    }
}

extension SignUpViewController : UITableViewDelegate, UITableViewDataSource{

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {

        return viewModel.numberOfRows
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {

        guard let cell = tableView.dequeueReusableCell(withIdentifier: TextFieldTableViewCell.identifier) as? TextFieldTableViewCell else {return UITableViewCell()}

        cell.configure(viewModel: viewModel.viewModel(at: indexPath.row))
        return cell
    }
}
