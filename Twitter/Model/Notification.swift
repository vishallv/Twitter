//
//  Notification.swift
//  Twitter
//
//  Created by Vishal Lakshminarayanappa on 5/22/20.
//  Copyright © 2020 Vishal Lakshminarayanappa. All rights reserved.
//

import Foundation

enum NotificationType : Int{
    case follow
    case like
    case reply
    case retweet
    case mention
}

struct Notification : Codable {
    
    let uid : String
    var tweetID : String?
    let timestamp : Int
    var user : User?
    var tweet : Tweet?
    var type : Int
    
    enum CodingKeys: String,CodingKey {
        case uid
        case timestamp
        case type
//        case tweetID
    }
}
extension Notification{
    func getDate() ->Date{
        return Date(timeIntervalSince1970: Double(timestamp))
    }
    func getType() -> NotificationType{
        return NotificationType(rawValue: type) ?? .follow
    }
}
