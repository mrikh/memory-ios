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
        
    }

    @IBAction func nextAction(_ sender: UIButton) {

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
    }

    func scrollViewDidEndDragging(_ scrollView: UIScrollView, willDecelerate decelerate: Bool) {

        if !decelerate{
            updatePage(offset: scrollView.contentOffset.x)
        }
    }

    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        updatePage(offset: scrollView.contentOffset.x)
    }

    private func updatePage(offset : CGFloat){
        let value = Int(offset/mainScrollView.frame.width)
        if let value = TutorialViewController.PageNumber(rawValue: value){
            currentPage = value
        }
    }
}
