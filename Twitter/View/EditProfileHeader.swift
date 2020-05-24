//
//  EditProfileHeader.swift
//  Twitter
//
//  Created by Vishal Lakshminarayanappa on 5/23/20.
//  Copyright © 2020 Vishal Lakshminarayanappa. All rights reserved.
//

import UIKit

protocol EditProfileHeaderDelegate : class {
    func didTapProfilePhoto()
}

class EditProfileHeader : UIView{
    
    //MARK: Properties
    private let user : User
    
    weak var delegate : EditProfileHeaderDelegate?
    
     let profileImageView : UIImageView = {
        let iv = UIImageView().createProfileImageView(size: 100)
        iv.layer.borderColor = UIColor.white.cgColor
        iv.layer.borderWidth = 4
        iv.backgroundColor = .lightGray
        return iv
    }()
    
    private let changeImageButton : UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("Change profile Image", for: .normal)
        button.titleLabel?.font = UIFont.boldSystemFont(ofSize: 14)
        button.setTitleColor(.white, for: .normal)
        button.addTarget(self, action: #selector(handleChangeProfileButton), for: .touchUpInside)
        return button
    }()
    
    
    
    //MARK: Life Cycle
    init(user : User) {
        self.user = user
        super.init(frame: .zero)
        
        backgroundColor = .mainBlue
        
        addSubview(profileImageView)
        profileImageView.centerX(inView: self)
//        profileImageView.centerY(inView: self)
        profileImageView.centerYAnchor.constraint(equalTo: self.centerYAnchor, constant: -16).isActive = true
        
        addSubview(changeImageButton)
        changeImageButton.centerX(inView: self)
        changeImageButton.anchor(top: profileImageView.bottomAnchor,paddingTop: 8)
        profileImageView.setImageUsingSDWebImage(view: profileImageView, urlString: user.profileImageURL)
        
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    //MARK: Selector
    @objc func handleChangeProfileButton(){
        
        delegate?.didTapProfilePhoto()
    }
    
    //MARK: Helper Function

    
}
