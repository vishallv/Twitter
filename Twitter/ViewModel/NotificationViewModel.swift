//
//  NotificationViewModel.swift
//  Twitter
//
//  Created by Vishal Lakshminarayanappa on 5/22/20.
//  Copyright © 2020 Vishal Lakshminarayanappa. All rights reserved.
//

import UIKit


struct NotificationViewModel{
    
    private let notification :Notification
    private let type : NotificationType
    private let user : User
    
     var timeStampString :String? {
        let formatter = DateComponentsFormatter()
        formatter.allowedUnits = [.second,.minute,.hour,.day,.weekOfMonth]
        formatter.maximumUnitCount = 1
        formatter.unitsStyle = .abbreviated
        
        let now = Date()
        
        return formatter.string(from: notification.getDate(), to: now)
        
    }

    
    var notificationMessage : String{
        
        switch type{
            
        case .follow: return " started following you"
        case .like: return " liked one of your tweet"
        case .reply: return " replied to one of your tweet"
        case .retweet: return " retweet to one of your tweet"
        case .mention: return " mentioned you in one of your tweet"

        }
    }
    
    var shouldHideFollowButton : Bool{
        return type != .follow
    }
    
    var followButtonText : String{
        return user.isFollowed ? "Following" : "Follow"
    }
    
    var profileImageUrl : String{
        return user.profileImageURL
    }
    
    var notificationText : NSAttributedString?{
        guard let timestamp = timeStampString else {return nil}
        
        let attriString = NSMutableAttributedString(string: user.username, attributes: [.font: UIFont.boldSystemFont(ofSize: 12)])
        
        attriString.append(NSAttributedString(string: notificationMessage, attributes: [.font : UIFont.systemFont(ofSize: 12)]))
        
        attriString.append(NSAttributedString(string: " \(timestamp)", attributes: [.foregroundColor : UIColor.lightGray,
                                                                                    .font : UIFont.systemFont(ofSize: 12)]))
        return attriString
    }
    
    init(notification :Notification,user : User) {
        self.notification = notification
        self.type = notification.getType()
        self.user = user
    }
    
    
}
