//
//  ProfilePhotoViewController.swift
//  Memory
//
//  Created by Mayank Rikh on 07/07/19.
//  Copyright © 2019 Mayank Rikh. All rights reserved.
//

import UIKit

class ProfilePhotoViewController: BaseViewController {

    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var imageContainerView: UIView!
    @IBOutlet weak var doneButton: MRAnimatingButton!
    @IBOutlet weak var skipButton: UIButton!
    @IBOutlet weak var infoLabel: UILabel!
    @IBOutlet weak var topColorView: UIView!
    @IBOutlet weak var semiCircleView: UIView!

    private var semiPath : UIBezierPath{
        let path = UIBezierPath()
        let radius = semiCircleView.bounds.height * 2.5
        let centerPoint = CGPoint(x : semiCircleView.center.x, y: radius)

        path.addArc(withCenter: centerPoint, radius: radius, startAngle: 0, endAngle: CGFloat(Double.pi), clockwise: false)
        return path
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        initialSetup()
    }

    override func viewWillAppear(_ animated: Bool) {

        super.viewWillAppear(animated)
        navigationController?.setNavigationBarHidden(true, animated: true)
    }

    override func viewDidLayoutSubviews() {

        super.viewDidLayoutSubviews()
        let layer = semiCircleView.layer.sublayers?.first(where: { (sub) -> Bool in
            if let value = sub.value(forKey: "bgColor") as? Int, value == 1005{
                return true
            }else{
                return false
            }
        })

        (layer as? CAShapeLayer)?.path = semiPath.cgPath
        doneButton.layer.cornerRadius = doneButton.bounds.height/2.0
        imageView.layer.cornerRadius = imageView.bounds.width/2.0
        imageContainerView.layer.cornerRadius = imageContainerView.bounds.width/2.0
    }

    //MARK:- IBAction
    @IBAction func skipAction(_ sender: UIButton) {
    }

    @IBAction func doneAction(_ sender: UIButton) {
    }

    //MARK:- Private
    private func initialSetup(){

        infoLabel.textColor = Colors.black
        infoLabel.font = CustomFonts.avenirMedium.withSize(15.0)
        infoLabel.text = StringConstants.upload_photo.localized

        topColorView.backgroundColor = Colors.bgColor
        semiCircleView.backgroundColor = Colors.clear

        let layer = CAShapeLayer()
        layer.fillColor = Colors.white.cgColor
        layer.setValue(1005, forKey: "bgColor")
        layer.path = semiPath.cgPath
        semiCircleView.layer.addSublayer(layer)

        doneButton.setTitle(StringConstants.done.localized, for: .normal)
        doneButton.disableButton()

        skipButton.setAttributedTitle(NSAttributedString(string : StringConstants.skip.localized, attributes : [.font : CustomFonts.avenirHeavy.withSize(12.0), .foregroundColor : Colors.bgColor, .underlineStyle : NSUnderlineStyle.single.rawValue]), for: .normal)

        imageContainerView.layer.borderColor = Colors.white.cgColor
        imageContainerView.layer.borderWidth = 2.5

        imageContainerView.addShadow(3.0)
    }
}
