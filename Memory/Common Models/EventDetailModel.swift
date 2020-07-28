//
//  EventDetailModel.swift
//  Memory
//
//  Created by Mayank Rikh on 21/07/19.
//  Copyright © 2019 Mayank Rikh. All rights reserved.
//

import SwiftyJSON
import Foundation

struct EventDetailModel{

    let eventId : String
    let photos : [String]
    let eventName : String
    let creator : FriendModel
    let startDate : Date?
    let endDate : Date?
    let addressTitle : String
    let addressDetail : String
    let lat : Double
    let long : Double
    let nearby : String
    let privacy : CreateModel.Privacy
    let additionalInfo : String
    
    let attendingCount : Int
    let otherDetails : String?
    var isAttending : Bool

    init(create : CreateModel){

        //dont need id as this will only happen in case of privacy
        eventId = ""
        photos = create.photos.compactMap({$0.urlString})
        eventName = create.name ?? ""
        creator = FriendModel(id: UserModel.current.userId, name: UserModel.current.name, image: UserModel.current.profilePhoto)
        startDate = create.startDate
        endDate = create.endDate
        addressTitle = create.addressTitle ?? ""
        addressDetail = create.address ?? ""
        lat = create.lat ?? 0.0
        long = create.long ?? 0.0
        nearby = create.nearby ?? ""
        privacy = create.privacy
        additionalInfo = create.otherDetails ?? ""
        
        otherDetails = create.otherDetails
        attendingCount = 0
        isAttending = true
    }

    init(json : JSON){

        eventId = json["_id"].stringValue
        photos = json["photos"].arrayValue.map({$0.stringValue})
        eventName = json["eventName"].stringValue
        creator = FriendModel(json : json["creator"])

        let formatter = DateFormatter()
        formatter.dateFormat = DateFormat.isoFormat
        startDate = formatter.date(from: json["startDate"].stringValue)
        endDate = formatter.date(from: json["endDate"].stringValue)

        addressTitle = json["addressTitle"].stringValue
        addressDetail = json["addressDetail"].stringValue
        lat = json["lat"].doubleValue
        long = json["long"].doubleValue
        additionalInfo = json["additionalInfo"].stringValue
        privacy = CreateModel.Privacy(rawValue : json["privacy"].intValue) ?? .anyone
        nearby = json["nearby"].stringValue

        otherDetails = json["otherDetails"].stringValue
        attendingCount = json["attendingCount"].intValue
        isAttending = json["isAttending"].boolValue
    }

    init(event : EventModel) {

        eventId = event._id
        photos = event.photos
        eventName = event.eventName
        startDate = event.startDate
        addressTitle = event.addressTitle
        addressDetail = event.addressDetail
        attendingCount = event.attendingCount
        creator = FriendModel()
        endDate = nil
        lat = 0.0
        long = 0.0
        nearby = ""
        privacy = CreateModel.Privacy.selectedFriends
        additionalInfo = ""

        otherDetails = nil
        isAttending = event.isAttending
    }

    func convertToDictionary() -> [String : Any]{

        var dict = [String : Any]()
        dict["eventName"] = eventName
        dict["startDate"] = Double(startDate?.timeIntervalSince1970 ?? 0.0) * 1000
        dict["endDate"] = Double(endDate?.timeIntervalSince1970 ?? 0.0) * 1000
        dict["addressTitle"] = addressTitle
        dict["addressDetail"] = addressDetail
        dict["otherDetails"] = otherDetails
        dict["nearby"] = nearby
        dict["lat"] = lat
        dict["long"] = long
        dict["privacy"] = privacy.rawValue
        
        dict["photos"] = photos

        return dict
    }
}
