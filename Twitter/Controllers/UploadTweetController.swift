//
//  UploadTweetController.swift
//  Twitter
//
//  Created by Vishal Lakshminarayanappa on 5/17/20.
//  Copyright © 2020 Vishal Lakshminarayanappa. All rights reserved.
//

import UIKit
import ActiveLabel

enum UploadTweetConfiguration {
    case tweet
    case reply(Tweet)
}

class UploadTweetController : UIViewController{
    
    //MARK: Properties
    private let user : User
    private let config : UploadTweetConfiguration
    private lazy var tweetModel = UploadTweetViewModel(config: config)

    
    private lazy var tweetCreateButton : UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("Tweet", for: .normal)
        button.setTitleColor(.white, for: .normal)
        button.titleLabel?.textAlignment = .center
        button.titleLabel?.font = UIFont.boldSystemFont(ofSize: 16)
        button.backgroundColor = .mainBlue
        
        
        button.frame = CGRect(x: 0, y: 0, width: 64, height: 32)
        button.layer.cornerRadius = 16
        
        button.addTarget(self, action: #selector(handleUploadTweet), for: .touchUpInside)
        return button
        
    }()
    
    private lazy var replyLabel : ActiveLabel = {
        let label = ActiveLabel()
        label.font = UIFont.systemFont(ofSize: 14)
        label.mentionColor = .mainBlue
        label.widthAnchor.constraint(equalToConstant: view.frame.width).isActive = true
        label.textColor = .lightGray
        return label
    }()
    
    private let profileImageView : UIImageView = {
        let iv =  UIImageView().createProfileImageView(size: 48)        
        return iv
        
    }()
    
    private let captionTextView = CaptionTextView()
    
    //MARK: Life Cycle
    init(user : User , config : UploadTweetConfiguration) {
        self.user  = user
        self.config = config
        super.init(nibName: nil, bundle: nil)
    }
    
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        configureUI()
        configureMentionTapped()
        
    }
    
    
    //MARK: Selector
    
    @objc func handleUploadTweet(){
        
        guard let  caption = captionTextView.text else {return}
        
        TweetService.shared.uploadTweet(caption: caption, type: config) { [weak self](error, ref) in
            
            if let error = error {
                print("FAiled to upload tweet \(error.localizedDescription)")
            }
            
            if case .reply(let tweet) = self?.config{
                NotificationService.shared.uploadNotification(type: .reply, tweet: tweet)
            }
            
            self?.dismiss(animated: true, completion: nil)
            
        }
        
    }
    
    @objc func handleCancel(){
        self.dismiss(animated: true, completion: nil)
    }
    
    //MARK: Helper Function
    
    func configureUI(){
        
        view.backgroundColor = .white
        setupNavigationController()
        
        
        let imageCaptionStack = UIStackView(arrangedSubviews: [profileImageView,captionTextView])
        imageCaptionStack.axis = .horizontal
        imageCaptionStack.spacing = 12
        imageCaptionStack.alignment = .leading
        imageCaptionStack.widthAnchor.constraint(equalToConstant: view.frame.width).isActive = true
        
        let stack = UIStackView(arrangedSubviews: [replyLabel,imageCaptionStack])
        stack.axis = .vertical
        stack.alignment = .leading
        stack.spacing = 12
        
        view.addSubview(stack)
        stack.anchor(top:view.safeAreaLayoutGuide.topAnchor,left: view.leftAnchor,right: view.rightAnchor,
                                paddingTop: 16,paddingLeft: 16,paddingRight: 16)
        
        profileImageView.setImageUsingSDWebImage(view: profileImageView, urlString: user.profileImageURL)
        
        tweetCreateButton.setTitle(tweetModel.actionButtonTitle, for: .normal)
        captionTextView.placeholderLabel.text = tweetModel.placeHolderText
        replyLabel.isHidden = !tweetModel.shouldShowReplyLabel
        
        guard let replyText = tweetModel.replyText else {return}
        replyLabel.text = replyText
        
    }
    
    func configureMentionTapped(){
        replyLabel.handleMentionTap { (mention) in
            print("DEBUG: \(mention)")
        }
    }

    
    
}

extension UploadTweetController{
    
    func setupNavigationController(){
        navigationController?.navigationBar.barTintColor = .white
        navigationController?.navigationBar.isTranslucent = false
        
        navigationItem.leftBarButtonItem = UIBarButtonItem(barButtonSystemItem: .cancel, target: self, action: #selector(handleCancel))
        navigationItem.rightBarButtonItem = UIBarButtonItem(customView: tweetCreateButton)
    }
}
