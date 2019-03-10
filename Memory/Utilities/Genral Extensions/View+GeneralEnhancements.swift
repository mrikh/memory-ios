//
//  View+GeneralEnhancements.swift
//  Memory
//
//  Created by Mayank Rikh on 25/01/19.
//  Copyright © 2019 Mayank Rikh. All rights reserved.
//

import Foundation
import UIKit

extension UIView{
    
    func addBorder(withColor color:UIColor, andWidth borderWidth:CGFloat){
        self.layer.borderColor = color.cgColor
        self.layer.borderWidth = borderWidth
    }
    
    func addShadow(_ radius : CGFloat, opacity : CGFloat = 0.5, offset : CGSize = CGSize(width : 0.0, height : 0.0)){
        self.layer.masksToBounds = false
        self.layer.shadowColor = UIColor.black.cgColor
        self.layer.shadowOpacity = Float(opacity)
        self.layer.shadowRadius = radius
        self.layer.shadowOffset = offset
    }

    func setBottomShadow () {
        
        self.layer.masksToBounds = false
        self.layer.shadowColor = UIColor.black.cgColor
        self.layer.shadowOpacity = 0.35
        self.layer.shadowOffset = CGSize(width: 0, height: 0)
        self.layer.shadowRadius = 2
        self.layer.shadowPath = UIBezierPath(roundedRect: CGRect(x: 0, y: self.frame.height, width: UIScreen.main.bounds.width, height: 1), cornerRadius: layer.cornerRadius).cgPath
    }
    func insertOnFullScreen(_ subview : UIView, atIndex index : Int){
        
        self.insertSubview(subview, at: index)
        addFullScreenConstraints(subview)
    }
    
    func addOnFullScreen(_ subview:UIView){
        
        self.addSubview(subview)
        addFullScreenConstraints(subview)
    }
    
    func makeRoundByHeight() {
        self.layoutIfNeeded()
        self.layer.cornerRadius = self.bounds.size.height/2
    }

    
    //MARK: Helper Methods
    private func addFullScreenConstraints(_ subview : UIView){
        
        subview.translatesAutoresizingMaskIntoConstraints = false
        
        var customConstraints = [NSLayoutConstraint]()
        let dictionary = ["subview" : subview]
    
        customConstraints.append(contentsOf: NSLayoutConstraint.constraints(withVisualFormat: "H:|[subview]|", options: .init(rawValue: 0), metrics: nil, views: dictionary))
        customConstraints.append(contentsOf: NSLayoutConstraint.constraints(withVisualFormat: "V:|[subview]|", options: .init(rawValue: 0), metrics: nil, views: dictionary))
        
        self.addConstraints(customConstraints)
    }
    
    ///Rounds the given corner based on the given radius
    func roundCorner(_ corner: UIRectCorner, radius: CGFloat) {
        let maskPath = UIBezierPath(roundedRect: bounds, byRoundingCorners: corner, cornerRadii: CGSize(width: radius, height: radius))
        let shape = CAShapeLayer()
        shape.path = maskPath.cgPath
        layer.mask = shape
    }
}

extension UIView {
    
    public class func instantiateFromNib<T: UIView>(viewType: T.Type) -> T {
        return Bundle.main.loadNibNamed(String(describing: viewType), owner: nil, options: nil)!.first as! T
    }
    
    public class func instantiateFromNib() -> Self {
        return instantiateFromNib(viewType: self)
    }
    
    ///Computed property that returns the UINib of passed class
    static var nib:UINib {
        return UINib(nibName: identifier, bundle: nil)
    }
    
    ///Computed property that return the class name as String
    static var identifier: String {
        return String(describing: self)
    }
}

