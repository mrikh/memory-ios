//
//  TutorialPageViewController.swift
//  Memory
//
//  Created by Mayank Rikh on 20/06/20.
//  Copyright © 2020 Mayank Rikh. All rights reserved.
//

import FontAwesome_swift
import UIKit

class TutorialPageViewController: BaseViewController {

    @IBOutlet weak var mainScrollView: UIScrollView!
    @IBOutlet weak var firstPageView: UIView!
    @IBOutlet weak var secondPageView: UIView!
    @IBOutlet weak var thirdPageView: UIView!

    @IBOutlet weak var pageControl: UIPageControl!
    @IBOutlet weak var nextButton: UIButton!
    @IBOutlet weak var previousButton: UIButton!

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
        pageControl.currentPageIndicatorTintColor = Colors.black
        pageControl.currentPage = 0
        pageControl.tintColor = Colors.black.withAlphaComponent(0.45)

        nextButton.configureFontAwesome(name: FontAwesome.arrowRight, size: 21.0)
        previousButton.configureFontAwesome(name: FontAwesome.arrowLeft, size: 21.0)
    }
}
