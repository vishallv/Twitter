//
//  ProfileHeader.swift
//  Twitter
//
//  Created by Vishal Lakshminarayanappa on 5/18/20.
//  Copyright © 2020 Vishal Lakshminarayanappa. All rights reserved.
//

import UIKit


protocol ProfileHeaderDelegate : class {
    
    func dismissController()
    func handleEditProfileFollow(_ header : ProfileHeader)
    func didSelected(filter : ProfileFilterOptions)
}

class ProfileHeader : UICollectionReusableView{
    
    static let reuseIdentifier = "ProfileHeaderIdentifier"
    //MARK: Properties
    
    var user : User?{
        didSet{
            configure()
        }
        
    }
    
    private let filterBar = ProfileFilterView()
    weak var delegate : ProfileHeaderDelegate?
    
//    private let underlineView : UIView = {
//        let view = UIView()
//        view.backgroundColor = .mainBlue
//        return view
//        
//    }()
    
    private lazy var containerView : UIView = {
        let view = UIView()
        view.backgroundColor = .mainBlue
        
        view.addSubview(backButton)
        backButton.anchor(top: view.topAnchor,left: view.leftAnchor,
                          paddingTop: 42,paddingLeft: 16,
                          width: 30,height: 30)
        
        return view
    }()
    
    private let profileImageView : UIImageView = {
        let iv = UIImageView().createProfileImageView(size: 80)
        iv.layer.borderColor = UIColor.white.cgColor
        iv.layer.borderWidth = 4
        iv.backgroundColor = .lightGray
        return iv
    }()
    
     lazy var editProfileFollowButton : UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("Loading", for: .normal)
        button.setTitleColor(.mainBlue, for: .normal)
        button.titleLabel?.font = UIFont.systemFont(ofSize: 14)
        button.layer.borderColor = UIColor.mainBlue.cgColor
        button.layer.borderWidth = 1.25
        button.addTarget(self, action: #selector(handleEditProfileFollow), for: .touchUpInside)
        return button
    }()
    
    private let fullNameLabel : UILabel = {
        let label = UILabel()
        label.text = "Vishal"
        label.font = UIFont.boldSystemFont(ofSize: 20)
        return label
    }()
    
    private let userNameLabel : UILabel = {
        let label = UILabel()
        label.text = "@vishal"
        label.font = UIFont.systemFont(ofSize: 16)
        return label
    }()
    
    private let bioLabel : UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 16)
        label.numberOfLines = 3
        label.text = "This is my Account"
        return label
    }()
    
    private let followingLabel : UILabel = {
        let label = UILabel()
        label.text = "0 Following"
        let followingTapped = UITapGestureRecognizer(target: self, action: #selector(handleFollowingTapped))
        label.addGestureRecognizer(followingTapped)
        label.isUserInteractionEnabled = true
        
        
        return label
    }()
    
    private let followersLabel : UILabel = {
        let label = UILabel()
        label.text = "0 Follow"
        let followTapped = UITapGestureRecognizer(target: self, action: #selector(handleFollowTapped))
        label.addGestureRecognizer(followTapped)
        label.isUserInteractionEnabled = true
        
        
        return label
    }()
    
    private lazy var backButton : UIButton = {
        let button = UIButton(type: .system)
        button.setImage(#imageLiteral(resourceName: "baseline_arrow_back_white_24dp").withRenderingMode(.alwaysOriginal), for: .normal)
        button.addTarget(self, action: #selector(handleBackButtonPressed), for: .touchUpInside)
        
        return button
    }()
    
    //MARK: Life Cycle
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        filterBar.delegate = self
        
        backgroundColor = .white
        addSubview(containerView)
        containerView.anchor(top : topAnchor,left: leftAnchor,right: rightAnchor,
                             height: 108)
        
        addSubview(profileImageView)
        profileImageView.anchor(top: containerView.bottomAnchor,left: leftAnchor,
                                paddingTop: -24,paddingLeft: 8)
        
        addSubview(editProfileFollowButton)
        editProfileFollowButton.anchor(top :containerView.bottomAnchor,right: rightAnchor,
                                       paddingTop: 12,paddingRight: 12,width: 100,height: 36)
        editProfileFollowButton.layer.cornerRadius = 36/2
        
        let stack = UIStackView(arrangedSubviews: [fullNameLabel, userNameLabel, bioLabel])
        stack.axis = .vertical
        stack.spacing = 4
        stack.distribution = .fillProportionally
        
        addSubview(stack)
        stack.anchor(top:profileImageView.bottomAnchor, left: leftAnchor, right: rightAnchor,
                     paddingTop: 8,paddingLeft: 12,paddingRight: 12)
        
        
        let followStack = UIStackView(arrangedSubviews: [followingLabel,followersLabel])
        followStack.axis = .horizontal
        followStack.spacing = 8
        followStack.distribution = .fillEqually
        
        addSubview(followStack)
        followStack.anchor(top: stack.bottomAnchor,left: leftAnchor,
                           paddingTop: 8,paddingLeft: 12)
        
        addSubview(filterBar)
        filterBar.anchor(left:leftAnchor, bottom: bottomAnchor, right: rightAnchor,height: 50)
        
//        addSubview(underlineView)
//        underlineView.anchor(left: leftAnchor, bottom: bottomAnchor, width: frame.width/3,height: 2)
        
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    //MARK: Selector
    
    @objc func handleFollowingTapped(){
        
    }
    @objc func handleFollowTapped(){
           
       }
    
    @objc func handleEditProfileFollow(){
        
        delegate?.handleEditProfileFollow(self)
        
    }
    
    @objc func handleBackButtonPressed(){
        
        delegate?.dismissController()
        
    }
    
    //MARK: Helper Function
    
    func configure(){
        
        guard let user = user else {return}
        
        let viewModel = ProfileHeaderViewModel(user: user)
        followersLabel.attributedText = viewModel.followersString
        followingLabel.attributedText = viewModel.followingString
        fullNameLabel.text = viewModel.fullnameString
        userNameLabel.text = viewModel.userNameString
        editProfileFollowButton.setTitle(viewModel.actionButtonTitle, for: .normal)
        
        
        
        profileImageView.setImageUsingSDWebImage(view: profileImageView, urlString: user.profileImageURL)
    }
}


extension ProfileHeader : ProfileFilterViewDelegate{
    func filterView(_ view: ProfileFilterView, didSelect indexPath: IndexPath) {
//        guard let cell = view.collectionView.cellForItem(at: indexPath) as? ProfileFilterCell else {return}
//        
//        let xPosition = cell.frame.origin.x
//        
//        UIView.animate(withDuration: 0.3) {
//            self.underlineView.frame.origin.x = xPosition
//        }
        guard let filter = ProfileFilterOptions(rawValue: indexPath.row) else {return}
        
        delegate?.didSelected(filter: filter)
    }
    
    
}
