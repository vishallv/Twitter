//
//  Tweet.swift
//  Twitter
//
//  Created by Vishal Lakshminarayanappa on 5/17/20.
//  Copyright © 2020 Vishal Lakshminarayanappa. All rights reserved.
//

import Foundation

struct Tweet : Decodable {
    
    let caption : String
    var likes : Int
    let retweets : Int
    let uid : String
    let timestamp : Int
    var tweetId : String?
    var user : User?
    var didLike = false
    var replyingTo : String?
    
    var isReply : Bool {return replyingTo != nil}
    
    enum CodingKeys: String,CodingKey {
        case caption
        case likes
        case retweets
        case uid
        case timestamp
    }
}


extension Tweet{
    
    func getDate() ->Date{
        return Date(timeIntervalSince1970: Double(timestamp))
    }
}
