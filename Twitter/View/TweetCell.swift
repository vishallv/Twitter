//
//  TweetCell.swift
//  Twitter
//
//  Created by Vishal Lakshminarayanappa on 5/17/20.
//  Copyright © 2020 Vishal Lakshminarayanappa. All rights reserved.
//

import UIKit
import ActiveLabel

protocol TweetCellDelegate : class {
    
    func profileImageTapped(_ cell : TweetCell)
    func handleReplyTapped(_ cell : TweetCell)
    func handleLikeTapped(_ cell : TweetCell)
    func handleFetchUser(withUsername username : String)
}

class TweetCell: UICollectionViewCell{

    //MARK: Properties
    
    var tweet : Tweet? {
        didSet{
            configure()
        }
    }
    
    weak var delegate : TweetCellDelegate?
    
    static let resuseIdentifier = "TweetCell"
    
    private let replyLabel : ActiveLabel = {
        let label = ActiveLabel()
        label.textColor = .lightGray
        label.mentionColor = .mainBlue
        label.font = UIFont.systemFont(ofSize:  12)
//        label.text  = "→ replying to joker"
        return label
    }()
    
    private lazy var profileImageView : UIImageView = {
        let iv = UIImageView().createProfileImageView(size: 48)
//        iv.backgroundColor = .mainBlue
        iv.isUserInteractionEnabled = true
        let tap = UITapGestureRecognizer(target: self, action: #selector(handleProfileImageTapped))
        iv.addGestureRecognizer(tap)
        return iv
    }()
    
    private let captionLabel  :ActiveLabel = {
        
        let label = ActiveLabel()
        label.font = UIFont.systemFont(ofSize: 14)
        label.mentionColor = .mainBlue
        label.hashtagColor = .mainBlue
        label.text = "Some Caption for now"
        label.numberOfLines = 0
        return label
    }()
    
    private let infoLabel = UILabel()
    
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
        configureMentionTapped()
        
//        backgroundColor = .red
        
//        addSubview(profileImageView)
//        profileImageView.anchor(top: topAnchor,left: leftAnchor,paddingTop: 8,paddingLeft: 8)
        
        let stack = UIStackView(arrangedSubviews: [infoLabel,captionLabel])
        stack.axis = .vertical
        stack.distribution = .fillProportionally
        stack.spacing = 4
        
        let imageCaptionStack = UIStackView(arrangedSubviews: [profileImageView,stack])
        imageCaptionStack.spacing = 12
        imageCaptionStack.alignment = .leading
        imageCaptionStack.distribution = .fillProportionally
        
//        infoLabel.text = "Vishal @vishal_lv"
        
        
        
        let vStack = UIStackView(arrangedSubviews: [replyLabel,imageCaptionStack])
        vStack.axis = .vertical
        vStack.spacing = 8
        vStack.distribution = .fillProportionally
        
        addSubview(vStack)
        vStack.anchor(top: topAnchor,left: leftAnchor,right: rightAnchor,paddingTop: 4,
                     paddingLeft: 12,paddingRight: 12)
        
        replyLabel.isHidden = true
        
        let horizontalStack = UIStackView(arrangedSubviews: [commentButton, retweetButton, likeButton,shareButton])
        horizontalStack.axis = .horizontal
        horizontalStack.spacing = 72

        addSubview(horizontalStack)
        horizontalStack.centerX(inView: self)
        horizontalStack.anchor( bottom: bottomAnchor,paddingBottom: 10)
        
        
        let underlineView = UIView()
        underlineView.backgroundColor = .systemGroupedBackground
        
        addSubview(underlineView)
        underlineView.anchor(left: leftAnchor,bottom: bottomAnchor ,right: rightAnchor, height: 1)
    }
    
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    

    //MARK: Selector
    
    @objc func handleProfileImageTapped(){
        
        delegate?.profileImageTapped(self)
    }
    
    @objc func handleCommentPressed(){
        delegate?.handleReplyTapped(self)
        
    
    }
    @objc func handleRetweetPressed(){
        print("Vishal @vishal_lv")
    }
    @objc func handleLikePressed(){
        print("Came her")
        delegate?.handleLikeTapped(self)
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
        profileImageView.setImageUsingSDWebImage(view: profileImageView, urlString: viewModel.profileImageUrl)
        infoLabel.attributedText = viewModel.userInfoText
        likeButton.tintColor = viewModel.likeButtonTintColor
        likeButton.setImage(viewModel.likeButtonImage, for: .normal)
        replyLabel.isHidden = viewModel.shouldHideReply
        replyLabel.text = viewModel.replyText
        
    }
    
    func configureMentionTapped(){
        captionLabel.handleMentionTap { (mention) in
            self.delegate?.handleFetchUser(withUsername: mention)
        }
    }
    
    
}
