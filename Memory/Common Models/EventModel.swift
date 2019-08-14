//
//  EventModel.swift
//  Memory
//
//  Created by Mayank Rikh on 14/08/19.
//  Copyright © 2019 Mayank Rikh. All rights reserved.
//

import SwiftyJSON
import Foundation

struct EventModel {

    let photos : [String]
    let _id : String
    let eventName : String
    let startDate : Date?

    let addressTitle : String
    let addressDetail : String

    let attendingCount : Int
    let attending : [FriendModel]


    init(json : JSON){

        photos = json["photos"].arrayValue.map({$0.stringValue})
        _id = json["_id"].stringValue
        eventName = json["eventName"].stringValue

        let formatter = DateFormatter()
        formatter.dateFormat = DateFormat.isoFormat
        startDate = formatter.date(from: json["startDate"].stringValue)

        addressTitle = json["addressTitle"].stringValue
        addressDetail = json["addressDetail"].stringValue

        attendingCount = json["attendingCount"].intValue

        attending = json["attending"].arrayValue.map({FriendModel(json : $0)})
    }
}
