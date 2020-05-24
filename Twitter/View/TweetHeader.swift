//
//  TweetHeader.swift
//  Twitter
//
//  Created by Vishal Lakshminarayanappa on 5/20/20.
//  Copyright © 2020 Vishal Lakshminarayanappa. All rights reserved.
//

import UIKit
import ActiveLabel

protocol TweetHeaderDelegate : class {
    func showActionSheet()
    func handleFetchUser(withUsername username : String)
}

class TweetHeader :UICollectionReusableView{
    
    static let reuseIdentifier = "TweetHeaderCell"
    //MARK: Properties
    
    var tweet : Tweet?{
        
        didSet{
            configure()
        }
    }
    weak var delegate : TweetHeaderDelegate?
    
    private let profileImageView : UIImageView = {
        let iv = UIImageView().createProfileImageView(size: 48)
        iv.isUserInteractionEnabled = true
        let tap = UITapGestureRecognizer(target: self, action: #selector(handleProfileImageTapped))
        iv.addGestureRecognizer(tap)
        return iv
    }()
    
    private let replyLabel : ActiveLabel = {
        let label = ActiveLabel()
        label.textColor = .lightGray
        label.mentionColor = .mainBlue
        label.font = UIFont.systemFont(ofSize:  12)
        //        label.text  = "→ replying to joker"
        return label
    }()
    
    private let fullNameLabel : UILabel = {
        let label = UILabel()
        label.text = "Vishal"
        label.font = UIFont.boldSystemFont(ofSize: 14)
        return label
    }()
    
    private let userNameLabel : UILabel = {
        let label = UILabel()
        label.text = "@vishal"
        label.font = UIFont.systemFont(ofSize: 14)
        return label
    }()
    
    private let captionLabel : ActiveLabel = {
        let label = ActiveLabel()
        label.mentionColor = .mainBlue
        label.hashtagColor = .mainBlue
        label.numberOfLines = 0
        label.font = UIFont.systemFont(ofSize: 20)
        return label
    }()
    
    private let dateLabel : UILabel = {
        let label = UILabel()
        label.text = "6:33 PM"
        label.textColor = .lightGray
        label.textAlignment = .left
        label.font = UIFont.systemFont(ofSize: 14)
        return label
    }()
    
    private lazy var optionButton : UIButton = {
        let button = UIButton()
        button.setImage(#imageLiteral(resourceName: "down_arrow_24pt"), for: .normal)
        button.tintColor = .lightGray
        button.addTarget(self, action: #selector(handleOptionPressed), for: .touchUpInside)
        return button
    }()
    
    private let retweetLabel : UILabel = {
        let label = UILabel()
        label.text = "2 Retweets"
        label.font = UIFont.systemFont(ofSize: 14)
        return label
    }()
    private let likesLabel : UILabel = {
        let label = UILabel()
        label.text = "2 Likes"
        label.font = UIFont.systemFont(ofSize: 14)
        return label
    }()
    
    private lazy var statView : UIView = {
        
        let view = UIView()
        
        let divider1 = UIView()
        divider1.backgroundColor = .systemGroupedBackground
        view.addSubview(divider1)
        divider1.anchor(top: view.topAnchor, left: view.leftAnchor,right: view.rightAnchor,paddingLeft: 8,height: 1)
        
        let stack = UIStackView(arrangedSubviews: [retweetLabel,likesLabel])
        stack.spacing = 12
        
        view.addSubview(stack)
        stack.centerY(inView: view)
        stack.anchor(left: view.leftAnchor, paddingLeft: 16)
        
        let divider2 = UIView()
        divider2.backgroundColor = .systemGroupedBackground
        view.addSubview(divider2)
        divider2.anchor( left: view.leftAnchor,bottom: view.bottomAnchor,right: view.rightAnchor,paddingLeft: 8,height: 1)
        
        return view
    }()
    
    private lazy var commentButton : ActionButton = {
        let button = ActionButton(image: #imageLiteral(resourceName: "comment"))
        button.addTarget(self, action: #selector(handleCommentPressed), for: .touchUpInside)
        return button
    }()
    private lazy var retweetButton : ActionButton = {
        let button = ActionButton(image: #imageLiteral(resourceName: "retweet"))
        button.addTarget(self, action: #selector(handleRetweetPressed), for: .touchUpInside)
        return button
    }()
    private lazy var likeButton : ActionButton = {
        let button = ActionButton(image: #imageLiteral(resourceName: "like"))
        button.addTarget(self, action: #selector(handleLikePressed), for: .touchUpInside)
        return button
    }()
    private lazy var shareButton : ActionButton = {
        let button = ActionButton(image: #imageLiteral(resourceName: "share"))
        button.addTarget(self, action: #selector(handleSharePressed), for: .touchUpInside)
        return button
    }()
    
    
    //MARK: Life Cycle
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        backgroundColor = .white
        configureMentionTapped()
        
        let labelStack = UIStackView(arrangedSubviews: [fullNameLabel,userNameLabel])
        labelStack.axis = .vertical
        labelStack.spacing = -6
        
        let stack = UIStackView(arrangedSubviews: [profileImageView,labelStack])
        stack.spacing = 12
        
        let vStack = UIStackView(arrangedSubviews: [replyLabel,stack])
        vStack.axis = .vertical
        vStack.spacing = 8
        vStack.distribution = .fillProportionally
        addSubview(vStack)
        vStack.anchor(top: topAnchor,left: leftAnchor,paddingTop: 16,paddingLeft: 16)
        addSubview(captionLabel)
        captionLabel.anchor(top: stack.bottomAnchor,left: leftAnchor,right: rightAnchor,paddingTop: 20,paddingLeft: 16,
                            paddingRight: 16)
        addSubview(dateLabel)
        dateLabel.anchor(top: captionLabel.bottomAnchor,left: leftAnchor,paddingTop: 20,paddingLeft: 16)
        
        addSubview(optionButton)
        optionButton.centerY(inView: stack)
        optionButton.anchor(right : rightAnchor,paddingRight: 8)
        
        addSubview(statView)
        statView.anchor(top: dateLabel.bottomAnchor,left: leftAnchor,right: rightAnchor, paddingTop: 12,height: 40)
        
        let actionStack = UIStackView(arrangedSubviews: [commentButton, retweetButton, likeButton, shareButton])
        actionStack.spacing = 72
        actionStack.distribution = .fillEqually
        
        addSubview(actionStack)
        actionStack.centerX(inView: self)
        actionStack.anchor( top: statView.bottomAnchor, paddingTop: 16)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    //MARK: Selector
    @objc func handleProfileImageTapped(){
        
        print("profile")
    }
    
    @objc func handleOptionPressed(){
        delegate?.showActionSheet()
    }
    
    @objc func handleCommentPressed(){
        print("Vishal @vishal_lv")
        
    }
    @objc func handleRetweetPressed(){
        print("Vishal @vishal_lv")
    }
    @objc func handleLikePressed(){
        print("Vishal @vishal_lv")
    }
    @objc func handleSharePressed(){
        print("Vishal @vishal_lv")
    }
    
    //MARK: Helper Function
    
    func configure(){
        guard let tweet = tweet else {return}
        guard let user = tweet.user else {return}
        let viewModel = TweetViewModel(tweet: tweet, user: user)
        
        captionLabel.text = tweet.caption
        fullNameLabel.text = user.fullname
        userNameLabel.text = viewModel.usernameText
        dateLabel.text = viewModel.headerTimeStamp
        profileImageView.setImageUsingSDWebImage(view: profileImageView, urlString: viewModel.profileImageUrl)
        likesLabel.attributedText = viewModel.likesAttributedString
        retweetLabel.attributedText  = viewModel.retweetAttributedString
        likeButton.setImage(viewModel.likeButtonImage, for: .normal)
        likeButton.tintColor = viewModel.likeButtonTintColor
        
        replyLabel.isHidden = viewModel.shouldHideReply
        replyLabel.text = viewModel.replyText
        
    }
    
    func configureMentionTapped(){
        captionLabel.handleMentionTap { (mention) in
            print(mention)
            self.delegate?.handleFetchUser(withUsername: mention)
        }
    }
    
}
