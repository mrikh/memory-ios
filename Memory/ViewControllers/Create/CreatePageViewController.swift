//
//  CreatePageViewController.swift
//  Memory
//
//  Created by Mayank Rikh on 13/07/19.
//  Copyright © 2019 Mayank Rikh. All rights reserved.
//

import UIKit

class CreatePageViewController: UIPageViewController{

    private lazy var createViewControllers = [UIViewController]()

    private var createModel = CreateModel()

    override func viewDidLoad() {
        super.viewDidLoad()

        initialSetup()
    }

    override func viewWillAppear(_ animated: Bool) {

        super.viewWillAppear(animated)

        navigationController?.setNavigationBarHidden(false, animated: true)
        navigationController?.navigationBar.barTintColor = Colors.white
        navigationController?.navigationBar.isTranslucent = false
        navigationController?.navigationBar.shadowImage = UIImage()
    }

    //MARK:- Private
    private func initialSetup(){

        dataSource = self
        navigationItem.title = StringConstants.the_scene.localized
        navigationItem.largeTitleDisplayMode = .never
        view.backgroundColor = Colors.white

        let when = WhenViewController.instantiate(fromAppStoryboard: .Create)
        when.createModel = createModel
        when.delegate = self
        
        createViewControllers.append(when)
        if let first = createViewControllers.first{
            setViewControllers([first], direction: .forward, animated: true, completion: nil)
        }

        clearBackTitle()
    }
}

extension CreatePageViewController : UIPageViewControllerDataSource{

    func pageViewController(_ pageViewController: UIPageViewController, viewControllerBefore viewController: UIViewController) -> UIViewController? {

        guard let index = createViewControllers.firstIndex(of: viewController) else { return nil }
        guard index > 0 else { return nil }

        return checkForViewController(at : index - 1)
    }

    func pageViewController(_ pageViewController: UIPageViewController, viewControllerAfter viewController: UIViewController) -> UIViewController? {

        guard let index = createViewControllers.firstIndex(of: viewController) else { return nil }
        guard index == createViewControllers.count - 1 else { return nil }

        return checkForViewController(at : index + 1)
    }


    func checkForViewController(at position : Int) -> UIViewController?{

        if position < 0 || position > createViewControllers.count - 1 { return nil }
        return createViewControllers[position]
    }
}

extension CreatePageViewController : WhenViewControllerDelegate{

    func userDidCompleteWhenForm() {

        if let position = createViewControllers.firstIndex(where: {$0 is WhereViewController}){
            setViewControllers([createViewControllers[position]], direction: .forward, animated: true, completion: nil)
            return
        }

        let whereVC = WhereViewController.instantiate(fromAppStoryboard: .Create)
        whereVC.createModel = createModel
        whereVC.delegate = self
        createViewControllers.append(whereVC)
        setViewControllers([whereVC], direction: .forward, animated: true, completion: nil)
    }
}

extension CreatePageViewController : WhereViewControllerDelegate{

    func userDidCompleteWhereForm(){

        if let position = createViewControllers.firstIndex(where: {$0 is PhotosSelectionViewController}){
            setViewControllers([createViewControllers[position]], direction: .forward, animated: true, completion: nil)
            return
        }

        let photoVC = PhotosSelectionViewController.instantiate(fromAppStoryboard: .Create)
        photoVC.create = createModel
        createViewControllers.append(photoVC)
        setViewControllers([photoVC], direction: .forward, animated: true, completion: nil)
    }
}
