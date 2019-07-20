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

    enum EventStatus : Int{
        case pending
        case completed
    }

    let eventId : String
    let eventStatus : EventStatus
    let photos : [String]
    let eventName : String
    let creator : FriendModel

    let startDate : TimeInterval
    let endDate : TimeInterval

    let addressTitle : String
    let addressDetail : String
    let lat : Double
    let long : Double
    let nearby : String

    let privacy : CreateModel.Privacy
    let additionalInfo : String
    let invited : [FriendModel]

    init(create : CreateModel){

        //dont need id as this will only happen in case of privacy
        eventId = ""
        eventStatus = .pending
        photos = create.photos.compactMap({$0.urlString})
        eventName = create.name ?? ""
        creator = FriendModel(id: UserModel.current.userId, name: UserModel.current.name, image: UserModel.current.profilePhoto)

        startDate = create.startDate ?? 0.0
        endDate = create.endDate ?? 0.0

        addressTitle = create.addressTitle ?? ""
        addressDetail = create.address ?? ""
        lat = create.lat ?? 0.0
        long = create.long ?? 0.0
        nearby = create.nearby ?? ""

        privacy = create.privacy
        additionalInfo = create.otherDetails ?? ""
        invited = create.invited
    }
}
