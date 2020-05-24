//
//  TweetController.swift
//  Twitter
//
//  Created by Vishal Lakshminarayanappa on 5/20/20.
//  Copyright © 2020 Vishal Lakshminarayanappa. All rights reserved.
//

import UIKit

class TweetController : UICollectionViewController{
    
    //MARK: Properties
    private let tweet : Tweet
    private var actionSheetLauncher : ActionSheetLauncher!
    
    private var replies  = [Tweet](){
        didSet{
            DispatchQueue.main.async {
                self.collectionView.reloadData()
            }
        }
    }
    
    //MARK: Life Cycle
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        navigationController?.navigationBar.isHidden = false
        navigationController?.navigationBar.barStyle = .default
    }
    init(tweet: Tweet) {
        self.tweet = tweet
        //        guard let user = tweet.user else {fatalError()}
        //        self.actionSheetLauncher = ActionSheetLauncher(user: user)
        super.init(collectionViewLayout: UICollectionViewFlowLayout())
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        configureCollectionView()
        fetchReplies()
    }
    
    //MARK: Selector
    
    
    //MARK: API
    func fetchReplies(){
        
        TweetService.shared.fetchReplies(forTweet: tweet) { [weak self](tweets) in
            self?.replies = tweets
        }
    }
    
    //MARK: Helper Function
    
    func configureCollectionView(){
        collectionView.backgroundColor = .white
        collectionView.register(TweetCell.self, forCellWithReuseIdentifier: TweetCell.resuseIdentifier)
        collectionView.register(TweetHeader.self, forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader,
                                withReuseIdentifier: TweetHeader.reuseIdentifier)
        
        
    }
}

extension TweetController{
    
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return replies.count
    }
    
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: TweetCell.resuseIdentifier, for: indexPath) as! TweetCell
        
        cell.tweet = replies[indexPath.row]
        return cell
    }
}

extension TweetController{
    override func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        let header = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: TweetHeader.reuseIdentifier, for: indexPath) as! TweetHeader
        header.tweet = self.tweet
        header.delegate = self
        return header
        
    }
}
extension TweetController : UICollectionViewDelegateFlowLayout{
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForHeaderInSection section: Int) -> CGSize {
        
        guard let user = tweet.user else {return CGSize(width: 0, height: 0)}
        let viewModel = TweetViewModel(tweet: tweet, user: user)
        let captionHeight = viewModel.size(forWidth: view.frame.width).height
        
        return CGSize(width: view.frame.width, height: captionHeight + 260)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: view.frame.width, height: 120)
    }
}

extension TweetController : TweetHeaderDelegate{
    
    func handleFetchUser(withUsername username: String) {
        UserService.shared.fetchUserForMention(withUsername: username) { [weak self] (user) in
            
            let controller = ProfileController(user: user)
            self?.navigationController?.pushViewController(controller, animated: true)
        }
    }
    
    
    func showActionSheet() {
        guard var user = tweet.user else {return}
        
        if user.isCurrentUser{
            actionSheetLauncher = ActionSheetLauncher(user: user)
            actionSheetLauncher.delegate = self
            actionSheetLauncher.show()
        }else{
            UserService.shared.checkIfUserIsFollowed(uid: user.getUID()) { [weak self](isFollowed) in
                user.isFollowed = isFollowed
                self?.actionSheetLauncher = ActionSheetLauncher(user: user)
                self?.actionSheetLauncher.delegate = self
                self?.actionSheetLauncher.show()
            }
        }
        
        
        //        actionSheetLauncher.show()
    }
    
}

extension TweetController : ActionSheetLauncherDelegate{
    func didSelect(option: ActionSheetOption) {
        switch option{
            
        case .follow(let user):
            UserService.shared.followUser(uid: user.getUID()) { (err, ref) in
                print("Folloed User")
            }
        case .unfollow(let user):
            UserService.shared.unfollowUser(uid: user.getUID()) { (err, ref) in
                print("Unfolow")
            }
        case .delete:
            print("Delete")
        case .report:
            print("report")
        }
    }
    
    
}
