//
//  CircularFadeOutAnimation.swift
//  GullyBeatsBeta
//
//  Created by Mayank Rikh on 06/12/18.
//  Copyright © 2018 Appinventiv. All rights reserved.
//

import UIKit

class CircularFadeOutAnimation : UIViewController, UIViewControllerAnimatedTransitioning{

    weak var context: UIViewControllerContextTransitioning?
    var triggerFrame : CGRect!
    private var imageContainer : UIView!

    func transitionDuration(using transitionContext: UIViewControllerContextTransitioning?) -> TimeInterval {

        return 0.5
    }

    func animateTransition(using transitionContext: UIViewControllerContextTransitioning) {

        guard let toController = transitionContext.viewController(forKey: UITransitionContextViewControllerKey.to) else {
            transitionContext.completeTransition(false)
            return
        }
        guard let fromController = transitionContext.viewController(forKey: UITransitionContextViewControllerKey.from) else {
            transitionContext.completeTransition(false)
            return
        }

        context = transitionContext

        let containerView = transitionContext.containerView
        let totalDuration = transitionDuration(using: transitionContext)

        imageContainer = UIView(frame: triggerFrame)
        imageContainer.layer.cornerRadius = imageContainer.bounds.height/2.0
        imageContainer.clipsToBounds = true
        imageContainer.backgroundColor = Colors.clear
        imageContainer.isUserInteractionEnabled = false

        //hardcoded height after several trials and error to account for image height and the offset it produced inside the icon which was necessary to make it appear above the tabbar
        let initialImageView = setupImageView(#imageLiteral(resourceName: "Tabbar Cross Animation"), frame: CGRect(x: 0.0, y: 3.0, width : 49.0, height : 49.0))
        initialImageView.layer.cornerRadius = 25.0
        initialImageView.backgroundColor = Colors.clear
        initialImageView.clipsToBounds = false
        initialImageView.center.x = imageContainer.bounds.width/2.0
        initialImageView.contentMode = .center

        let finalImageView = setupImageView(#imageLiteral(resourceName: "create_plus_animation"), frame: initialImageView.frame)
        finalImageView.layer.cornerRadius = 25.0
        finalImageView.clipsToBounds = false
        finalImageView.backgroundColor = Colors.clear
        finalImageView.center.x = imageContainer.bounds.width/2.0
        finalImageView.alpha = 0.0
        finalImageView.contentMode = .center
        
        containerView.addSubview(imageContainer)

        //Destination Path
        let fullHeight = toController.view.bounds.height
        let initialPath = UIBezierPath(ovalIn: triggerFrame.insetBy(dx: -fullHeight, dy: -fullHeight))

        let differenceInHeight = imageContainer.frame.height - initialImageView.frame.height
        let finalPath = UIBezierPath(ovalIn: triggerFrame.insetBy(dx: differenceInHeight, dy: differenceInHeight))

        let maskLayer = CAShapeLayer()
        maskLayer.path = finalPath.cgPath
        fromController.view.layer.mask = maskLayer

        let maskLayerAnimation = CABasicAnimation(keyPath: "path")
        maskLayerAnimation.fromValue = initialPath.cgPath
        maskLayerAnimation.toValue = finalPath.cgPath
        maskLayerAnimation.duration = totalDuration
        maskLayerAnimation.delegate = self
        maskLayer.add(maskLayerAnimation, forKey: "path")

        rotateAnimation(view: initialImageView, totalDuration : totalDuration)
        rotateAnimation(view: finalImageView, totalDuration : totalDuration)

        UIView.animate(withDuration: totalDuration, animations: {

            initialImageView.alpha = 0.0
            finalImageView.alpha = 1.0

        }) { (finished) in
            fromController.view.layer.mask = nil
        }
    }

    private func rotateAnimation(view: UIView, duration: CFTimeInterval = 0.5, totalDuration : CFTimeInterval) {
        let rotateAnimation = CABasicAnimation(keyPath: "transform.rotation")
        rotateAnimation.fromValue = 0.0
        rotateAnimation.toValue = CGFloat(.pi * 2.0)
        rotateAnimation.duration = duration
        rotateAnimation.repeatCount = Float(totalDuration/duration)
        view.layer.add(rotateAnimation, forKey: nil)
    }

    private func setupImageView(_ image : UIImage, frame : CGRect) -> UIImageView{

        let imageView = UIImageView(frame : frame)
        imageView.image = image
        imageView.contentMode = .center
        imageContainer.addSubview(imageView)
        return imageView
    }
}

extension CircularFadeOutAnimation: CAAnimationDelegate {

    func animationDidStop(_ anim: CAAnimation, finished flag: Bool) {

        imageContainer.removeFromSuperview()
        context?.completeTransition(true)
    }
}

