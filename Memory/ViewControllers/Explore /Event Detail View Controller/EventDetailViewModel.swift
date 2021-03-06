//
//  EventDetailViewModel.swift
//  Memory
//
//  Created by Mayank Rikh on 21/07/19.
//  Copyright © 2019 Mayank Rikh. All rights reserved.
//

import Foundation

protocol EventDetailViewModelDelegate : BaseProtocol{

    func showSuccess(message : String)
    func updatedData()

    func resetButton()
    func updatedAttendingOnServer(isAttending : Bool)
}

class EventDetailViewModel{

    weak var delegate : EventDetailViewModelDelegate?
    
    private var model : EventDetailModel?
    private (set) var isDraft : Bool = false

    convenience init(model : EventDetailModel, isDraft : Bool){

        self.init()
        self.model = model
        self.isDraft = isDraft
    }

    var eventId : String{
        return model?.eventId ?? ""
    }

    var eventName : String?{
        return model?.eventName
    }

    var creatorImage : String{
        return model?.creator.profileImage ?? ""
    }

    var creatorName : String?{
        return model?.creator.name
    }

    var startTuple : (time : String, date : String, monthYear : String, day : String){

        return dateBreakDown(date: model?.startDate) ?? (time : "", date : "", monthYear : "", day : "")
    }

    var endTuple : (time : String, date : String, monthYear : String, day : String){

        return dateBreakDown(date: model?.endDate) ?? (time : "", date : "", monthYear : "", day : "")
    }

    var addressTitle : String?{
        return model?.addressTitle
    }

    var addressDetail : String?{
        return model?.addressDetail
    }

    var nearby : String?{
        return model?.nearby
    }

    var privacy : String?{
        return model?.privacy.displayString
    }

    var additionalInfo : String?{
        return model?.additionalInfo
    }

    var pagerItemsCount : Int{
        return model?.photos.count ?? 0
    }

    var coordinates : (lat : Double?, long : Double?){
        return (lat : model?.lat, long : model?.long)
    }

    var attending : Bool{
        return model?.isAttending ?? false
    }

    func fetchPhoto(at position : Int) -> String{
        return model?.photos[position] ?? ""
    }

    func confirmAction(){

        if isDraft{
            createEvent()
        }else{
            updateAttending()
        }
    }

    //MARK:- Private
    private func dateBreakDown(date : Date?) -> (time : String, date : String, monthYear : String, day : String)?{

        guard let val = date else { return nil }

        let formatter = DateFormatter()
        formatter.dateFormat = DateFormat.timeFormat
        let time = formatter.string(from: val)

        let calendar = Calendar.current
        let components = calendar.dateComponents([.day, .month, .year, .weekday], from: val)

        if let day = components.day, let month = components.month, let year = components.year, let weekday = components.weekday{

            let monthName = formatter.shortMonthSymbols[month - 1]
            let weekdayString = formatter.shortWeekdaySymbols[weekday - 1]
            return (time : time, date : "\(day)", monthYear : "\(monthName) '\(year%1000)", day : weekdayString.localizedUppercase)
        }else{
            return nil
        }
    }

    func fetchEventDetails(){

        guard let tempModel = model else {
            delegate?.errorOccurred(errorString: StringConstants.something_wrong.localized)
            return
        }

        APIManager.eventDetails(id: tempModel.eventId) { [weak self] (json, error) in

            if let tempJson = json?["data"]{
                self?.model = EventDetailModel(json: tempJson)
                self?.delegate?.updatedData()
            }else{
                self?.delegate?.errorOccurred(errorString: error?.localizedDescription ?? StringConstants.something_wrong.localized)
            }
        }
    }

    private func updateAttending(){

        guard let tempModel = model else {
            delegate?.errorOccurred(errorString: StringConstants.something_wrong.localized)
            return
        }

        let value = !tempModel.isAttending

        model?.isAttending = value
        delegate?.resetButton()
        delegate?.updatedAttendingOnServer(isAttending: value)

        APIManager.updateAttending(eventId: tempModel.eventId, isAttending: value) { [weak self] (json, error) in

            if let _ = error{
                //reset to original
                self?.model?.isAttending = !value
                self?.delegate?.resetButton()
                self?.delegate?.updatedAttendingOnServer(isAttending: !value)
            }
        }
    }

    private func createEvent(){

        guard let tempModel = model else {
            delegate?.errorOccurred(errorString: StringConstants.something_wrong.localized)
            return
        }

        delegate?.startLoader()
        APIManager.createEvent(params: tempModel.convertToDictionary()) { [weak self] (json, error) in

            self?.delegate?.stopLoader()

            if let tempJson = json?["data"]{
                let model = EventDetailModel(json: tempJson)
                NotificationCenter.default.post(name: Notification.Name(NotificationKeys.eventCreated), object: model)
                self?.delegate?.showSuccess(message: StringConstants.created.localized)
                #warning("Local notification to locally update UI in profile")
            }else{
                self?.delegate?.errorOccurred(errorString: error?.localizedDescription ?? StringConstants.something_wrong.localized)
            }
        }
    }
}
