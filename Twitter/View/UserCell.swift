//
//  UserCell.swift
//  Twitter
//
//  Created by Vishal Lakshminarayanappa on 5/19/20.
//  Copyright © 2020 Vishal Lakshminarayanappa. All rights reserved.
//

import UIKit

class UserCell :UITableViewCell{
    
    static let resuerIdentifier = "UserCellIndentifier"
    
    
    //MARK: Properties
    var user : User? {
        didSet{
            configure()
        }
    }
    
    private let profileImageView : UIImageView = {
        let iv = UIImageView().createProfileImageView(size: 40)
        iv.backgroundColor = .mainBlue
        return iv
    }()
    
    
    private let usernameLabel : UILabel = {
        let label = UILabel()
        label.font = UIFont.boldSystemFont(ofSize: 14)
        label.text = "Username"
        return label
    }()
    
    private let fullnameLabel : UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 14)
        label.text = "Fullname"
        return label
    }()
    //MARK: Life Cycle
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        selectionStyle = .none
        backgroundColor = .white
        
        addSubview(profileImageView)
        profileImageView.centerY(inView: self, constant: 0, leftAnchor: leftAnchor, paddingLeft: 12)
        
        let stack = UIStackView(arrangedSubviews: [usernameLabel, fullnameLabel])
        stack.axis = .vertical
        stack.spacing = 2
        
        addSubview(stack)
        stack.centerY(inView: profileImageView, constant: 0, leftAnchor: profileImageView.rightAnchor, paddingLeft: 12)
        
        
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
        
        
    }
    
    //MARK: Selector
    
    //MARK: Helper Function
    
    func configure(){
        
        guard let user = user else{return}
        
        let userViewModel = UserViewModel(user: user)
        profileImageView.setImageUsingSDWebImage(view: profileImageView, urlString: userViewModel.profileImageUrl)
        fullnameLabel.text = userViewModel.fullname
        usernameLabel.text = userViewModel.username
    }
    
}
