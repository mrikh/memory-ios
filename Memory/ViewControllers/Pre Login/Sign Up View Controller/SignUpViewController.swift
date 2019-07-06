//
//  SignUpViewController.swift
//  Memory
//
//  Created by Mayank Rikh on 17/03/19.
//  Copyright © 2019 Mayank Rikh. All rights reserved.
//

import UIKit

class SignUpViewController: BaseViewController, KeyboardHandler, TableViewHeaderFooterResizeProtocol{

    @IBOutlet weak var loginButton: UIButton!
    @IBOutlet weak var mainTableView: UITableView!
    @IBOutlet weak var tableViewBottomConstraint: NSLayoutConstraint!
    @IBOutlet weak var loginLabel: UILabel!
    @IBOutlet weak var signUpButton: MRAnimatingButton!

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

    override func viewDidLayoutSubviews() {

        super.viewDidLayoutSubviews()
        if let view = mainTableView.tableFooterView, let resized = resizeView(view){
            mainTableView.tableFooterView = resized
        }
    }

    override func viewWillDisappear(_ animated: Bool) {

        removeKeyboardObservers()
        super.viewWillDisappear(animated)
    }

    //MARK:- IBAction
    @IBAction func loginAction(_ sender: UIButton) {

        let viewController = WelcomeViewController.instantiate(fromAppStoryboard: .PreLogin)
        navigationController?.setViewControllers([viewController], animated: true)
    }

    @IBAction func signUpAction(_ sender: MRAnimatingButton) {

        sender.startAnimating()
        viewModel.startSubmit()
    }

    //MARK:- Private
    private func initialSetup(){

        navigationItem.title = StringConstants.sign_up.localized

        mainTableView.estimatedRowHeight = 80.0
        mainTableView.rowHeight = UITableView.automaticDimension

        mainTableView.register(TextFieldTableViewCell.nib, forCellReuseIdentifier: TextFieldTableViewCell.identifier)
        mainTableView.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(handleTap)))

        loginLabel.textColor = Colors.black
        loginLabel.font = CustomFonts.avenirMedium.withSize(12.0)
        loginLabel.text = StringConstants.already_account.localized

        loginButton.setAttributedTitle(NSAttributedString(string : StringConstants.login.localized, attributes : [.font : CustomFonts.avenirHeavy.withSize(12.0), .foregroundColor : Colors.bgColor, .underlineStyle : NSUnderlineStyle.single.rawValue]), for: .normal)

        signUpButton.setTitle(StringConstants.sign_up.localized, for: .normal)
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
        cell.didPressReturn = { [weak self] (viewModel) in
            self?.selectTextField(after : viewModel)
        }

        cell.didEndEditing = { [weak self] (viewModel) in
            self?.viewModel.validate(viewModel)
        }

        return cell
    }

    private func selectTextField(after viewModel: TextFieldCellViewModel?){

        guard let model = viewModel else {return}

        if let position = self.viewModel.selectPosition(after: model), let cell = mainTableView.cellForRow(at: [0, position]) as? TextFieldTableViewCell{
            cell.mainTextField.becomeFirstResponder()
        }else{
            view.endEditing(true)
        }
    }
}

extension SignUpViewController : SignUpViewModelDelegate{

    func responseReceived() {
        signUpButton.stopAnimating()
    }

    func reloadTable() {
        mainTableView.reloadData()
    }

    func success(){

        let viewController = ProfilePhotoViewController.instantiate(fromAppStoryboard: .PreLogin)
        navigationController?.setViewControllers([viewController], animated: true)
    }
}
