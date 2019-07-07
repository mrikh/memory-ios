//
//  ProgressView.swift
//  Memory
//
//  Created by Mayank Rikh on 08/12/18.
//  Copyright © 2018 Mayank Rikh. All rights reserved.
//

import UIKit

class StoryboardProgressView: UIView {

    private var progressView : ProgressView?

    override func awakeFromNib() {

        super.awakeFromNib()

        backgroundColor = .clear
        progressView = ProgressView.nib.instantiate(withOwner: nil, options: nil)[0] as? ProgressView
        if let tempView = progressView{
            addOnFullScreen(tempView)
        }
    }

    func update(progress : Double){
        progressView?.update(progress: progress)
    }
}


class ProgressView: UIView {

    @IBOutlet weak var loaderView: UIView!
    @IBOutlet weak var progressLabel: UILabel!

    private let layerIdentifier = "loader"
    private let value = 1005

    var tapAction : (()->())?

    private var path : UIBezierPath{
        return UIBezierPath(roundedRect: loaderView.bounds, cornerRadius: loaderView.bounds.height/2.0)
    }

    override func awakeFromNib() {
        super.awakeFromNib()
        setup()
    }

    override func layoutSubviews() {

        super.layoutSubviews()
        if let layer = searchForLayer(value, identifier: layerIdentifier){
            layer.path = path.cgPath
        }
    }

    func update(progress : Double){

        if let layer = searchForLayer(value, identifier: layerIdentifier){
            layer.strokeEnd = CGFloat(progress)
        }

        let finalValue = Int(progress * 100)
        let string = String(format : "%02i", min(finalValue, 100))

        progressLabel.text = "\(string)%"
    }

    //MARK:- IBAction
    @IBAction func tapAction(_ sender: UIButton) {
        tapAction?()
    }


    //MARK:- Private
    private func setup(){

        backgroundColor = .clear
        progressLabel.textColor = Colors.white
        progressLabel.font = CustomFonts.avenirHeavy.withSize(35.0)
        progressLabel.text = StringConstants.loading.localized
        loaderView.backgroundColor = .clear

        let tempLayer = CAShapeLayer()
        tempLayer.path = path.cgPath
        tempLayer.lineWidth = 10.0
        tempLayer.fillColor = UIColor.clear.cgColor
        tempLayer.strokeEnd = 0.0
        tempLayer.strokeColor = Colors.bgColor.cgColor
        tempLayer.setValue(value, forKey: layerIdentifier)
        loaderView.layer.addSublayer(tempLayer)
    }

    private func searchForLayer(_ value : Int, identifier : String) -> CAShapeLayer?{

        var shapeLayer : CAShapeLayer?
        guard let subLayers = loaderView.layer.sublayers else{ return shapeLayer }

        for layer in subLayers{
            guard let tempValue =  layer.value(forKey: layerIdentifier), let intValue = tempValue as? Int else { continue }
            if intValue == value{
                shapeLayer = layer as? CAShapeLayer
                break
            }
        }
        return shapeLayer
    }
}
