//
//  BaseViewController.swift
//  Memory
//
//  Created by Mayank on 22/11/18.
//  Copyright © 2018 Mayank Rikh. All rights reserved.
//

import DZNEmptyDataSet
import UIKit

class BaseViewController: UIViewController, AlertProtocol {

    var indicator : MRActivityIndicator?
    
    // Boolean value to determine wether we need to show the empty data set or not
    var isLoading : Bool = true
    var emptyDataSetString : String = StringConstants.no_data_found.localized
    var keyboardVisible : Bool = false
    var extraPadding : CGFloat = 0.0

    private var action : (()->())?
    private var infoText : String?
    private var buttonText : String?
    private var image : UIImage?

    override func viewDidLoad() {
        super.viewDidLoad()

        indicator = MRActivityIndicator(on: view, withText: "")
        clearBackTitle()
    }

    override var prefersStatusBarHidden: Bool{
        return false
    }

    override var preferredStatusBarStyle: UIStatusBarStyle{
        return .default
    }

    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        super.touchesBegan(touches, with: event)
        view.endEditing(true)
    }
}

extension BaseViewController : DZNEmptyDataSetSource, DZNEmptyDataSetDelegate {

    func customView(forEmptyDataSet scrollView: UIScrollView!) -> UIView! {

        let noAccess = NoAccessView.nib.instantiate(withOwner: nil, options: nil)[0] as? NoAccessView
        noAccess?.configure(infoText: infoText, with: buttonText, image : image, action: action)
        return noAccess
    }

    func emptyDataSourceDelegate(tableView : UITableView, message : String? = nil, image : UIImage? = nil, buttonText : String? = nil, action : (()->())? = nil) {
        tableView.emptyDataSetSource    = self
        tableView.emptyDataSetDelegate  = self

        self.action = action
        self.infoText = message ?? StringConstants.no_data_found.localized
        self.buttonText = buttonText
        self.image = image
    }
    
    func emptyDataSourceDelegate(collectionView : UICollectionView, message : String? = nil, image : UIImage? = nil, buttonText : String? = nil, action : (()->())? = nil) {
        collectionView.emptyDataSetSource    = self
        collectionView.emptyDataSetDelegate  = self
        
        self.action = action
        self.infoText = message ?? StringConstants.no_data_found.localized
        self.buttonText = buttonText
        self.image = image
    }

    func emptyDataSetShouldAllowScroll(_ scrollView: UIScrollView!) -> Bool {
        return true
    }
    
    func verticalOffset(forEmptyDataSet scrollView: UIScrollView!) -> CGFloat {
        
        return 0.0
    }

    func emptyDataSetShouldAllowTouch(_ scrollView: UIScrollView!) -> Bool {
        return true
    }
    
    func emptyDataSetShouldDisplay(_ scrollView: UIScrollView!) -> Bool {
        return !self.isLoading
    }

    func title(forEmptyDataSet scrollView: UIScrollView!) -> NSAttributedString! {

        return NSMutableAttributedString(string: self.emptyDataSetString, attributes: [NSAttributedString.Key.font: CustomFonts.avenirMedium.withSize(17.0)])
    }
}
