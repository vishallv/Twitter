//
//  NotificationController.swift
//  Twitter
//
//  Created by Vishal Lakshminarayanappa on 4/4/20.
//  Copyright © 2020 Vishal Lakshminarayanappa. All rights reserved.
//

import UIKit
private var reuseIdentifier = "NotificationControllerCell"

class NotificationController : UITableViewController{
    
    
    //MARK: Properties
    
    private var notifications = [Notification](){
        didSet{
            DispatchQueue.main.async {
                self.tableView.reloadData()
            }
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
        fetchNotifications()
    }
    
    //MARK: API
    
    func fetchNotifications(){
        refreshControl?.beginRefreshing()
        NotificationService.shared.fetchNotification { [weak self](notifications) in
            self?.refreshControl?.endRefreshing()
            guard let notifications = notifications else {return}
            self?.notifications = notifications
            
            for (index,notification) in notifications.enumerated(){
                if case .follow = notification.getType(){
                    guard let user = notification.user else {return}
                    
                    UserService.shared.checkIfUserIsFollowed(uid: user.getUID()) { (isFollowed) in
                        self?.notifications[index].user?.isFollowed = isFollowed
                    }
                    
                }
            }
        }
    }
    
    
    //MARK: Selectors
    @objc func handleRefresh(){
//        print("handl;e refe")
        fetchNotifications()
        
        
    }
    
    //MARK: Helper Functions
    func configureUI(){
        
        view.backgroundColor = .white
        navigationItem.title = "Notifications"
        tableView.register(NotificationCell.self, forCellReuseIdentifier: reuseIdentifier)
        tableView.rowHeight = 60
        tableView.tableFooterView = UIView()
        tableView.separatorStyle = .none
        
        let refreshControl = UIRefreshControl()
        tableView.refreshControl = refreshControl
        refreshControl.addTarget(self, action: #selector(handleRefresh), for: .valueChanged)
        
    }
}

extension NotificationController{
    
    
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return notifications.count
    }
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: reuseIdentifier, for: indexPath) as! NotificationCell
        cell.notification = notifications[indexPath.row]
        cell.delegate = self
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        guard let tweetID = notifications[indexPath.row].tweetID else {return}
        
        TweetService.shared.fetchOneTweet(withTweeID: tweetID) { [weak self](tweet) in
            guard let tweet = tweet else {return}
            
            let controller = TweetController(tweet: tweet)
            self?.navigationController?.pushViewController(controller, animated: true)
        }
    }
    
}

extension NotificationController : NotificationCellDelegate{
    func didTapFollow(_ cell: NotificationCell) {
        
        guard let user = cell.notification?.user else {return}
        print(user.isFollowed)
        
        if user.isFollowed{
            UserService.shared.unfollowUser(uid: user.getUID()) { (err, ref) in
                cell.notification?.user?.isFollowed = false
            }
        }
        else{
            UserService.shared.followUser(uid: user.getUID()) { (err, ref) in
                cell.notification?.user?.isFollowed = true
            }
        }
    }
    
    func handleProfileImageTapped(_ cell: NotificationCell) {
        
        guard let user = cell.notification?.user else {return}
        
        let controller = ProfileController(user: user)
        navigationController?.pushViewController(controller, animated: true)
    }
    
    
}

