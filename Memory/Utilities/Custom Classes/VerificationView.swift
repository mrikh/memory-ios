//
//  VerificationView.swift
//  Memory
//
//  Created by Mayank on 08/10/18.
//  Copyright © 2018 Mayank Rikh. All rights reserved.
//

import UIKit

class VerificationView: UIView {

    enum Status{
        case verified
        case invalid
        case inProgress
        case before
    }

    private var otpStatus = Status.before
    private var stopRotating = false

    var path : CGPath?{

        switch otpStatus{
        case .verified: return getTickPath().cgPath
        case .inProgress: return getFetchingPath().cgPath
        case .invalid: return getCrossPath().cgPath
        default: return UIBezierPath().cgPath
        }
    }

    var customLayer : CAShapeLayer?{

        var shapeLayer : CAShapeLayer?
        guard let subLayers = layer.sublayers else{ return shapeLayer }

        for layer in subLayers{
            guard let value =  layer.value(forKey: "animationTag"), let intValue = value as? Int else { continue }

            if intValue == 1005{
                shapeLayer = layer as? CAShapeLayer
                break
            }
        }

        return shapeLayer
    }
    
    override func awakeFromNib() {
        
        super.awakeFromNib()
        show()
    }

    override init(frame: CGRect) {

        super.init(frame: frame)
        show()
    }

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        show()
    }

    override func layoutSubviews() {
        
        super.layoutSubviews()
        updateLayer()
    }

    func updateStatus(value : Status){
        changeStatusView(new: value)
    }
    
    //MARK:- Private
    private func changeStatusView(new : Status){

        otpStatus = new
        if otpStatus == .inProgress{
            show { [weak self] in
                self?.rotation(nil)
            }
        }else{
            stopRotating = true
            clear{
                DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + 0.01, execute: { [weak self] in
                    self?.transform = .identity
                    self?.stopRotating = false
                    self?.show(nil)
                })
            }
        }
    }

    private func show(_ completion:(()->())? = nil){

        createOtpStatusShapeLayer()

        guard let shapeLayer = customLayer else { return }
        let animation = basicAnimation(key: "strokeEnd")
        shapeLayer.strokeEnd = 1.0
        executeAnimation(false, animation : animation, completion: completion)
    }

    private func clear(_ completion:(()->())?){

        stopRotating = true
        guard let shapeLayer = customLayer else { return }
        let animation = basicAnimation(key: "strokeStart")
        shapeLayer.strokeStart = 0.0
        executeAnimation(true, animation : animation, completion: completion)
    }


    private func basicAnimation(key : String) -> CABasicAnimation{

        let animation = CABasicAnimation(keyPath: key)
        animation.duration = 0.4
        animation.timingFunction = CAMediaTimingFunction(name: CAMediaTimingFunctionName.linear)
        animation.fillMode = CAMediaTimingFillMode.forwards
        animation.fromValue = 0.0
        animation.toValue = 1.0
        animation.isRemovedOnCompletion = false
        return animation
    }

    private func createOtpStatusShapeLayer(){
        
        if let layer = customLayer{
            layer.removeFromSuperlayer()
        }
        
        guard let path = self.path else {return}
        
        let tickLayer = CAShapeLayer()
        tickLayer.path = path
        tickLayer.lineWidth = 2.0
        tickLayer.lineCap = CAShapeLayerLineCap.round
        tickLayer.fillColor = UIColor.clear.cgColor
        //so that we don't draw it right away
        tickLayer.strokeEnd = 0.0
        tickLayer.strokeColor = Colors.bgColor.cgColor
        tickLayer.setValue(1005, forKey: "animationTag")
        layer.addSublayer(tickLayer)
    }

    private func updateLayer(){
        
        if let layer = customLayer{
            //layer exists only change path
            layer.path = self.path
        }
    }


    //MARK:- Animations
    private func rotation(_ completion:(()->())?){

        UIView.animate(withDuration: 0.3, delay: 0.0, options: .curveLinear, animations: { [weak self] in
            self?.transform = self?.transform.rotated(by: 3.141593) ?? .identity
        }) { [weak self] (finished) in
            if let rotation = self?.stopRotating, rotation{
                completion?()
            }else{
                self?.rotation(completion)
            }
        }
    }

    private func executeAnimation(_ clear : Bool, animation : CABasicAnimation, completion:(()->())?){
        
        guard let shapeLayer = customLayer else { return }
        
        CATransaction.begin()
        CATransaction.setCompletionBlock {
            DispatchQueue.main.async{
                if clear{
                    shapeLayer.removeFromSuperlayer()
                }
                completion?()
            }
        }

        if clear{
            shapeLayer.add(animation, forKey: "strokeStart")
        }else{
            shapeLayer.add(animation, forKey: "strokeEnd")
        }
        
        CATransaction.commit()
    }


    //MARK:- Paths
    private func getTickPath() -> UIBezierPath{
        
        let path = UIBezierPath()
        let wholeButtonWidth = bounds.size.width
        let wholeButtonHeight = bounds.size.height
        
        let firstPoint = CGPoint(x: wholeButtonWidth/2.0 - wholeButtonWidth/4.0, y: wholeButtonHeight/2.0)
        let secondPoint = CGPoint(x:firstPoint.x + wholeButtonWidth/6.5, y: firstPoint.y + wholeButtonHeight/12.0)
        let thirdPoint = CGPoint(x: secondPoint.x + wholeButtonWidth/2.8, y:secondPoint.y - wholeButtonHeight/4.0)
        
        path.move(to: firstPoint)
        path.addLine(to: secondPoint)
        path.addLine(to: thirdPoint)
        
        return path
    }

    private func getCrossPath() -> UIBezierPath{
        
        let wholeButtonWidth = bounds.size.width
        let wholeButtonHeight = bounds.size.height
        
        let path = UIBezierPath()
        
        let firstPoint = CGPoint(x : wholeButtonWidth/2.0 + wholeButtonWidth/6.0, y : wholeButtonHeight/2.0 + wholeButtonHeight/12.0)
        let secondPoint = CGPoint(x:firstPoint.x - wholeButtonWidth/3.0, y: firstPoint.y - wholeButtonHeight/4.0)
        let thirdPoint = CGPoint(x: secondPoint.x, y: firstPoint.y)
        let fourthPoint = CGPoint(x: firstPoint.x, y: secondPoint.y)
        
        path.move(to: firstPoint)
        path.addLine(to: secondPoint)
        path.move(to: thirdPoint)
        path.addLine(to: fourthPoint)
        
        return path
    }
    
    private func getFetchingPath() -> UIBezierPath{
        
        let path = UIBezierPath()
        let wholeButtonWidth = bounds.size.width
        let wholeButtonHeight = bounds.size.height

        let halfWidth = wholeButtonWidth/2.0
        let halfHeight = wholeButtonHeight/2.0

        //based on hit and trial (-1/3.5 + 1/6.5 + 1/3.0)
        let tempWidth = wholeButtonWidth * 0.2015

        let firstPoint = CGPoint(x: halfWidth + tempWidth, y: halfHeight + halfHeight/6.0 - halfHeight/2.0)
        path.move(to: firstPoint)
        
        let radius = hypot(firstPoint.x - halfWidth, firstPoint.y - halfHeight)
        path.addArc(withCenter: CGPoint(x: halfWidth, y: halfHeight), radius: radius, startAngle: CGFloat(Double.pi * 3.0/2.0) + CGFloat(Double.pi/6.0), endAngle: CGFloat(Double.pi * 3.0/2.0), clockwise: false)
        path.addArc(withCenter: CGPoint(x: halfWidth, y: halfHeight), radius: radius, startAngle: CGFloat(Double.pi * 3.0/2.0), endAngle: CGFloat(2 * Double.pi), clockwise: false)
        
        return path
    }
}
