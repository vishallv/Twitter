//
//  TwitterTests.swift
//  TwitterTests
//
//  Created by Vishal Lakshminarayanappa on 5/19/20.
//  Copyright © 2020 Vishal Lakshminarayanappa. All rights reserved.
//

import XCTest
import UIKit


@testable import Twitter



class TwitterTests: XCTestCase {
    
    override func setUp() {
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }
    
    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }
    
    
    
    func testUserAndTweetStructure(){
        
        
        let user = User(email: "v@v.com", fullname: "vishal", username: "vishal", profileImageURL: "xyz", id: "qwerty")
        
        let tweet = Tweet(caption: "hello", likes: 0, retweets: 0, uid: "qwerty", timestamp: 1234567, tweetId: "sdsaf", user: user)
        
        XCTAssertEqual(user.email, tweet.user?.email)
        XCTAssertEqual(user.fullname, tweet.user?.fullname)
        XCTAssertEqual(user.username, tweet.user?.username)
        XCTAssertEqual(user.profileImageURL, tweet.user?.profileImageURL)
        XCTAssertEqual(user.id, tweet.user?.id)
        
        
    }
    
    
    
    func testTweetViewModel() {
        
        let user = User(email: "v@v.com", fullname: "vishal", username: "vishal", profileImageURL: "xyz", id: "qwerty")
        let tweet = Tweet(caption: "hello", likes: 0, retweets: 0, uid: "qwerty", timestamp: 1589865919, tweetId: "sdsaf", user: user)
        let tweetViewModel = TweetViewModel(tweet: tweet, user: user)
        
        
        //MARK : Date Convertor
        let formatter = DateComponentsFormatter()
        formatter.allowedUnits = [.second,.minute,.hour,.day,.weekOfMonth]
        formatter.maximumUnitCount = 1
        formatter.unitsStyle = .abbreviated
        
        let now = Date()
        let dateStr = formatter.string(from: tweet.getDate(), to: now) ?? "0"
        
        var userInfoText : NSAttributedString {
            
            let title = NSMutableAttributedString(string: user.fullname,
                                                  attributes: [.font : UIFont.boldSystemFont(ofSize: 14)])
            title.append(NSAttributedString(string: " @\(user.username)", attributes: [.font : UIFont.systemFont(ofSize: 14),
                                                                                       .foregroundColor:UIColor.lightGray]))
            title.append(NSAttributedString(string: " ・ \(dateStr)", attributes: [.font : UIFont.systemFont(ofSize: 14),
                                                                                      .foregroundColor:UIColor.lightGray]))
            return title
        }
        
        
        
        
        XCTAssertEqual(tweetViewModel.timestamp, dateStr)
        XCTAssertEqual(user.profileImageURL, tweetViewModel.profileImageUrl)
        XCTAssertEqual(tweetViewModel.userInfoText, userInfoText)
        
        
        
    }
    
    
    
    func testUserViewModel(){
        
        let user = User(email: "v@v.com", fullname: "vishal", username: "ishal", profileImageURL: "xyz", id: "qwerty")
        
        let userViewModel = UserViewModel(user: user)
        
        
        XCTAssertEqual(user.fullname, userViewModel.fullname)
        XCTAssertEqual(user.username, userViewModel.username)
        XCTAssertEqual(user.profileImageURL, userViewModel.profileImageUrl)
    }
    
    
    
    
}
