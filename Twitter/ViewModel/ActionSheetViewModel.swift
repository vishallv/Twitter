//
//  ActionSheetViewModel.swift
//  Twitter
//
//  Created by Vishal Lakshminarayanappa on 5/21/20.
//  Copyright © 2020 Vishal Lakshminarayanappa. All rights reserved.
//

import Foundation

struct ActionSheetViewModel{
    
    private let user : User
    
    var options : [ActionSheetOption]{
        
        var results = [ActionSheetOption]()
        
        if user.isCurrentUser{
            results.append(.delete)
            
        }
        else{
            let followOption : ActionSheetOption = user.isFollowed ? .unfollow(user) : .follow(user)
            results.append(followOption)
        }
        results.append(.report)
        
        return results
    }
    
    init(user : User) {
        self.user = user
    }
}

enum ActionSheetOption{
    
    case follow(User)
    case unfollow(User)
    case delete
    case report
    
    var description : String{
        switch self{
            
        case .follow(let user):
            return "Follow @\(user.username)"
        case .unfollow(let user):
            return "Unfollow @\(user.username)"
        case .delete:
            return "Delete Tweet"
        case .report:
            return "Report Tweet"

        }
    }
}
