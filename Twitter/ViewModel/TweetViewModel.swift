//
//  TweetViewModel.swift
//  Twitter
//
//  Created by Vishal Lakshminarayanappa on 5/17/20.
//  Copyright © 2020 Vishal Lakshminarayanappa. All rights reserved.
//

import UIKit

struct TweetViewModel {
    let tweet : Tweet
    let user : User
    
    
    var profileImageUrl : String{
        
        return user.profileImageURL
    }
    
    var usernameText : String{
        
        return "@\(user.username)"
    }
    
    var shouldHideReply : Bool{
        return !tweet.isReply
    }
    var replyText : String? {
        guard let text = tweet.replyingTo else {return nil}
        return "→ replying to @\(text)"
    }
    
    var timestamp : String{
        
        let formatter = DateComponentsFormatter()
        formatter.allowedUnits = [.second,.minute,.hour,.day,.weekOfMonth]
        formatter.maximumUnitCount = 1
        formatter.unitsStyle = .abbreviated
        
        let now = Date()
        
        return formatter.string(from: tweet.getDate(), to: now) ?? "0"
    }
    var userInfoText : NSAttributedString {
        
        let title = NSMutableAttributedString(string: user.fullname,
                                              attributes: [.font : UIFont.boldSystemFont(ofSize: 14)])
        
        title.append(NSAttributedString(string: " @\(user.username)", attributes: [.font : UIFont.systemFont(ofSize: 14),
                                                                                   .foregroundColor:UIColor.lightGray]))
        
        title.append(NSAttributedString(string: " ・ \(timestamp)", attributes: [.font : UIFont.systemFont(ofSize: 14),
                                                                                  .foregroundColor:UIColor.lightGray]))
        
        return title
        
    }
    
    var retweetAttributedString : NSAttributedString?{
        
        return createAttributedText(withValue: tweet.retweets, text: "Retweets")
    }
    
    var likesAttributedString : NSAttributedString?{
        return createAttributedText(withValue: tweet.likes, text: "Likes")
    }
    
    var headerTimeStamp : String {
        let formatter = DateFormatter()
        formatter.dateFormat = "h:mm a ・ MM/dd/yyyy"
        return formatter.string(from: tweet.getDate())
        
    }
    var likeButtonTintColor : UIColor{
        return tweet.didLike ? .red : .lightGray
    }
    
    var likeButtonImage : UIImage{
        let imageName = tweet.didLike ? "like_filled" : "like"
        return UIImage(named: imageName)!
    }
    
    private func createAttributedText(withValue value : Int, text : String) ->NSAttributedString{
        
        
        let attributedText = NSMutableAttributedString(string: "\(value)",
            attributes: [.font: UIFont.boldSystemFont(ofSize: 14)])
        
        attributedText.append(NSAttributedString(string: " \(text)", attributes: [.font:UIFont.systemFont(ofSize: 14),
                                                                                  .foregroundColor:UIColor.lightGray]))
        
        
        
        return attributedText
        
    }
    
    func size(forWidth width : CGFloat) -> CGSize{
        
        let measurementLabel = UILabel()
        measurementLabel.text = tweet.caption
        measurementLabel.numberOfLines = 0
        measurementLabel.lineBreakMode = .byWordWrapping
        measurementLabel.translatesAutoresizingMaskIntoConstraints = false
        measurementLabel.widthAnchor.constraint(equalToConstant: width).isActive = true
        
        return measurementLabel.systemLayoutSizeFitting(UIView.layoutFittingCompressedSize)
        
    }
    
    
    init(tweet: Tweet,user : User) {
        self.tweet = tweet
        self.user = user
    }
}
