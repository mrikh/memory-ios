//
//  MRSkyTextField.swift
//  Jhaiho
//
//  Created by Mayank on 11/10/18.
//  Copyright © 2018 Jhaiho. All rights reserved.
//

import UIKit

protocol MRTextFieldDelegate : class{

    func userDidTapRightButton(_ sender : UIButton)
}

class MRTextField: UITextField {

    //to store in case of you start animating the button
    private var currentRightView : UIView?
    private var errorLabel : UILabel?
    private var floatingLabel : UILabel?
    private var floatingLabelBottomConstraint : NSLayoutConstraint?
    private var floatingLabelTopConstraint : NSLayoutConstraint?

    private enum LayerIdentifier : Int{

        case bottomBorder = 1001
    }

    @IBInspectable var shouldAllowSelectorAction : Bool = true


    /// bottom border to set when user inputs text
    @IBInspectable var bottomBorderColor : UIColor = UIColor.clear{
        didSet{
            if let currentValue = floatingLabelTopConstraint?.constant, currentValue != 0.0{
                updateBorderColor(bottomBorderColor)
            }else{
                updateBorderColor(defaultBottomBorderColor)
            }
        }
    }

    override var font: UIFont?{
        didSet{
            floatingLabel?.font = font
        }
    }

    override var text: String?{
        didSet{
            textFieldDidChange(self)
        }
    }

    /// Default bottom border color in case of no text
    @IBInspectable var defaultBottomBorderColor : UIColor  = #colorLiteral(red: 0.8209885955, green: 0.821634829, blue: 0.8407682776, alpha: 1){
        didSet{
            if let currentValue = floatingLabelTopConstraint?.constant, currentValue != 0.0{
                updateBorderColor(bottomBorderColor)
            }else{
                updateBorderColor(defaultBottomBorderColor)
            }
        }
    }

    /// Floating label color when user typing something
    @IBInspectable var floatingLabelColor : UIColor = #colorLiteral(red: 0.8209885955, green: 0.821634829, blue: 0.8407682776, alpha: 1){
        didSet{
            if let currentValue = floatingLabelTopConstraint?.constant, currentValue == 0.0{
                floatingLabel?.textColor = #colorLiteral(red: 0.8209885955, green: 0.821634829, blue: 0.8407682776, alpha: 1)
            }else{
                floatingLabel?.textColor = floatingLabelColor
            }
        }
    }

    @IBInspectable var showFloatingLabel : Bool = true

    @IBInspectable var leftImage : UIImage? = nil{
        didSet{
            if let tempImage = leftImage{
                createLeftImageView(tempImage)
            }
        }
    }

    override var placeholder: String?{
        didSet{
            floatingLabel?.text = placeholder
            super.placeholder = nil
        }
    }

    @IBInspectable var rightImage : UIImage? = nil{
        didSet{
            self.createRightImageView(rightImage)
        }
    }

    weak var customDelegate : MRTextFieldDelegate?

    var regexString : String? = nil

    var errorString : String? = nil{
        didSet{
            errorLabel?.text = errorString
        }
    }

    var errorFont : UIFont? = nil{
        didSet{
            if let tempFont = errorFont{
                errorLabel?.font = tempFont
            }
        }
    }

    override func awakeFromNib() {

        super.awakeFromNib()
        borderStyle = .none
        clipsToBounds = false
        setupBottomBorder()
        createErrorMessageLabel()
        setupFloatingLabel()
        autocapitalizationType = .words

        addTarget(self, action: #selector(textFieldDidChange(_:)), for: .editingChanged)
    }

    override func layoutSubviews() {

        super.layoutSubviews()

        if let tempLayer = getLayerForIdentifier(LayerIdentifier.bottomBorder.rawValue){

            tempLayer.frame = CGRect(x: 0, y: frame.height - 1, width: frame.width, height: 1)
        }
    }

    override func canPerformAction(_ action: Selector, withSender sender: Any?) -> Bool {
        if shouldAllowSelectorAction {
            return super.canPerformAction(action, withSender: sender)
        }
        return false
    }

    //MARK: Error message in case of validation
    func configure(with placeholder : String?){

        defaultBottomBorderColor = Colors.inactiveButtonTitleColor
        bottomBorderColor = Colors.activeButtonTitleColor
        floatingLabelColor = Colors.activeButtonTitleColor

        textColor = Colors.activeButtonTitleColor
        font = CustomFonts.avenirMedium.withSize(16.0)
        self.font = CustomFonts.avenirMedium.withSize(16.0)
        errorFont = CustomFonts.avenirMedium.withSize(16.0)
        floatingLabel?.text = placeholder
    }

    func showErrorMessage(_ animate : Bool = true){

        if let tempLayer = getLayerForIdentifier(LayerIdentifier.bottomBorder.rawValue){
            tempLayer.backgroundColor = UIColor.red.cgColor
        }

        errorLabel?.text = errorString
        if let tempFont = errorFont{
            errorLabel?.font = tempFont
        }

        animateErrorLabel(1.0, animate : animate)
    }

    func hideErrorMessage(_ animate : Bool = true){

        if let _ = getLayerForIdentifier(LayerIdentifier.bottomBorder.rawValue){
            if let currentValue = floatingLabelTopConstraint?.constant, currentValue != 0.0{
                updateBorderColor(bottomBorderColor)
            }else{
                updateBorderColor(defaultBottomBorderColor)
            }
        }
        animateErrorLabel(0.0, animate: animate)
    }

    func shake() {
        let animation = CAKeyframeAnimation(keyPath: "transform.translation.x")
        animation.timingFunction = CAMediaTimingFunction(name: CAMediaTimingFunctionName.linear)
        animation.duration = 0.4
        animation.values = [-10.0, 10.0, -10.0, 10.0, -5.0, 5.0, -2.0, 2.0, 0.0 ]
        layer.add(animation, forKey: "shake")
    }

    //MARK: Activity indicator on right side
    func startAnimating(){

        let activityIndicator = UIActivityIndicatorView()
        //hit and trial value
        activityIndicator.center.x = activityIndicator.center.x + 10.0
        activityIndicator.center.y = activityIndicator.center.y + 10.0
        activityIndicator.style = .gray
        activityIndicator.startAnimating()
        activityIndicator.hidesWhenStopped = true

        currentRightView = self.rightView

        self.rightView = createView(withView: activityIndicator)
    }

    func stopAnimating(){

        if self.rightView is UIActivityIndicatorView{

            let tempView = self.rightView as! UIActivityIndicatorView
            tempView.stopAnimating()
        }

        self.rightView = currentRightView
    }

    //MARK:- Private Functions
    @objc func textFieldDidChange(_ textField : UITextField){

        guard let text = textField.text else {return}

        if showFloatingLabel{

            if text.isEmpty{
                animateFloatingLabel(false)
            }else{
                animateFloatingLabel(true)
            }
        }

        checkForErrorString()
    }

    func animateFloatingLabel(_ upDirection : Bool, animate : Bool = true){

        guard let fontHeight = font?.lineHeight else {
            let alpha : CGFloat = upDirection ? 0.0 : 1.0
            UIView.animate(withDuration: animate ? 0.3 : 0.0, animations: {
                self.alpha = alpha
            })

            return
        }

        if upDirection{

            if let currentValue = floatingLabelTopConstraint?.constant, currentValue == 0.0{

                floatingLabelTopConstraint?.constant = -fontHeight - 5.0
                floatingLabelBottomConstraint?.constant = -fontHeight - 5.0

                UIView.animate(withDuration: animate ? 0.2 : 0.0, animations: {
                    self.layoutIfNeeded()
                })

                UIView.transition(with: self, duration: animate ? 0.15 : 0.0, options: .transitionCrossDissolve, animations: {
                    self.floatingLabel?.textColor = self.floatingLabelColor
                    self.floatingLabel?.font = CustomFonts.avenirMedium.withSize(11.0)
                    self.updateBorderColor(self.bottomBorderColor)
                }, completion: nil)
            }
        }else{

            if let currentValue = floatingLabelTopConstraint?.constant, currentValue != 0.0{

                floatingLabelTopConstraint?.constant = 0.0
                floatingLabelBottomConstraint?.constant = 0.0

                UIView.animate(withDuration: animate ? 0.2 : 0.0, animations: {
                    self.layoutIfNeeded()
                })

                UIView.transition(with: self, duration: animate ? 0.15 : 0.0, options: .transitionCrossDissolve, animations: {
                    self.floatingLabel?.font = self.font ?? UIFont.systemFont(ofSize: 14.0)
                    self.floatingLabel?.textColor = #colorLiteral(red: 0.8209885955, green: 0.821634829, blue: 0.8407682776, alpha: 1)
                    self.updateBorderColor(self.defaultBottomBorderColor)
                }, completion: nil)
            }
        }
    }

    private func checkForErrorString(){

        guard let regexStr = regexString, let userText = text else {return}
        let passwordTest = NSPredicate(format: "SELF MATCHES %@", regexStr)

        if passwordTest.evaluate(with: userText){

            if errorLabel?.alpha == CGFloat(1.0){
                hideErrorMessage()
            }
        }else{
            //show that we dont show multiple times
            if errorLabel?.alpha == CGFloat(0.0){
                showErrorMessage()
            }
        }
    }

    @objc func buttonAction(_ sender : UIButton){

        customDelegate?.userDidTapRightButton(sender)
    }

    private func animateErrorLabel(_ alpha : CGFloat, animate : Bool){

        UIView.animate(withDuration: animate ? 0.25 : 0.0) {

            self.errorLabel?.alpha = alpha
        }
    }

    private func updateBorderColor(_ color : UIColor){

        if let tempLayer = getLayerForIdentifier(LayerIdentifier.bottomBorder.rawValue){
            tempLayer.backgroundColor = color.cgColor
        }
    }

    private func getLayerForIdentifier(_ identifier : Int) -> CALayer?{

        if let tempSublayers = layer.sublayers{
            for sublayer in tempSublayers{
                if let value = sublayer.value(forUndefinedKey: "layerIdentifier") as? Int, value == identifier{
                    return sublayer
                }
            }
        }

        return nil
    }
}



//MARK:- Setup related part
extension MRTextField{

    //MARK: Setup button to perform some action like password etc on tap the action is passed in the delegate

    func setupButton(buttonIcon : UIImage?, andSelectedImage selectedImage : UIImage?, withText text: String?, withSelectedText selectedText : String?){

        let button = UIButton(frame: CGRect(x: 0, y: -1, width: 20, height: 20))

        button.setTitle(text, for: .normal)
        button.setTitle(selectedText, for: .selected)

        button.setImage(buttonIcon, for: .normal)
        button.setImage(selectedImage, for: .selected)

        button.addTarget(self, action: #selector(buttonAction(_:)), for: .touchUpInside)
        button.tag = self.tag

        rightViewMode = .always
        rightView = createView(withView: button)
    }

    fileprivate func setupFloatingLabel(){

        floatingLabel = UILabel()
        floatingLabel?.text = placeholder
        placeholder = nil
        floatingLabel?.textColor = #colorLiteral(red: 0.8209885955, green: 0.821634829, blue: 0.8407682776, alpha: 1)
        floatingLabel?.numberOfLines = 1
        floatingLabel?.font = self.font
        floatingLabel?.alpha = 1.0

        addSubview(floatingLabel!)
        createConstraintsForFloatingLabel(floatingLabel!)
    }

    fileprivate func createErrorMessageLabel(){

        errorLabel = UILabel()

        errorLabel?.numberOfLines = 1
        errorLabel?.textColor = Colors.red
        errorLabel?.font = CustomFonts.avenirMedium.withSize(10)
        errorLabel?.alpha = 0.0

        addSubview(errorLabel!)
        createConstraintsForLabel(errorLabel!)
    }

    fileprivate func createLeftImageView(_ image : UIImage){

        let imageView = UIImageView(frame: CGRect(x: 0, y: 0, width: 20, height: 20))
        imageView.contentMode = .scaleAspectFill
        imageView.image = image
        self.leftViewMode = .always
        self.leftView = createView(withView: imageView)
    }

    fileprivate func createRightImageView(_ image : UIImage?){

        let imageView = UIImageView(frame: CGRect(x: 0, y: 0, width: 20, height: 20))
        imageView.image = image
        imageView.contentMode = .scaleAspectFill
        self.rightViewMode = .always
        self.rightView = createView(withView: imageView)
    }

    private func createView(withView view : UIView)->UIView{

        let tempView = UIView(frame: CGRect(x: 0, y: 0, width: 30, height: 20))
        tempView.addSubview(view)
        return tempView
    }

    private func setupBottomBorder(){

        let bottomLayer = CALayer()

        bottomLayer.backgroundColor = defaultBottomBorderColor.cgColor
        bottomLayer.frame = CGRect(x: 0, y: frame.height - 1, width: frame.width, height: 1)
        bottomLayer.setValue(LayerIdentifier.bottomBorder.rawValue, forKey: "layerIdentifier")
        layer.addSublayer(bottomLayer)
    }


    private func createConstraintsForLabel(_ label : UILabel){

        let dictionary = ["label" : label]
        label.translatesAutoresizingMaskIntoConstraints = false

        var customConstraints = [NSLayoutConstraint]()
        customConstraints.append(contentsOf: NSLayoutConstraint.constraints(withVisualFormat: "H:|[label]|", options: .init(rawValue: 0), metrics: nil, views: dictionary))
        customConstraints.append(NSLayoutConstraint(item: label, attribute: .top, relatedBy: .equal, toItem: self, attribute: .bottom, multiplier: 1, constant: 5.0))
        addConstraints(customConstraints)
    }

    private func createConstraintsForFloatingLabel(_ label : UILabel){

        let dictionary = ["label" : label]
        label.translatesAutoresizingMaskIntoConstraints = false

        var customConstraints = [NSLayoutConstraint]()
        customConstraints.append(contentsOf: NSLayoutConstraint.constraints(withVisualFormat: "H:|[label]|", options: .init(rawValue: 0), metrics: nil, views: dictionary))

        floatingLabelTopConstraint = NSLayoutConstraint(item: label, attribute: .top, relatedBy: .equal, toItem: self, attribute: .top, multiplier: 1, constant: 0.0)
        customConstraints.append(floatingLabelTopConstraint!)
        floatingLabelBottomConstraint = NSLayoutConstraint(item: label, attribute: .bottom, relatedBy: .equal, toItem: self, attribute: .bottom, multiplier: 1, constant: 0.0)
        customConstraints.append(floatingLabelBottomConstraint!)

        addConstraints(customConstraints)
    }
}
