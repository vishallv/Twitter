//
//  ProfileController.swift
//  Twitter
//
//  Created by Vishal Lakshminarayanappa on 5/18/20.
//  Copyright © 2020 Vishal Lakshminarayanappa. All rights reserved.
//

import UIKit
import Firebase

class ProfileController : UICollectionViewController{
    
    
    //MARK: Properties
    var user : User
    private var tweets = [Tweet]()
    //    {
    //
    //        didSet{
    //            DispatchQueue.main.async {
    //                self.collectionView.reloadData()
    //            }}}
    
    private var selectedFilter : ProfileFilterOptions = .tweets{
        didSet{
            collectionView.reloadData()
        }
    }
    
    private var likesTweets = [Tweet]()
    
    private var repliesTweet = [Tweet]()
    private var currentDataSource  : [Tweet]{
        switch selectedFilter{
            
        case .tweets:
            return tweets
        case .replies:
            return repliesTweet
        case .likes:
            return likesTweets
        }
    }
    
    
    
    
    //MARK: Life Cycle
    
    init(user: User) {
        self.user = user
        super.init(collectionViewLayout: UICollectionViewFlowLayout())
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        configureUIAndNagigationBar()
        fetchTweets()
        fetchLikedTweets()
        fetchReplies()
        checkIfUserIsFollowed()
        fetchUserStats()
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        navigationController?.navigationBar.isHidden = true
        navigationController?.navigationBar.barStyle = .black
    }
    
    //MARK : API
    
    func fetchTweets(){
        
        TweetService.shared.fetchSingleUserTweets(forUser: user) {[weak self] (tweets) in
            
            guard var resTweets = tweets else {return}
            //OWN Sorting implementation
            //            resTweets.sort {$0.timestamp > $1.timestamp}
            //            self?.tweets = resTweets
            self?.tweets = resTweets
            self?.collectionView.reloadData()
        }
        
    }
    
    func fetchReplies(){
        
        TweetService.shared.fetchReplies(forUser: user) { [weak self](tweets) in
            self?.repliesTweet = tweets
            self?.collectionView.reloadData()
        }
    }
    
    func fetchLikedTweets(){
        
        TweetService.shared.fetchLikes(forUser: user) { [weak self](tweets) in
            
            self?.likesTweets = tweets
            self?.collectionView.reloadData()
        }
    }
    
    func fetchUserStats(){
        
        UserService.shared.fetchUserStat(uid:user.getUID()) { [weak self ] (userStat) in
            guard let userStat = userStat else {return}
            
            self?.user.stats = userStat
            self?.collectionView.reloadData()
            
        }
    }
    
    func checkIfUserIsFollowed(){
        guard let uid = user.id else {return}
        UserService.shared.checkIfUserIsFollowed(uid: uid) { (isFollowed) in
            
            self.user.isFollowed = isFollowed
            self.collectionView.reloadData()
        }
    }
    
    //MARK: Selector
    
    //MARK: Helper Function
    func configureUIAndNagigationBar(){
        
        
        
        collectionView.backgroundColor = .white
        collectionView.contentInsetAdjustmentBehavior = .never
        collectionView.register(TweetCell.self, forCellWithReuseIdentifier: TweetCell.resuseIdentifier)
        collectionView.register(ProfileHeader.self,
                                forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader,
                                withReuseIdentifier: ProfileHeader.reuseIdentifier)
        
        guard let tabHeight = tabBarController?.tabBar.frame.height else {return}
        collectionView.contentInset.bottom = tabHeight
    }
    
    
    
    
    
}

extension ProfileController{
    
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        //        return tweets.count
        return currentDataSource.count
        
    }
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: TweetCell.resuseIdentifier, for: indexPath) as! TweetCell
        
        //        cell.tweet = tweets[indexPath.row]
        cell.tweet = currentDataSource[indexPath.row]
        return cell
    }
}

//MARK: viewForSupplementaryElementOfKind
extension ProfileController{
    
    override func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        
        let header = collectionView.dequeueReusableSupplementaryView(ofKind: kind,
                                                                     withReuseIdentifier: ProfileHeader.reuseIdentifier,
                                                                     for: indexPath) as! ProfileHeader
        
        header.user = user
        header.delegate = self
        return header
        
    }
    
    override func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let tweet = self.currentDataSource[indexPath.row]
        let controller = TweetController(tweet: tweet)
        navigationController?.pushViewController(controller, animated: true)
    }
}

//MARK: UICollectionViewDelegateFlowLayout

extension ProfileController : UICollectionViewDelegateFlowLayout{
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForHeaderInSection section: Int) -> CGSize {
        return CGSize(width: view.frame.width, height: 350)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        //        let tweet = tweets[indexPath.row]
        let tweet = currentDataSource[indexPath.row]
        guard let user = tweet.user else {return CGSize(width: 0, height: 0) }
        let viewModel = TweetViewModel(tweet: tweet, user: user)
        var height = viewModel.size(forWidth: view.frame.width).height + 80
        
        if currentDataSource[indexPath.row].isReply{
            height += 20
        }
        
        return CGSize(width: view.frame.width, height: height )
    }
    
}

extension ProfileController : ProfileHeaderDelegate{
    
    func didSelected(filter: ProfileFilterOptions) {
        self.selectedFilter = filter
    }
    
    func handleEditProfileFollow(_ header: ProfileHeader) {
        
        guard let uid = user.id else {return}
        
        if user.isCurrentUser{
            let controller = EditProfileController(user: user)
            controller.delegate = self
            let nav = UINavigationController(rootViewController: controller)
            nav.modalPresentationStyle = .fullScreen
            present(nav, animated: true, completion: nil)
            return
        }
        
        if user.isFollowed{
            UserService.shared.unfollowUser(uid: uid) {[weak self] (err, ref) in
                
                self?.user.isFollowed = false
                DispatchQueue.main.async {
                    self?.collectionView.reloadData()
                }
            }
        }
        else{
            
            UserService.shared.followUser(uid: uid) { [weak self](err, ref) in
                self?.user.isFollowed = true
                
                DispatchQueue.main.async {
                    self?.collectionView.reloadData()
                }
                NotificationService.shared.uploadNotification(type: .follow, user: self?.user)
            }
        }
        
        
    }
    
    
    
    func dismissController() {
        
        navigationController?.popViewController(animated: true)
        
    }
    
}

extension ProfileController : EditProfileControllerDelegate{
    func logOutTheUser() {
        do {
            
            try Auth.auth().signOut()
            DispatchQueue.main.async {
                let controller = UINavigationController(rootViewController: LoginController())
                
                if #available(iOS 13, *){
                    controller.isModalInPresentation = true
                    
                }
                
                controller.modalPresentationStyle = .fullScreen
                self.present(controller, animated: true, completion: nil)
            }
        }
        catch let error{
            
            print(error)
            
        }
    }
    
    func controller(_ controller: EditProfileController, updateUser user: User) {
        controller.dismiss(animated: true, completion: nil)
        self.user = user
        
        self.collectionView.reloadData()
        
    }
    
    
}
