//
//  TutorialPageViewController.swift
//  Memory
//
//  Created by Mayank Rikh on 20/06/20.
//  Copyright © 2020 Mayank Rikh. All rights reserved.
//

import FontAwesome_swift
import CHIPageControl
import UIKit

class TutorialPageViewController: BaseViewController {

    @IBOutlet weak var mainScrollView: UIScrollView!
    @IBOutlet weak var firstPageView: UIView!
    @IBOutlet weak var secondPageView: UIView!
    @IBOutlet weak var thirdPageView: UIView!

    @IBOutlet weak var pageControl: CHIPageControlAleppo!
    @IBOutlet weak var nextButton: UIButton!
    @IBOutlet weak var doneButton: UIButton!
    @IBOutlet weak var previousButton: UIButton!

    private var currentPage : TutorialViewController.PageNumber = .first{
        didSet{
            pageControl.set(progress: currentPage.rawValue, animated: false)
        }
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        initialSetup()
    }

    //MARK:- IBAction
    @IBAction func previousAction(_ sender: UIButton) {

        let offset = Int(UIScreen.main.bounds.width) * (max(currentPage.rawValue - 1, 0))
        mainScrollView.setContentOffset(CGPoint(x: offset, y: 0), animated: true)
        updatePage(with : CGFloat(offset))
    }

    @IBAction func nextAction(_ sender: UIButton) {

        let offset = Int(UIScreen.main.bounds.width) * (min(currentPage.rawValue + 1, TutorialViewController.PageNumber.allCases.count - 1))
        mainScrollView.setContentOffset(CGPoint(x: offset, y: 0), animated: true)
        updatePage(with : CGFloat(offset))
    }

    @IBAction func doneAction(_ sender: UIButton) {

        Defaults.save(value: true, forKey: Defaults.Key.tutorialDone)
        navigationController?.setViewControllers([LoginViewController.instantiate(fromAppStoryboard: .PreLogin)], animated: true)
    }

    //MARK:- Private
    private func initialSetup(){

        pageControl.numberOfPages = 3
        pageControl.currentPageTintColor = Colors.black
        pageControl.tintColor = Colors.black.withAlphaComponent(0.45)
        pageControl.enableTouchEvents = false

        nextButton.configureFontAwesome(name: FontAwesome.arrowRight, size: 21.0, style : FontAwesomeStyle.solid)
        previousButton.configureFontAwesome(name: FontAwesome.arrowLeft, size: 21.0, style : FontAwesomeStyle.solid)

        addChildWith(viewController: TutorialViewController.instantiate(fromAppStoryboard: .PreLogin), on: firstPageView, with : .first)
        addChildWith(viewController: TutorialViewController.instantiate(fromAppStoryboard: .PreLogin), on: secondPageView, with : .second)
        addChildWith(viewController: TutorialViewController.instantiate(fromAppStoryboard: .PreLogin), on: thirdPageView, with : .third)

        mainScrollView.delegate = self

        previousButton.alpha = 0.0
        doneButton.alpha = 0.0

        doneButton.setAttributedTitle(NSAttributedString(string : StringConstants.done.localized, attributes : [.foregroundColor : Colors.bgColor, .font : CustomFonts.avenirHeavy.withSize(12.0), .underlineStyle : NSUnderlineStyle.single.rawValue]), for: .normal)
    }

    private func addChildWith(viewController : TutorialViewController, on view: UIView, with page : TutorialViewController.PageNumber){

        viewController.currentPage = page
        addChild(viewController)
        viewController.didMove(toParent: self)
        view.addOnFullScreen(viewController.view)
    }
}

extension TutorialPageViewController : UIScrollViewDelegate{

    func scrollViewDidScroll(_ scrollView: UIScrollView) {

        let progress = scrollView.contentOffset.x/scrollView.bounds.width
        pageControl.progress = Double(progress)
        if progress <= 1.0{
            previousButton.alpha = max(0, progress)
        }else if progress > 1.0 && progress <= 2.0{
            nextButton.alpha = max(1.0 - (progress - 1.0), 0.0)
            doneButton.alpha = min(1.0, (progress - 1.0))
        }
    }

    func scrollViewDidEndDragging(_ scrollView: UIScrollView, willDecelerate decelerate: Bool) {

        if !decelerate{
            updatePage(with: scrollView.contentOffset.x)
        }
    }

    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        updatePage(with : scrollView.contentOffset.x)
    }

    private func updatePage(with offset : CGFloat){
        let value = Int(offset/mainScrollView.frame.width)
        if let value = TutorialViewController.PageNumber(rawValue: value){
            currentPage = value
        }
    }
}
