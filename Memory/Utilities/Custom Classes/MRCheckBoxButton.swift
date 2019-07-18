//
//  MRCheckBoxButton.swift
//  swift-sample
//
//  Created by Mayank Rikh on 21/03/17.
//  Copyright © 2017 Mayank Rikh. All rights reserved.
//

import UIKit

class MRCheckBoxButton: UIButton {

    private (set) open var currentlySelected : Bool = false

    /// Tick color to use
    @IBInspectable var tickColor : UIColor = UIColor.clear{
        didSet{
            if let tempLayer = searchForLayer(){
                tempLayer.strokeColor = tickColor.cgColor
            }
        }
    }

    /// Background color for the tick
    @IBInspectable var tickBackgroundFillColor : UIColor = UIColor.clear{
        didSet{
            if currentlySelected{
                self.layer.backgroundColor = tickBackgroundFillColor.cgColor
            }
        }
    }

    /// Width of the tick
    @IBInspectable var tickWidth : CGFloat = 2.0{
        didSet{
            if let tempLayer = searchForLayer(){
                tempLayer.lineWidth = tickWidth
                return
            }
        }
    }

    /// Border of the view containing the tick
    @IBInspectable var borderColor : UIColor = UIColor.clear{
        didSet{
            layer.borderColor = borderColor.cgColor
        }
    }

    /// Border od the view having the tick
    @IBInspectable var borderWidth : CGFloat = 0.0{
        didSet{
            layer.borderWidth = borderWidth
        }
    }

    override func awakeFromNib() {

        super.awakeFromNib()

        //initially it should be clear as did set gets called before and sets it to default color
        self.layer.backgroundColor = UIColor.clear.cgColor
        createTick()
    }

    override func layoutSubviews() {

        if let tempLayer = searchForLayer(){
            tempLayer.path = calculatePath().cgPath
        }

        super.layoutSubviews()
    }

    func createTick(){

        let tickLayer = CAShapeLayer()
        tickLayer.path = calculatePath().cgPath;
        tickLayer.lineWidth = tickWidth
        tickLayer.lineCap = CAShapeLayerLineCap.round
        tickLayer.fillColor = UIColor.clear.cgColor
        //so that we don't draw it right away
        tickLayer.strokeEnd = 0.0
        tickLayer.strokeColor = tickColor.cgColor
        tickLayer.setValue(1005, forKey: "animationTag")
        layer.addSublayer(tickLayer)
    }

    func updateSelection(select : Bool, animated : Bool = false){

        //dont update
        if currentlySelected == select {return}
        currentlySelected = select
        currentlySelected ? fillColor(shouldAnimate : animated) : clearColor(animated : animated)
    }

    //MARK: Private

    private func fillColor(shouldAnimate : Bool){

        UIView.animate(withDuration: shouldAnimate ? 0.2 : 0.0, animations: {
            self.layer.backgroundColor = self.tickBackgroundFillColor.cgColor
        }) { (animated) in
            self.showTick(animated : shouldAnimate)
        }
    }

    private func clearColor(animated : Bool){
        self.clearTick(animated : animated)

        UIView.animate(withDuration: animated ? 0.2 : 0.0, animations: {
            self.layer.backgroundColor = UIColor.clear.cgColor
        })
    }

    private func showTick(animated : Bool){

        animating(fromValue: 0, andToValue: 1, andShouldClear: false, animated : animated)
    }

    private func clearTick(animated : Bool){

        animating(fromValue: 1, andToValue: 0, andShouldClear: true, animated : animated)
    }

    private func animating(fromValue from:Int, andToValue to:Int, andShouldClear clear:Bool, animated : Bool){

        //get our shapeLayer reference
        guard let shapeLayer = searchForLayer() else { return }

        if animated{

            let animation = CABasicAnimation(keyPath: "strokeEnd")
            animation.duration = 0.2
            animation.fromValue = from
            animation.toValue = to
            animation.timingFunction = CAMediaTimingFunction(name:CAMediaTimingFunctionName.linear)

            if clear{
                if shapeLayer.strokeEnd != 1.0{ return }

                shapeLayer.removeAnimation(forKey: "strokeEnd")
                shapeLayer.strokeEnd = 0.0
            }else{
                if shapeLayer.strokeEnd != 0.0{ return }
                shapeLayer.strokeEnd = 1.0
            }

            // Do the actual animation
            shapeLayer.add(animation, forKey: "strokeEnd")
        }else{
            UIView.performWithoutAnimation {
                if clear{
                    shapeLayer.strokeEnd = 0.0
                }else{
                    shapeLayer.strokeEnd = 1.0
                }
            }
        }
    }

    private func searchForLayer() -> CAShapeLayer?{

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

    private func calculatePath() -> UIBezierPath{

        let path = UIBezierPath()

        let wholeButtonWidth = bounds.size.width
        let wholeButtonHeight = bounds.size.height

        let firstPoint = CGPoint(x: wholeButtonWidth/2.0 - wholeButtonWidth/3.5, y: wholeButtonHeight/2.0)
        let secondPoint = CGPoint(x:firstPoint.x + wholeButtonWidth/6.5, y: firstPoint.y + wholeButtonHeight/6.0)
        let thirdPoint = CGPoint(x: secondPoint.x + wholeButtonWidth/2.5, y:secondPoint.y - wholeButtonHeight/2.5)

        path.move(to: firstPoint)
        path.addLine(to: secondPoint)
        path.addLine(to: thirdPoint)

        return path
    }
}
