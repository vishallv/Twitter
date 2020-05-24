//
//  FeedController.swift
//  Twitter
//
//  Created by Vishal Lakshminarayanappa on 4/4/20.
//  Copyright © 2020 Vishal Lakshminarayanappa. All rights reserved.
//

import UIKit
import SDWebImage

class FeedController : UICollectionViewController{
    
    
    
    //MARK: Properties
    private var tweets = [Tweet]() {
        
        didSet{
            DispatchQueue.main.async {
                self.collectionView.reloadData()
            }
        }
        
    }
    
    var user : User? {
        didSet{
            configureleftBarButton()
        }
    }
    
    //MARK: Life Cycles
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        navigationController?.navigationBar.isHidden = false
        navigationController?.navigationBar.barStyle = .default
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        configureUI()
        fetchTweets()
        
        
    }
    
    
    //MARK: API
    
    func fetchTweets(){
        collectionView.refreshControl?.beginRefreshing()
        TweetService.shared.fetchTweet { [weak self] (tweets) in
            self?.collectionView.refreshControl?.endRefreshing()
            guard let tweets = tweets else {return}
            self?.tweets = tweets.sorted(by: {$0.timestamp > $1.timestamp })
            self?.checkIfUserExist(self!.tweets)
            
            
            
        }
    }
    
    
    func checkIfUserExist(_ tweets : [Tweet]){
        //        for (index,tweet) in tweets.enumerated(){
        //            TweetService.shared.checkIfUserLikedTweet(tweet: tweet) { (didLike) in
        //                guard didLike == true else {return}
        //
        //                self.tweets[index].didLike = didLike
        //            }
        //        }
        
        tweets.forEach { (tweet) in
            TweetService.shared.checkIfUserLikedTweet(tweet: tweet) { (didLike) in
                guard didLike == true else {return}
                
                if let index = tweets.firstIndex(where: {$0.tweetId! == tweet.tweetId!}){
                    self.tweets[index].didLike = didLike
                }
                
                //                           self.tweets[index].didLike = didLike
            }
        }
    }
    
    //MARK: Selectors
    @objc func handleRefresh(){
        fetchTweets()
    }
    
    //MARK: Helper Functions
    
    func configureUI(){
        collectionView.backgroundColor = .white
        collectionView.register(TweetCell.self, forCellWithReuseIdentifier: TweetCell.resuseIdentifier)
        
        let imageView = UIImageView(image: #imageLiteral(resourceName: "twitter_logo_blue"))
        imageView.contentMode = .scaleAspectFit
        imageView.setDimensions(height: 44, width: 44)
        navigationItem.titleView = imageView
        
        let refreshControl = UIRefreshControl()
        collectionView.refreshControl = refreshControl
        refreshControl.addTarget(self, action: #selector(handleRefresh), for: .valueChanged)
        
        
    }
    
    func configureleftBarButton(){
        
        
        guard let urlString = user?.profileImageURL else {return}
        guard let profileImageURL = URL(string: urlString) else {return}
        
        let profileImageView = UIImageView()
        profileImageView.setDimensions(height: 32, width: 32)
        profileImageView.layer.cornerRadius = 32/2
        profileImageView.sd_setImage(with: profileImageURL, completed: nil)
        profileImageView.layer.masksToBounds = true
        
        //Check it out later
        
        //        profileImageView.setImageUsingSDWebImage(view: profileImageView, urlString: urlString)
        
        navigationItem.leftBarButtonItem = UIBarButtonItem(customView: profileImageView)
        
        
    }
    
    
    
}

extension FeedController{
    
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return tweets.count
    }
    
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: TweetCell.resuseIdentifier, for: indexPath) as! TweetCell
        
        cell.tweet = tweets[indexPath.row]
        cell.delegate = self
        return cell
    }
    
    override func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
        let tweet = self.tweets[indexPath.row]
        let controller = TweetController(tweet: tweet)
        navigationController?.pushViewController(controller, animated: true)
        
    }
}

extension FeedController : UICollectionViewDelegateFlowLayout{
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        let tweet = tweets[indexPath.row]
        guard let user = tweet.user else {return CGSize(width: 0, height: 0) }
        let viewModel = TweetViewModel(tweet: tweet, user: user)
        let height = viewModel.size(forWidth: view.frame.width).height
        
        return CGSize(width: view.frame.width, height: height + 80)
        
    }
}


extension FeedController : TweetCellDelegate{
    func handleFetchUser(withUsername username: String) {
        UserService.shared.fetchUserForMention(withUsername: username) { [weak self] (user) in
            
            let controller = ProfileController(user: user)
            self?.navigationController?.pushViewController(controller, animated: true)
        }
    }
    
    func handleLikeTapped(_ cell: TweetCell) {
        guard let tweet = cell.tweet else {return}
        
        TweetService.shared.likeTweet(tweet: tweet) { (err, ref) in
            
            cell.tweet?.didLike.toggle()
            let likes = tweet.didLike ? tweet.likes - 1 : tweet.likes + 1
            cell.tweet?.likes = likes
            
            
            guard !tweet.didLike else {return}
            NotificationService.shared.uploadNotification(type: .like, tweet: tweet)
        }
    }
    
    func handleReplyTapped(_ cell: TweetCell) {
        
        guard let tweet = cell.tweet else {return}
        guard let user = tweet.user else {return}
        let controller = UploadTweetController(user: user, config: .reply(tweet))
        let nav = UINavigationController(rootViewController: controller)
        nav.modalPresentationStyle = .fullScreen
        present(nav, animated: true, completion: nil)
        
    }
    
    
    func profileImageTapped(_ cell: TweetCell) {
        
        
        
        guard let user = cell.tweet?.user else {return}
        let controller = ProfileController(user: user)
        navigationController?.pushViewController(controller, animated: true)
    }
    
    
}


