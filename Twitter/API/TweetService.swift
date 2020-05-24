//
//  TweetService.swift
//  Twitter
//
//  Created by Vishal Lakshminarayanappa on 5/17/20.
//  Copyright © 2020 Vishal Lakshminarayanappa. All rights reserved.
//

import Foundation
import Firebase

struct TweetService {
    static let shared = TweetService()
    private init() {}
    
    func uploadTweet(caption : String,type: UploadTweetConfiguration,completion : @escaping(Error?,DatabaseReference)->Void) {
        
        guard let uid = Auth.auth().currentUser?.uid else {return}
        
        var values = ["uid":uid,
                      "timestamp": Int(NSDate().timeIntervalSince1970),
                      "likes":0,
                      "retweets":0,
                      "caption":caption] as [String:Any]
        
        
        
        switch type{
            
        case .tweet:
            let ref = REF_TWEETS.childByAutoId()
            ref.updateChildValues(values) { (err, ref) in
                guard let tweetId = ref.key else {return}
                
                REF_USER_TWEETS.child(uid).updateChildValues([tweetId:1], withCompletionBlock: completion)
            }
            
        case.reply(let tweet):
            guard let username = tweet.user?.username else {return}
            values["replyingTo"] = username
            guard let tweetID = tweet.tweetId else {return}
            REF_TWEETS_REPLY.child(tweetID).childByAutoId().updateChildValues(values) { (err, ref) in
                
                guard let replyKey = ref.key else {return}
                REF_USER_REPLIES.child(uid).updateChildValues([tweetID:replyKey], withCompletionBlock: completion)
            }
            
        }
        
        
        
        
    }
    
    func fetchReplies(forUser user : User,completion : @escaping([Tweet])->Void){
        var replies = [Tweet]()
        
        REF_USER_REPLIES.child(user.getUID()).observe(.childAdded) { (snapshot) in
            
            let tweetID = snapshot.key
            guard let replyKey = snapshot.value as? String else {
                
                return}
            
            
            
            
            REF_TWEETS_REPLY.child(tweetID).child(replyKey).observeSingleEvent(of: .value) { (snapshot) in
                guard let snapData = snapshot.value else {return}
                let tweetID = snapshot.key
                guard let snap = snapshot.value as? [String:Any] else {return}
                do{
                    
                    let data = try JSONSerialization.data(withJSONObject: snapData, options: [])
                    
                    var tweet = try JSONDecoder().decode(Tweet.self, from: data)
                    
                    UserService.shared.fetchUser(uid: tweet.uid) { (user : User?, uniqueId) in
                        
                        
                        guard var user = user else {return}
                        user.id = uniqueId
                        
                        tweet.tweetId = tweetID
                        tweet.user = user
                        if let username = snap["replyingTo"] as? String{
                            
                            tweet.replyingTo = username
                        }
                        
                        replies.append(tweet)
                        completion(replies)
                        
                    }
                    
                    
                }
                catch let error{
                    print(error)
                }
            }
            
        }
    }
    
    
    func fetchTweet(completion: @escaping([Tweet]?)->Void){
        
        
        var tweets = [Tweet]()
        guard let uid = Auth.auth().currentUser?.uid else {return}

        REF_USER_FOLLOWING.child(uid).observe(.childAdded) { (snapshot) in
            let userID = snapshot.key

            REF_USER_TWEETS.child(userID).observe(.childAdded) { (snapshot1) in
                
                let tweetID = snapshot1.key
                
                self.fetchOneTweet(withTweeID: tweetID) { (tweet) in
                    guard let tweet = tweet else {return}
                    tweets.append(tweet)
                    completion(tweets)
                }
            }
        }
        
        REF_USER_TWEETS.child(uid).observe(.childAdded) { (snapshot1) in
            
            let tweetID = snapshot1.key
            
            self.fetchOneTweet(withTweeID: tweetID) { (tweet) in
                guard let tweet = tweet else {return}
                tweets.append(tweet)
                completion(tweets)
            }
        }
        
//        REF_TWEETS.observe(.childAdded) { (snapshot) in
//
//            guard let snapData = snapshot.value else {return}
//            let tweetID = snapshot.key
//            do{
//
//                let data = try JSONSerialization.data(withJSONObject: snapData, options: [])
//
//                var tweet = try JSONDecoder().decode(Tweet.self, from: data)
//
//                UserService.shared.fetchUser(uid: tweet.uid) { (user : User?, uniqueId) in
//
//
//                    guard var user = user else {return}
//                    user.id = uniqueId
//
//                    tweet.tweetId = tweetID
//                    tweet.user = user
//
//                    tweets.append(tweet)
//                    completion(tweets)
//
//                }
//
//
//            }
//            catch let error{
//                print(error)
//            }
//        }
        
        
    }
    
    func fetchSingleUserTweets(forUser user : User,completion : @escaping([Tweet]?)->Void){
        
        guard let uid = user.id else {return}
        
        var tweets = [Tweet]()
        
        REF_USER_TWEETS.child(uid).observe(.childAdded) { (snapshot) in
            
            let tweetID = snapshot.key
            REF_TWEETS.child(tweetID).observeSingleEvent(of: .value) { (snapshot) in
                
                guard let snapData = snapshot.value else {return}
                
                
                
                
                do{
                    
                    let data = try JSONSerialization.data(withJSONObject: snapData, options: [])
                    
                    var tweet = try JSONDecoder().decode(Tweet.self, from: data)
                    
                    UserService.shared.fetchUser(uid: tweet.uid) { (user : User?, uniqueId) in
                        
                        
                        guard var user = user else {return}
                        user.id = uniqueId
                        
                        tweet.tweetId = tweetID
                        tweet.user = user
                        
                        tweets.append(tweet)
                        completion(tweets)
                        
                    }
                    
                    
                }
                catch let error{
                    print(error)
                }
                
            }
            
        }
    }
    
    func fetchReplies(forTweet tweet : Tweet, completion : @escaping([Tweet])->Void){
        var tweets = [Tweet]()
        guard let tweetUId = tweet.tweetId else {return}
        
        REF_TWEETS_REPLY.child(tweetUId).observe(.childAdded) { (snapshot) in
            
            let tweetID = snapshot.key
            guard let snapData = snapshot.value else {return}
            
            
            
            
            
            
            do{
                print("came here")
                let data = try JSONSerialization.data(withJSONObject: snapData, options: [])
                
                var tweet = try JSONDecoder().decode(Tweet.self, from: data)
                
                UserService.shared.fetchUser(uid: tweet.uid) { (user : User?, uniqueId) in
                    
                    
                    guard var user = user else {return}
                    user.id = uniqueId
                    
                    tweet.tweetId = tweetID
                    tweet.user = user
                    
                    tweets.append(tweet)
                    completion(tweets)
                    
                }
                
                
            }
            catch let error{
                print(error)
            }
        }
    }
    
    func likeTweet(tweet : Tweet ,completion : @escaping(DatabaseCompletion)){
        guard let uid = Auth.auth().currentUser?.uid else {return}
        guard let tweetID = tweet.tweetId else {return}
        let likes = tweet.didLike ? tweet.likes - 1 : tweet.likes + 1
        
        REF_TWEETS.child(tweetID).child("likes").setValue(likes)
        
        if tweet.didLike{
            REF_USER_LIKES.child(uid).child(tweetID).removeValue { (err, ref) in
                REF_TWEET_LIKES.child(tweetID).child(uid).removeValue(completionBlock: completion)
            }
            
        }else{
            REF_USER_LIKES.child(uid).updateChildValues([tweetID:1]) { (err, ref) in
                REF_TWEET_LIKES.child(tweetID).updateChildValues([uid:1], withCompletionBlock: completion)
            }
        }
    }
    
    func checkIfUserLikedTweet(tweet : Tweet,completion : @escaping(Bool)->Void){
        guard let uid = Auth.auth().currentUser?.uid else {return}
        guard let tweetId = tweet.tweetId else {return}
        REF_USER_LIKES.child(uid).child(tweetId).observeSingleEvent(of: .value) { (snapshot) in
            completion(snapshot.exists())
        }
    }
    func fetchLikes(forUser user : User,completion : @escaping([Tweet])->Void){
        var tweets = [Tweet]()
        
        REF_USER_LIKES.child(user.getUID()).observe(.childAdded) { (snapshot) in
            let tweetID = snapshot.key
            
            self.fetchOneTweet(withTweeID: tweetID) { (tweet) in
                
                guard var tweet = tweet else {return}
                tweet.didLike = true
                tweets.append(tweet)
                completion(tweets)
            }
        }
    }
    
    
    func fetchOneTweet(withTweeID tweetID : String,completion : @escaping(Tweet?)->Void){
        
        REF_TWEETS.child(tweetID).observeSingleEvent(of: .value) { (snapshot) in
            
            
            guard let snapData = snapshot.value else {return}
            do{
                
                let data = try JSONSerialization.data(withJSONObject: snapData, options: [])
                
                var tweet = try JSONDecoder().decode(Tweet.self, from: data)
                
                UserService.shared.fetchUser(uid: tweet.uid) { (user : User?, uniqueId) in
                    
                    
                    guard var user = user else {return}
                    user.id = uniqueId
                    
                    tweet.tweetId = tweetID
                    tweet.user = user
                    
                    completion(tweet)
                    
                }
                
                
            }
            catch let error{
                print(error)
            }
            
            
        }
    }
}
