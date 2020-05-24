//
//  Constants.swift
//  Twitter
//
//  Created by Vishal Lakshminarayanappa on 5/16/20.
//  Copyright © 2020 Vishal Lakshminarayanappa. All rights reserved.
//

import Firebase


//MARK: Storage Reference

let STORAGE_REF = Storage.storage().reference()
let STORAGE_PROFILE_IMAGES = STORAGE_REF.child("profile_images")


//MARK: Database Referaence

let DB_REF = Database.database().reference()
let REF_USERS = DB_REF.child("users")

//MARK: Tweets Service

let REF_TWEETS = DB_REF.child("tweets")

//MARK: USER TWEETS

let REF_USER_TWEETS = DB_REF.child("user-tweets")

let REF_USER_FOLLOWERS = DB_REF.child("user-follower")
let REF_USER_FOLLOWING = DB_REF.child("user-following")

let REF_TWEETS_REPLY = DB_REF.child("tweets-reply")

let REF_USER_LIKES = DB_REF.child("user-likes")
let REF_TWEET_LIKES = DB_REF.child("tweet-likes")
let REF_NOTIFICATIONS = DB_REF.child("notifications")
let REF_USER_REPLIES = DB_REF.child("user-replies")
let REF_USER_USERNAMES = DB_REF.child("user-usernames")
