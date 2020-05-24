//
//  UserViewModel.swift
//  Twitter
//
//  Created by Vishal Lakshminarayanappa on 5/19/20.
//  Copyright © 2020 Vishal Lakshminarayanappa. All rights reserved.
//

import Foundation


struct UserViewModel {
    
    let user : User
    
    var profileImageUrl : String {
        return user.profileImageURL
    }
    var fullname : String{
       return  user.fullname
    }
    
    var username : String {
        return user.username
    }
    
    init(user :User) {
        self.user = user
    }
    
}
