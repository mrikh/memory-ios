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
    
    /// Boolean value to determine wether we need to show the empty data set or not
    var isLoading : Bool = true
    var emptyDataSetString : String = StringConstants.no_data_found.localized
    var keyboardVisible : Bool = false
    var extraPadding : CGFloat = 0.0

    private var action : (()->())?
    private var infoText : String?
    private var buttonText : String?
    var showEmptyView = false

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

    func configureEmptyView(infoText : String?, with buttonText : String?, action : (()->())?){

        self.action = action
        self.infoText = infoText
        self.buttonText = buttonText
        showEmptyView = true
    }
}

extension BaseViewController : DZNEmptyDataSetSource, DZNEmptyDataSetDelegate {

    func customView(forEmptyDataSet scrollView: UIScrollView!) -> UIView! {

        if showEmptyView{
            let noAccess = NoAccessView.nib.instantiate(withOwner: nil, options: nil)[0] as? NoAccessView
            noAccess?.configure(infoText: infoText, with: buttonText, action: action)
            return noAccess
        }else{
            return nil
        }
    }

    func emptyDataSourceDelegate(tableView : UITableView, message : String? = nil) {
        tableView.emptyDataSetSource    = self
        tableView.emptyDataSetDelegate  = self
        if let string = message {
            self.emptyDataSetString = string
        }
    }
    
    func emptyDataSourceDelegate(collectionView : UICollectionView, message : String? = nil) {
        collectionView.emptyDataSetSource    = self
        collectionView.emptyDataSetDelegate  = self
        
        if let string = message {
            self.emptyDataSetString = string
        }
    }
    
    func verticalOffset(forEmptyDataSet scrollView: UIScrollView!) -> CGFloat {
        
        return 0.0
    }

    func emptyDataSetShouldAllowTouch(_ scrollView: UIScrollView!) -> Bool {
        return true
    }
    
    func emptyDataSetShouldDisplay(_ scrollView: UIScrollView!) -> Bool {
        return !self.isLoading || showEmptyView
    }

    func title(forEmptyDataSet scrollView: UIScrollView!) -> NSAttributedString! {

        return NSMutableAttributedString(string: self.emptyDataSetString, attributes: [NSAttributedString.Key.font: CustomFonts.avenirMedium.withSize(17.0)])
    }
}
