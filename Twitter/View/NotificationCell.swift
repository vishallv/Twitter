//
//  NotificationCell.swift
//  Twitter
//
//  Created by Vishal Lakshminarayanappa on 5/22/20.
//  Copyright © 2020 Vishal Lakshminarayanappa. All rights reserved.
//

import UIKit

protocol NotificationCellDelegate :class {
    func handleProfileImageTapped(_ cell : NotificationCell)
    func didTapFollow(_ cell : NotificationCell)
}

class NotificationCell : UITableViewCell{
    
    //MARK: Properties
    var notification : Notification? {
        didSet{configure()}
    }
    
    weak var delegate : NotificationCellDelegate?
    
    private lazy var profileImageView : UIImageView = {
        let iv = UIImageView().createProfileImageView(size: 40)
                iv.backgroundColor = .mainBlue
        iv.isUserInteractionEnabled = true
        let tap = UITapGestureRecognizer(target: self, action: #selector(handleProfileImageTapped))
        iv.addGestureRecognizer(tap)
        return iv
    }()
    
    private let notificationLabel : UILabel = {
        let label = UILabel()
        label.numberOfLines = 2
        label.font = UIFont.systemFont(ofSize: 14)
        label.text = "Some Text"
        return label
    }()
    
    private lazy var followButton : UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("Loading", for: .normal)
        button.setTitleColor(.mainBlue, for: .normal)
        button.backgroundColor = .white
        button.layer.borderColor = UIColor.mainBlue.cgColor
        button.layer.borderWidth = 2
        button.addTarget(self, action: #selector(handleFollowTapped), for: .touchUpInside)
        return button
    }()
    
    //MARK: Life Cycle
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        selectionStyle = .none
        
        let stack = UIStackView(arrangedSubviews: [profileImageView,notificationLabel])
        stack.spacing = 8
        stack.alignment = .center
        
        addSubview(stack)
        stack.centerY(inView: self, leftAnchor: leftAnchor, paddingLeft: 12)
        stack.anchor(right : rightAnchor, paddingRight: 12)
        
        addSubview(followButton)
        followButton.centerY(inView: self)
        followButton.setDimensions(height: 32, width: 88)
        followButton.layer.cornerRadius = 32/2
        followButton.anchor(right : rightAnchor,paddingRight: 12)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    //MARK: Selector
    @objc func handleFollowTapped(){
        delegate?.didTapFollow(self)
    }
    
    @objc func handleProfileImageTapped(){
        
        delegate?.handleProfileImageTapped(self)
    }
    
    //MARK: Helper Function
    
    func configure(){
        guard let notification = notification else {return}
        guard let user = notification.user else {return}
        
        let viewModel = NotificationViewModel(notification: notification, user: user)
        
        profileImageView.setImageUsingSDWebImage(view: profileImageView, urlString: viewModel.profileImageUrl)
        notificationLabel.attributedText = viewModel.notificationText
        followButton.isHidden = viewModel.shouldHideFollowButton
        followButton.setTitle(viewModel.followButtonText, for: .normal)
    }
    
}
