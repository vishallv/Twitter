//
//  ProfileHeaderViewModel.swift
//  Twitter
//
//  Created by Vishal Lakshminarayanappa on 5/18/20.
//  Copyright © 2020 Vishal Lakshminarayanappa. All rights reserved.
//

import Firebase
import UIKit

enum ProfileFilterOptions : Int,CaseIterable {
    
    case tweets
    case replies
    case likes
    
    
    var description : String {
        
        switch self {
        case .tweets: return "Tweets"
        case .replies: return "Tweets & Replies"
        case .likes: return "Likes"
            
        }
    }

}


struct  ProfileHeaderViewModel {
    private let user : User
    
    
    var followingString : NSAttributedString? {
        
        return createAttributedText(withValue: user.stats?.following ?? 0, text: "following")
    }
    
    var followersString : NSAttributedString? {
        
        return createAttributedText(withValue: user.stats?.follower ?? 0, text: "followers")
    }
    
    var actionButtonTitle : String {
        if user.isCurrentUser{
            return "Edit Profile"
        }
        if !user.isFollowed && !user.isCurrentUser{
            return "Follow"
        }
        if user.isFollowed{
            return "Following"
        }
        return "Loading" 
    }
    
    
    var fullnameString : String {
        return user.fullname
    }
    
    var userNameString : String {
        
        return "@\(user.username)"
    }
    
    
    
    
    init(user : User) {
        self.user = user
    }
    
    
    private func createAttributedText(withValue value : Int, text : String) ->NSAttributedString{
        
        
        let attributedText = NSMutableAttributedString(string: "\(value)",
                                                        attributes: [.font: UIFont.boldSystemFont(ofSize: 14)])
        
        attributedText.append(NSAttributedString(string: " \(text)", attributes: [.font:UIFont.systemFont(ofSize: 14),
                                                                                  .foregroundColor:UIColor.lightGray]))
        
        
        
        return attributedText
        
    }
    
    
}
