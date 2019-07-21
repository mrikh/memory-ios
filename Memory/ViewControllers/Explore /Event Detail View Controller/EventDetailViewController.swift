//
//  EventDetailViewController.swift
//  Memory
//
//  Created by Mayank Rikh on 21/07/19.
//  Copyright © 2019 Mayank Rikh. All rights reserved.
//

import FontAwesome_swift
import UIKit

class EventDetailViewController: BaseViewController, TableViewHeaderFooterResizeProtocol {

    @IBOutlet weak var mainTableView: UITableView!
    //this button is for joining event, exit, confirming preview
    @IBOutlet weak var joinButton: UIButton!
    @IBOutlet weak var backButton: UIButton!

    //table header view
    @IBOutlet weak var bufferView: UIView!
    @IBOutlet weak var photosHeightConstraint: NSLayoutConstraint!

    @IBOutlet weak var photosView: UICollectionView!{
        didSet{
            photosView.register(FSImageCollectionViewCell.nib, forCellWithReuseIdentifier: FSImageCollectionViewCell.identifier)
        }
    }

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
    @IBOutlet weak var toLabel: UILabel!
    
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
    @IBOutlet weak var mapsButton: UIButton!

    var viewModel = EventDetailViewModel()

    override func viewDidLoad() {
        super.viewDidLoad()

        initialSetup()
    }

    override func viewWillAppear(_ animated: Bool) {

        super.viewWillAppear(animated)
        navigationController?.setNavigationBarHidden(true, animated: true)
    }

    override func viewDidLayoutSubviews() {

        super.viewDidLayoutSubviews()

        if let view = mainTableView.tableHeaderView, let resized = resizeView(view){
            mainTableView.tableHeaderView = resized
        }

        let height = viewModel.pagerItemsCount == 0 ? backButton.frame.maxY + 10.0 : UIScreen.main.bounds.height/3.0
        photosHeightConstraint.constant = height
    }

    //MARK:- IBAction
    @IBAction func mapsAction(_ sender: UIButton) {

        let tuple = viewModel.coordinates
        
        guard let lat = tuple.lat, let long = tuple.long else { return }
        Utilities.openMaps(lat, andLongitude: long, title: viewModel.addressTitle)
    }

    @IBAction func joinAction(_ sender: UIButton) {

    }

    @IBAction func backAction(_ sender: UIButton) {

        navigationController?.popViewController(animated: true)
    }

    //MARK:- Private
    private func initialSetup(){

        mainTableView.tableFooterView = UIView()

        bufferView.backgroundColor = Colors.bgColor
        mainTableView.tableFooterView = UIView()
        mainTableView.tableFooterView?.frame.size.height = joinButton.frame.size.height + 15.0

        mapsButton.setImage(UIImage.fontAwesomeIcon(name: FontAwesome.locationArrow, style: .solid, textColor: Colors.bgColor, size: CGSize(width: 30.0, height : 30.0)), for: .normal)

        backButton.setImage(UIImage.fontAwesomeIcon(name: FontAwesome.chevronLeft, style: .solid, textColor: Colors.bgColor, size: CGSize(width: 30.0, height : 30.0)), for: .normal)
        backButton.addShadow(3.0)

        configure(label: nameLabel, font: CustomFonts.avenirMedium.withSize(23.0), text: viewModel.eventName)
        creatorImageView.setImageWithCompletion(viewModel.creatorImage, placeholder: nil)
        configure(label: creatorNameLabel, font: CustomFonts.avenirLight.withSize(12.0), text: viewModel.creatorName)

        startDateView.addShadow(3.0)
        endDateView.addShadow(3.0)

        let startTuple = viewModel.startTuple
        configure(label: startTimeLabel, font: CustomFonts.avenirLight.withSize(16.0), text: startTuple.time)
        configure(label: startDayLabel, font: CustomFonts.avenirMedium.withSize(18.0), text: startTuple.day)
        configure(label: startMonthLabel, font: CustomFonts.avenirLight.withSize(13.0), text: startTuple.monthYear)
        configure(label: startDateLabel, font: CustomFonts.avenirHeavy.withSize(34.0), text: startTuple.date)

        let endTuple = viewModel.endTuple
        configure(label: endTimeLabel, font: CustomFonts.avenirLight.withSize(16.0), text: endTuple.time)
        configure(label: endDayLabel, font: CustomFonts.avenirMedium.withSize(18.0), text: endTuple.day)
        configure(label: endMonthLabel, font: CustomFonts.avenirLight.withSize(13.0), text: endTuple.monthYear)
        configure(label: endDateLabel, font: CustomFonts.avenirHeavy.withSize(34.0), text: endTuple.date)

        configure(label: addressTitle, font: CustomFonts.avenirMedium.withSize(16.0), text: viewModel.addressTitle)
        configure(label: addressDetail, font: CustomFonts.avenirLight.withSize(13.0), text: viewModel.addressDetail)
        configure(label: nearbyLabel, font: CustomFonts.avenirLight.withSize(13.0), text: viewModel.nearby)
        configure(label: privacyLabel, font: CustomFonts.avenirHeavy.withSize(14.0), text: viewModel.privacy)
        configure(label: additionalInfoLabel, font: CustomFonts.avenirMedium.withSize(14.0), text: viewModel.additionalInfo)

        configure(label: toLabel, font: CustomFonts.avenirLight.withSize(10.0), text: StringConstants.to.localized)

        joinButton.setAttributedTitle(NSAttributedString(string : StringConstants.looks_ok.localized, attributes : [.foregroundColor : Colors.white, .font : CustomFonts.avenirHeavy.withSize(15.0), .underlineStyle : NSUnderlineStyle.single.rawValue]), for: .normal)
        joinButton.backgroundColor = Colors.black
    }

    private func configure(label : UILabel, font : UIFont, text : String?){

        label.textColor = Colors.bgColor
        label.font = font
        label.text = text
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

extension EventDetailViewController : UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout{

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {

        return collectionView.bounds.size
    }

    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {

        return viewModel.pagerItemsCount
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {

        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: FSImageCollectionViewCell.identifier, for: indexPath) as? FSImageCollectionViewCell else { return UICollectionViewCell(frame : CGRect.zero) }

        cell.photoImageView.setImageWithCompletion(viewModel.fetchPhoto(at: indexPath.item), placeholder: nil)
        return cell
    }
}
