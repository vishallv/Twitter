//
//  EditProfileViewModel.swift
//  Twitter
//
//  Created by Vishal Lakshminarayanappa on 5/23/20.
//  Copyright © 2020 Vishal Lakshminarayanappa. All rights reserved.
//

import Foundation

enum EditProfileOption : Int, CaseIterable{
    
    case fullname
    case username
    case bio
    
    var description : String{
        switch self{
        
        
        case .fullname:
            return "Full Name"
        case .username:
            return "Username"
        case .bio:
            return "Bio"
        }
    }
}


struct EditProfileViewModel {
    private var user : User
    var type :EditProfileOption
    
    var shouldHideTextField: Bool {
        return type == .bio ? true : false
    }
    
    var shouldHideBioView: Bool {
        return type == .bio ? false : true
    }
    
    var titleLabelText : String{
        return type.description
    }
    
    var optionValue : String {
        
        switch type{
            
        case .fullname:
            return "\(user.fullname)"
        case .username:
            return "\(user.username)"
        case .bio:
            return (user.bio) ?? ""

        }
    }
    
    
    init(user : User, type : EditProfileOption) {
        self.user = user
        self.type = type
    }
    
}
