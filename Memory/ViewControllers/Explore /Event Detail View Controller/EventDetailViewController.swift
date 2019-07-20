//
//  EventDetailViewController.swift
//  Memory
//
//  Created by Mayank Rikh on 21/07/19.
//  Copyright © 2019 Mayank Rikh. All rights reserved.
//

import FSPagerView
import UIKit

class EventDetailViewController: BaseViewController {

    @IBOutlet weak var mainTableView: UITableView!
    //this button is for joining event, exit, confirming preview
    @IBOutlet weak var joinButton: UIButton!
    @IBOutlet weak var backButton: UIButton!

    //table header view
    @IBOutlet weak var photosView: FSPagerView!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var creatorInfoView: UIView!
    @IBOutlet weak var creatorImageView: UIImageView!
    @IBOutlet weak var creatorNameLabel: UILabel!
    @IBOutlet weak var dateView: UIView!

    @IBOutlet weak var startDateView: UIView!
    @IBOutlet weak var startTimeLabel: UILabel!
    @IBOutlet weak var startDayLabel: UILabel!
    @IBOutlet weak var startMonthLabel: UILabel!
    @IBOutlet weak var startDateLabel: UILabel!

    @IBOutlet weak var endDateView: UIView!
    @IBOutlet weak var endTimeLabel: UILabel!
    @IBOutlet weak var endDayLabel: UILabel!
    @IBOutlet weak var endMonthLabel: UILabel!
    @IBOutlet weak var endDateLabel: UILabel!

    @IBOutlet weak var nearbyLabel: UILabel!
    @IBOutlet weak var addressTitle: UILabel!
    @IBOutlet weak var addressDetail: UILabel!
    @IBOutlet weak var privacyLabel: UILabel!
    @IBOutlet weak var additionalInfoLabel: UILabel!


    override func viewDidLoad() {
        super.viewDidLoad()

        initialSetup()
    }

    override func viewWillAppear(_ animated: Bool) {

        super.viewWillAppear(animated)
        navigationController?.setNavigationBarHidden(true, animated: true)
    }

    //MARK:- IBAction

    @IBAction func joinAction(_ sender: UIButton) {


    }

    @IBAction func backAction(_ sender: UIButton) {

        navigationController?.popViewController(animated: true)
    }

    //MARK:- Private
    private func initialSetup(){

    }
}

extension EventDetailViewController : UITableViewDelegate, UITableViewDataSource{

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {

        return 0
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {

        return UITableViewCell()
    }
}

extension EventDetailViewController : FSPagerViewDelegate, FSPagerViewDataSource{

    func numberOfItems(in pagerView: FSPagerView) -> Int {

        return 0
    }

    func pagerView(_ pagerView: FSPagerView, cellForItemAt index: Int) -> FSPagerViewCell {

        return FSPagerViewCell()
    }
}
