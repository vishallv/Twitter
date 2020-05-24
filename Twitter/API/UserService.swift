//
//  UserService.swift
//  Twitter
//
//  Created by Vishal Lakshminarayanappa on 5/16/20.
//  Copyright © 2020 Vishal Lakshminarayanappa. All rights reserved.
//

import Foundation
import Firebase

typealias DatabaseCompletion = (Error?,DatabaseReference)->Void

struct UserService {
    static let shared = UserService()
    private init() {}
    
    
    
    func fetchUser<T:Decodable>(uid : String,completion : @escaping(T?,String)->Void){
        REF_USERS.child(uid).observeSingleEvent(of: .value) { (snapshot) in
            guard let dataSnapshot = snapshot.value else {return}
            do {
                let data = try JSONSerialization.data(withJSONObject: dataSnapshot, options: [])
                let user = try JSONDecoder().decode(T.self, from: data)
                completion(user,uid)
            }
            catch {
                print("error")
            }
        }
    }
    
    
    func fetchUsers(completion : @escaping([User]?)->Void){
        var users = [User]()
        REF_USERS.observe(.childAdded) { (snapshot) in
            let uid = snapshot.key
            guard let dataSnapshot = snapshot.value else {return}
            do {
                let data = try JSONSerialization.data(withJSONObject: dataSnapshot, options: [])
                var user = try JSONDecoder().decode(User.self, from: data)
                user.id = uid
                users.append(user)
                completion(users)
            }
            catch {
                print("error")
            }
        }
    }
    
    func followUser(uid : String,completion : @escaping(Error?,DatabaseReference)->Void){
        guard let currentUID = Auth.auth().currentUser?.uid else {return}
        
        REF_USER_FOLLOWING.child(currentUID).updateChildValues([uid:1]) { (err, ref) in
            
            REF_USER_FOLLOWERS.child(uid).updateChildValues([currentUID:1], withCompletionBlock: completion)
        }
    }
    
    func unfollowUser(uid : String,completion : @escaping(DatabaseCompletion)){
        guard let currentUID = Auth.auth().currentUser?.uid else {return}
        
        REF_USER_FOLLOWING.child(currentUID).child(uid).removeValue { (err, ref) in
            
            REF_USER_FOLLOWERS.child(uid).child(currentUID).removeValue(completionBlock: completion)
        }
    }
    
    func checkIfUserIsFollowed(uid :String ,completion : @escaping(Bool)->Void){
         guard let currentUID = Auth.auth().currentUser?.uid else {return}
        
        REF_USER_FOLLOWING.child(currentUID).child(uid).observeSingleEvent(of: .value) { (snapshot) in
            completion(snapshot.exists())
        }
        
    }
    
    func fetchUserStat(uid: String,completion: @escaping(UserStatRelation?)->Void){
        
        
        REF_USER_FOLLOWERS.child(uid).observeSingleEvent(of: .value) { (snapshot) in
            
            let follower = snapshot.children.allObjects.count
            
            REF_USER_FOLLOWING.child(uid).observeSingleEvent(of: .value) { (snapshotRef) in
                let following = snapshotRef.children.allObjects.count
                
                let stat = UserStatRelation(follower: follower, following: following)
                completion(stat)
                
            }
        }
    }
    
    func updateProfileImage(image : UIImage,completion : @escaping(String)->Void){
        guard let imageData = image.jpegData(compressionQuality: 0.3) else {return}
        guard let uid = Auth.auth().currentUser?.uid else {return}
        
        let fileName = NSUUID().uuidString
        
        let ref = STORAGE_PROFILE_IMAGES.child(fileName)
        
        ref.putData(imageData, metadata: nil) { (data, err) in
            
            ref.downloadURL { (url, err) in
                guard let profileImageURL = url?.absoluteString else {return}
                
                let values = ["profileImageURL":profileImageURL]
                
                REF_USERS.child(uid).updateChildValues(values) { (err, ref) in
                    completion(profileImageURL)
                }
            }
            
        }
        
    }
    func saveUserData(user : User, completion : @escaping(DatabaseCompletion)){
        
        guard let uid = Auth.auth().currentUser?.uid else {return}
        
        let value = ["fullname": user.fullname,
                     "username": user.username,
        "bio": user.bio ?? ""] as [String:Any]
        
        REF_USERS.child(uid).updateChildValues(value, withCompletionBlock: completion)
    }
    
    func fetchUserForMention(withUsername username : String, completion : @escaping(User)->Void){
        print(username)
        REF_USER_USERNAMES.child(username).observe(.value) { (snapshot) in
            guard let uid = snapshot.value as? String else {return}
            self.fetchUser(uid: uid) { (user: User?, uid) in
                
                guard var user = user else {return}
                user.id = uid
                
                completion(user)
            }
        }
        
    }
}
