//
//  CreatePageViewController.swift
//  Memory
//
//  Created by Mayank Rikh on 13/07/19.
//  Copyright © 2019 Mayank Rikh. All rights reserved.
//

import UIKit

class CreatePageViewController: UIPageViewController, AlertProtocol{

    private lazy var createViewControllers = [UIViewController]()

    private var createModel = CreateModel()

    override func viewDidLoad() {
        super.viewDidLoad()

        initialSetup()
    }

    //MARK:- Private
    private func initialSetup(){

        dataSource = self
        navigationItem.title = StringConstants.the_scene.localized
        navigationItem.largeTitleDisplayMode = .never
        view.backgroundColor = Colors.white

        setupFirstScreen()
        clearBackTitle()

        NotificationCenter.default.addObserver(self, selector: #selector(handleEventCreate(_:)), name: Notification.Name(NotificationKeys.eventCreated), object: nil)
    }

    private func setupFirstScreen(){

        let name = NameViewController.instantiate(fromAppStoryboard: .Create)
        name.createModel = createModel
        name.delegate = self

        createViewControllers.append(name)
        if let first = createViewControllers.first{
            setViewControllers([first], direction: .forward, animated: false, completion: nil)
        }
    }

    @objc func handleEventCreate(_ notification : Notification){

        guard let _ = notification.object as? EventDetailModel else {return}
        createViewControllers.removeAll()
        createModel = CreateModel()
        setupFirstScreen()
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
        guard index < createViewControllers.count - 1 else { return nil }

        return checkForViewController(at : index + 1)
    }


    func checkForViewController(at position : Int) -> UIViewController?{

        if position < 0 || position > createViewControllers.count - 1 { return nil }
        return createViewControllers[position]
    }
}

extension CreatePageViewController : NameViewControllerDelegate{

    func userDidComplete() {

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

        if let position = createViewControllers.firstIndex(where: {$0 is WhenViewController}){
            setViewControllers([createViewControllers[position]], direction: .forward, animated: true, completion: nil)
            return
        }

        let when = WhenViewController.instantiate(fromAppStoryboard: .Create)
        when.delegate = self
        when.createModel = createModel
        createViewControllers.append(when)
        setViewControllers([when], direction: .forward, animated: true, completion: nil)
    }

    func goBackPreviousPage() {

        if let position = createViewControllers.firstIndex(where: {$0 is NameViewController}){
            setViewControllers([createViewControllers[position]], direction: .reverse, animated: true, completion: nil)
            return
        }
    }
}

extension CreatePageViewController : WhenViewControllerDelegate{

    func userDidCompleteWhenForm() {

        if let position = createViewControllers.firstIndex(where: {$0 is PhotosSelectionViewController}){
            setViewControllers([createViewControllers[position]], direction: .forward, animated: true, completion: nil)
            return
        }

        let photos = PhotosSelectionViewController.instantiate(fromAppStoryboard: .Create)
        photos.create = createModel
        photos.delegate = self
        createViewControllers.append(photos)
        setViewControllers([photos], direction: .forward, animated: true, completion: nil)
    }

    func goBackPreviousPage() {

        if let position = createViewControllers.firstIndex(where: {$0 is WhereViewController}){
            setViewControllers([createViewControllers[position]], direction: .reverse, animated: true, completion: nil)
            return
        }
    }
}

extension CreatePageViewController : PhotoSelectionViewControllerDelegate{

    func userDidPressContinue() {

        if let position = createViewControllers.firstIndex(where: {$0 is InviteFriendsViewController}){
            setViewControllers([createViewControllers[position]], direction: .forward, animated: true, completion: nil)
            return
        }

        let invite = InviteFriendsViewController.instantiate(fromAppStoryboard: .Create)
        invite.create = createModel
        invite.delegate = self
        createViewControllers.append(invite)
        setViewControllers([invite], direction: .forward, animated: true, completion: nil)
    }
}

extension CreatePageViewController : InviteFriendsViewControllerDelegate{

    func didPressNext() {

        if let position = createViewControllers.firstIndex(where: {$0 is ExtraInfoViewController}){
            setViewControllers([createViewControllers[position]], direction: .forward, animated: true, completion: nil)
            return
        }

        let extra = ExtraInfoViewController.instantiate(fromAppStoryboard: .Create)
        extra.createModel = createModel
        extra.delegate = self
        createViewControllers.append(extra)
        setViewControllers([extra], direction: .forward, animated: true, completion: nil)
    }
}

extension CreatePageViewController : ExtraInfoViewControllerDelegate{

    func didPressDone() {

        if let viewController = createViewControllers.first(where: {$0 is PhotosSelectionViewController}), let photos = viewController as? PhotosSelectionViewController{

            if photos.isUploading{
                showAlert(StringConstants.sorry.localized, withMessage: StringConstants.please_wait_images.localized, withCompletion: nil)
                return
            }
        }

        let viewController = EventDetailViewController.instantiate(fromAppStoryboard: .Explore)
        viewController.viewModel = EventDetailViewModel(model: EventDetailModel(create: createModel), isDraft: true)
        navigationController?.pushViewController(viewController, animated: true)
    }
}
