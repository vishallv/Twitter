//
//  UploadTweetViewModel.swift
//  Twitter
//
//  Created by Vishal Lakshminarayanappa on 5/21/20.
//  Copyright © 2020 Vishal Lakshminarayanappa. All rights reserved.
//

import UIKit


struct UploadTweetViewModel {
    let actionButtonTitle : String
    let placeHolderText : String
    var shouldShowReplyLabel : Bool
    var replyText : String?
    
    
    init(config : UploadTweetConfiguration) {
        switch config{
            
        case .tweet:
            actionButtonTitle = "Tweet"
            placeHolderText = "What's Happening"
            shouldShowReplyLabel = false
        case .reply(let tweet):
            actionButtonTitle = "Reply"
            placeHolderText = "Tweet your Reply"
            shouldShowReplyLabel = true
            guard let user = tweet.user else {return}
            replyText = "Replying to @\(user.username)"

        }
    }
    
}
