//
//  WhenViewController.swift
//  Memory
//
//  Created by Mayank Rikh on 13/07/19.
//  Copyright © 2019 Mayank Rikh. All rights reserved.
//

import SDWebImage
import UIKit

protocol WhenViewControllerDelegate : AnyObject{

    func userDidCompleteWhenForm()
    func goBackPreviousPage()
}

class WhenViewController: BaseViewController {

    @IBOutlet weak var mainScrollView: UIScrollView!
    @IBOutlet weak var weatherLabel: UILabel!
    @IBOutlet weak var endDatePicker: UIDatePicker!
    @IBOutlet weak var endDateLabel: UILabel!
    @IBOutlet weak var startDatePicker: UIDatePicker!
    @IBOutlet weak var startLabel: UILabel!
    @IBOutlet weak var infoLabel: UILabel!
    @IBOutlet weak var questionLabel: UILabel!
    @IBOutlet weak var scrollViewBottomConstraint: NSLayoutConstraint!
    @IBOutlet weak var previousButton: UIButton!
    @IBOutlet weak var nextButton: UIButton!

    weak var delegate : WhenViewControllerDelegate?
    var createModel : CreateModel?

    override func viewDidLoad() {
        super.viewDidLoad()

        initialSetup()
    }

    override func viewDidLayoutSubviews() {

        super.viewDidLayoutSubviews()

        nextButton.layer.cornerRadius = nextButton.bounds.height/2.0
        previousButton.layer.cornerRadius = previousButton.bounds.height/2.0
    }

    override func viewDidAppear(_ animated: Bool) {

        super.viewDidAppear(animated)
        mainScrollView.flashScrollIndicators()
        fetchWeather()
    }

    //MARK:- IBAction
    @IBAction func previousAction(_ sender: UIButton) {

        delegate?.goBackPreviousPage()
    }

    @IBAction func nextAction(_ sender: UIButton) {

        let start = startDatePicker.date
        let end = endDatePicker.date

        if start == end{
            showAlert(StringConstants.oops.localized, withMessage: StringConstants.not_same.localized, withCompletion: nil)
            return
        }

        if start > end{
            showAlert(StringConstants.oops.localized, withMessage: StringConstants.cannot_end_before.localized, withCompletion: nil)
            return
        }

        createModel?.startDate = start
        createModel?.endDate = end

        delegate?.userDidCompleteWhenForm()
    }

    //MARK:- Private
    private func initialSetup(){

        questionLabel.text = StringConstants.when_party.localized
        questionLabel.textColor = Colors.bgColor
        questionLabel.font = CustomFonts.avenirHeavy.withSize(22.0)

        startLabel.text = StringConstants.start_time.localized
        startLabel.textColor = Colors.bgColor
        startLabel.font = CustomFonts.avenirHeavy.withSize(14.0)

        endDateLabel.text = StringConstants.end_time.localized
        endDateLabel.textColor = Colors.bgColor
        endDateLabel.font = CustomFonts.avenirHeavy.withSize(14.0)

        infoLabel.text = StringConstants.when_info.localized
        infoLabel.textColor = Colors.bgColor
        infoLabel.font = CustomFonts.avenirLight.withSize(14.0)

        previousButton.configureArrowButton(name: .arrowLeft)
        nextButton.configureArrowButton(name: .arrowRight)

        weatherLabel.text = nil
        weatherLabel.textColor = Colors.bgColor
        weatherLabel.font = CustomFonts.avenirLight.withSize(12.0)

        configure(picker: startDatePicker)
        configure(picker: endDatePicker)

        view.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(handleTap)))

        startDatePicker.addTarget(self, action: #selector(valueChanged), for: .valueChanged)
    }

    @objc func valueChanged(){
        fetchWeather()
    }

    @objc func handleTap(){
        
        view.endEditing(true)
    }

    private func configure(picker : UIDatePicker){

        picker.datePickerMode = .dateAndTime
        picker.minimumDate = Date()
    }

    private func fetchWeather(){

        guard let lat = createModel?.lat, let long = createModel?.long else {return}
        guard Calendar.current.isDateInToday(startDatePicker.date) else {return}

        APIManager.openWeatherApi(lat: lat, long: long) { [weak self] (json, error) in

            if let tempJson = json, let value = tempJson["weather"].arrayValue.first?["description"].string{
                self?.weatherLabel.attributedText = nil
                self?.weatherLabel.text = "\(StringConstants.likely_weather.localized) \(value)"

                //fetch image
                if let icon = tempJson["weather"].arrayValue.first?["icon"].string{
                    SDWebImageDownloader.shared.downloadImage(with: URL(string : "http://openweathermap.org/img/wn/\(icon)@2x.png")) { (image, _, _, _) in
                        if let tempImage = image{
                            self?.weatherLabel.text = nil
                            self?.weatherLabel.attributedText = "\(StringConstants.likely_weather.localized) \(value)".addImageToLabel(tempImage, withWidth: 50.0, withHeight: 50.0)
                        }
                    }
                }

            }else{
                self?.weatherLabel.attributedText = nil
                self?.weatherLabel.text = nil
            }
        }
    }
}
