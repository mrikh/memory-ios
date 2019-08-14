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
    let invited : [FriendModel]

    let attendingCount : Int

    let otherDetails : String?

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
        invited = create.invited

        otherDetails = create.otherDetails

        attendingCount = 0
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
        invited = json["invited"].arrayValue.map({FriendModel(json : $0)})
        otherDetails = json["otherDetails"].stringValue

        attendingCount = json["attendingCount"].intValue
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
        dict["invited"] = invited.map({$0.friendId})

        return dict
    }
}
