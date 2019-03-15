//
//  MRAnimatingButton.swift
//  MRAnimatingButton
//
//  Created by Mayank Rikh on 17/09/17.
//  Copyright © 2017 Mayank Rikh. All rights reserved.
//

import UIKit

/// This doesn't support selected states of buttons. Change button type to custom from default please.
class MRAnimatingButton: UIButton {
    
    /// Button color for the enabled state
    @IBInspectable var enabledButtonColor : UIColor = Colors.bgColor{
        didSet{
            backgroundColor = enabledButtonColor
        }
    }
    
    /// Button color for the disabled state
    @IBInspectable var disabledButtonColor : UIColor = Colors.inactiveButtonColor{
        didSet{
            backgroundColor = disabledButtonColor
        }
    }
    
    /// Title color for the enabled state
    @IBInspectable var enabledTitleColor : UIColor = UIColor.white{
        didSet{
            setTitleColor(enabledTitleColor, for: .normal)
        }
    }
    
    /// Title color for the disabled state
    @IBInspectable var disabledTitleColor : UIColor = UIColor.white{
        didSet{
            setTitleColor(disabledTitleColor, for: .normal)
        }
    }

    var isAnimating = false
    
    //Private variables
    private var animationDuration : Double = 0.15
    private var initialCornerRadius : CGFloat = 0.0
    private var originalWidth : CGFloat = 0.0
    private var titleText : String?
    
    //Private constants
    private let cornerRadiusKey = "cornerRadius"
    private let widthKey = "bounds.size.width"
    private let strokeStart = "strokeStart"
    private let strokeEnd = "strokeEnd"
    private let layerIdentifier = "layerIdentifier"
    private let firstLayer = 1005
    
    override func awakeFromNib() {
        
        super.awakeFromNib()
        
        drawCompleteCircle(firstLayer)
        
        enabledButtonColor = Colors.bgColor
        disabledButtonColor = UIColor.white
        
        enabledTitleColor = UIColor.white
        disabledTitleColor = Colors.inactiveButtonColor
        
        titleLabel?.font = CustomFonts.avenirMedium.withSize(15.0)
        
        disableButton()
    }
    
    override func layoutSubviews() {
        
        super.layoutSubviews()
        if let tempLayer = searchForLayer(firstLayer){
            tempLayer.path = UIBezierPath(roundedRect: CGRect(x: 5, y: 5, width: frame.size.height - 10, height: frame.size.height - 10), cornerRadius: frame.size.height/2.0).cgPath
        }
        
        layer.cornerRadius = bounds.height/2.0
    }
    
    func startAnimating(){
        
        isUserInteractionEnabled = false
        originalWidth = bounds.width
        initialCornerRadius = layer.cornerRadius
        titleText = title(for: .normal)
        isAnimating = true
        
        UIView.transition(with: self, duration: 0.05, options: .transitionCrossDissolve, animations: {
            self.setTitle(nil, for: .normal)
        }, completion: { [weak self] (finished) in
            self?.executeAnimation(true) { [weak self] in
                self?.circleGroupedAnimation({
                    
                })
            }
        })
    }
    
    func stopAnimating(){
        
        DispatchQueue.main.asyncAfter(wallDeadline: .now() + 0.3) { [weak self] in
            self?.searchForLayer(self?.firstLayer)?.removeAllAnimations()
            self?.executeAnimation(false) { [weak self] in
                if let tempSelf = self{
                    UIView.transition(with: tempSelf, duration: 0.05, options: .transitionCrossDissolve, animations: {

                        tempSelf.setTitle(tempSelf.titleText, for: .normal)
                    }, completion: nil)
                    self?.isUserInteractionEnabled = true
                    self?.isAnimating = false
                }
            }
        }
    }
    
    //MARK:- State Change Methods
    
    func enableButton(){
        
        updateButton(false, backgroundColor: Colors.bgColor, titleColor: UIColor.white)
    }
    
    func disableButton(){
        
        updateButton(true, backgroundColor: Colors.inactiveButtonColor, titleColor: UIColor.white)
    }
    
    private func updateButton(_ isDisabled : Bool, backgroundColor : UIColor, titleColor : UIColor){
        
        self.isUserInteractionEnabled = !isDisabled
        self.backgroundColor = backgroundColor
        self.setTitleColor(titleColor, for: .normal)
    }
    
    //MARK:- Animation
    private func animateKey(_ key : String, from : CGFloat, to : CGFloat) -> CAAnimation{
        
        let animation = CABasicAnimation(keyPath: key)
        animation.timingFunction = CAMediaTimingFunction(name: CAMediaTimingFunctionName.linear)
        animation.fromValue = from
        animation.toValue = to
        animation.duration = animationDuration
        animation.fillMode = CAMediaTimingFillMode.forwards
        animation.isRemovedOnCompletion = false
        return animation
    }
    
    private func basicAnimation(_ key : String, from : CGFloat, to : CGFloat, damping : CGFloat) -> CAAnimation{
        
        let animation = CABasicAnimation(keyPath: key)
        animation.timingFunction = CAMediaTimingFunction(name: CAMediaTimingFunctionName.linear)
        animation.fromValue = from
        animation.toValue = to
        animation.fillMode = CAMediaTimingFillMode.forwards
        animation.isRemovedOnCompletion = false
        return animation
    }
    
    private func executeAnimation(_ start : Bool, completion:(()->())?){
        
        let group = CAAnimationGroup()
        let animations = getAnimations(start)
        group.duration = animations.first?.duration ?? 1.0
        group.isRemovedOnCompletion = false
        group.fillMode = CAMediaTimingFillMode.forwards
        group.animations = animations
        
        CATransaction.begin()
        CATransaction.setCompletionBlock {
            DispatchQueue.main.async{
                completion?()
            }
        }
        
        layer.add(group, forKey: nil)
        CATransaction.commit()
    }
    
    private func getAnimations(_ start : Bool) -> [CAAnimation]{
        
        if start{
            return [basicAnimation(widthKey, from : bounds.width, to: bounds.height, damping : 16.0),
                    animateKey(cornerRadiusKey, from : initialCornerRadius, to: bounds.height/2.0)]
        }else{
            return [basicAnimation(widthKey, from : bounds.height, to: originalWidth, damping : 15.0),
                    animateKey(cornerRadiusKey, from : bounds.height/2.0, to: initialCornerRadius)]
        }
    }
    
    private func drawCompleteCircle(_ value : Int){
        
        let tickLayer = CAShapeLayer()
        tickLayer.path = UIBezierPath(roundedRect: CGRect(x: 5, y: 5, width: frame.size.height - 10, height: frame.size.height - 10), cornerRadius: frame.size.height/2.0).cgPath
        tickLayer.lineWidth = 2.0
        tickLayer.fillColor = UIColor.clear.cgColor
        tickLayer.strokeEnd = 0.0
        tickLayer.strokeColor = enabledTitleColor.cgColor
        tickLayer.setValue(value, forKey: layerIdentifier)
        layer.addSublayer(tickLayer)
    }
    
    private func searchForLayer(_ result : Int?) -> CAShapeLayer?{
        
        guard let value = result else {return nil}
        
        var shapeLayer : CAShapeLayer?
        guard let subLayers = layer.sublayers else{ return shapeLayer }
        
        for layer in subLayers{
            guard let tempValue =  layer.value(forKey: layerIdentifier), let intValue = tempValue as? Int else { continue }
            if intValue == value{
                shapeLayer = layer as? CAShapeLayer
                break
            }
        }
        return shapeLayer
    }
    
    private func circleGroupedAnimation(_ completion : (()->())?){
        
        let group = CAAnimationGroup()
        group.duration = 0.975
        group.isRemovedOnCompletion = false
        group.fillMode = CAMediaTimingFillMode.forwards
        
        group.animations = [circleBasicAnimation(strokeEnd, fromValue: 0.0, andToValue: 1.0, delay: 0.0), circleBasicAnimation(strokeStart, fromValue: 0.0, andToValue: 1.0, delay: 0.175)]
        group.repeatCount = .infinity
        
        CATransaction.begin()
        CATransaction.setCompletionBlock {
            DispatchQueue.main.async{
                completion?()
            }
        }
        
        searchForLayer(firstLayer)?.add(group, forKey: nil)
        
        CATransaction.commit()
    }
    
    private func circleBasicAnimation(_ key : String, fromValue from:CGFloat, andToValue to:CGFloat, delay : CFTimeInterval = 0.0, duration : CFTimeInterval = 0.8, timingFunction : CAMediaTimingFunction = CAMediaTimingFunction(name:CAMediaTimingFunctionName.easeInEaseOut)) -> CABasicAnimation{
        
        let animation = CABasicAnimation(keyPath: key)
        animation.duration = duration
        animation.beginTime = delay
        animation.fromValue = from
        animation.toValue = to
        animation.timingFunction = timingFunction
        animation.isRemovedOnCompletion = false
        animation.fillMode = CAMediaTimingFillMode.forwards
        
        return animation
    }
}
