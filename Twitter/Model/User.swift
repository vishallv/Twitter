//
//  User.swift
//  Twitter
//
//  Created by Vishal Lakshminarayanappa on 5/16/20.
//  Copyright © 2020 Vishal Lakshminarayanappa. All rights reserved.
//

import Foundation
import Firebase


struct  User : Decodable {
    let email : String
    var fullname : String
    var username : String
    var profileImageURL : String
    var id : String?
    var isFollowed = false
    var stats : UserStatRelation?
    var bio : String?
    
    
    
    
    
    
    enum CodingKeys: String,CodingKey {
        case email
        case fullname
        case username
        case profileImageURL
        case bio
    }
    
   
}

extension User {
    
    var isCurrentUser : Bool{

        return Auth.auth().currentUser?.uid == id
    }
    
    func getUID() ->String{
        
        return id != nil ? id! : ""
    }
    
}

struct UserStatRelation {
    let follower : Int
    let following : Int
}
