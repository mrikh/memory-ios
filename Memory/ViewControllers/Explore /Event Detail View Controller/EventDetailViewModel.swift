//
//  EventDetailViewModel.swift
//  Memory
//
//  Created by Mayank Rikh on 21/07/19.
//  Copyright © 2019 Mayank Rikh. All rights reserved.
//

import Foundation

class EventDetailViewModel{

    private var model : EventDetailModel?
    private var isDraft : Bool = false

    convenience init(model : EventDetailModel, isDraft : Bool){

        self.init()
        self.model = model
        self.isDraft = isDraft
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

        return dateBreakDown(timeInterval: model?.startDate) ?? (time : "", date : "", monthYear : "", day : "")
    }

    var endTuple : (time : String, date : String, monthYear : String, day : String){

        return dateBreakDown(timeInterval: model?.endDate) ?? (time : "", date : "", monthYear : "", day : "")
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

    func fetchPhoto(at position : Int) -> String{
        return model?.photos[position] ?? ""
    }

    //MARK:- Private
    private func dateBreakDown(timeInterval : TimeInterval?) -> (time : String, date : String, monthYear : String, day : String)?{

        guard let interval = timeInterval else { return nil }

        let formatter = DateFormatter()
        let date = Date(timeIntervalSince1970: interval)
        formatter.dateFormat = DateFormat.timeFormat
        let time = formatter.string(from: date)

        let calendar = Calendar.current
        let components = calendar.dateComponents([.day, .month, .year, .weekday], from: date)

        if let day = components.day, let month = components.month, let year = components.year, let weekday = components.weekday{

            let monthName = formatter.shortMonthSymbols[month - 1]
            let weekdayString = formatter.shortWeekdaySymbols[weekday - 1]
            return (time : time, date : "\(day)", monthYear : "\(monthName) '\(year%1000)", day : weekdayString.localizedUppercase)
        }else{
            return nil
        }
    }
}
