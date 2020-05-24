//
//  NotificationService.swift
//  Twitter
//
//  Created by Vishal Lakshminarayanappa on 5/22/20.
//  Copyright © 2020 Vishal Lakshminarayanappa. All rights reserved.
//

import Foundation
import Firebase

struct NotificationService {
    
    static let shared = NotificationService()
    
    private init() {}
    
    func uploadNotification(type : NotificationType,tweet : Tweet? = nil, user : User? = nil){
        guard let uid = Auth.auth().currentUser?.uid else {return}
        
        var value : [String:Any] = ["timestamp" : Int(NSDate().timeIntervalSince1970),
                                    "uid":uid,
                                    "type":type.rawValue]
        
        
        if let tweet = tweet{
            value["tweetID"] = tweet.tweetId
            guard let userid = tweet.user?.getUID() else {return}
            REF_NOTIFICATIONS.child(userid).childByAutoId().updateChildValues(value)
        }
        else if let user = user  {
            REF_NOTIFICATIONS.child(user.getUID()).childByAutoId().updateChildValues(value)
        }
    }
    
    func fetchNotification(completion: @escaping([Notification]?)->Void){
        var notifications = [Notification]()
        guard let uid = Auth.auth().currentUser?.uid else {return}
        
        REF_NOTIFICATIONS.child(uid).observe(.childAdded) { (snapshot) in
            
            guard let dict = snapshot.value as? [String:Any] else {return}
            guard let data = snapshot.value else {return}

            do{
                
                let serialData = try JSONSerialization.data(withJSONObject: data, options: [])
                
                var notification = try JSONDecoder().decode(Notification.self, from: serialData)
                
                
                UserService.shared.fetchUser(uid: notification.uid) { (user : User?, uid) in
                    guard var user = user else {return}
                    user.id = uid
                    if let tweetID = dict["tweetID"] as? String{
                    notification.tweetID = tweetID
                    }
                    notification.user = user
                    notifications.append(notification)
                    completion(notifications)
                    
                }
                
            }catch{
                
                print(error)
            }
            
            
            
        }
    }
    
}
