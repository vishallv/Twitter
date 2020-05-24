//
//  MainTabController.swift
//  Twitter
//
//  Created by Vishal Lakshminarayanappa on 4/4/20.
//  Copyright © 2020 Vishal Lakshminarayanappa. All rights reserved.
//

import UIKit
import Firebase

class MainTabController : UITabBarController{
    
   
    
    var user : User? {
        didSet{
            guard let nav = viewControllers?[0] as? UINavigationController else{return}
            guard let feed = nav.viewControllers.first as? FeedController else {return}
            feed.user = user
        }
    }
    
    //MARK: Properties
    
    let actionButton : UIButton = {
        let button = UIButton(type: .system)
        button.tintColor = .white
        button.backgroundColor = UIColor.mainBlue
        button.setImage(#imageLiteral(resourceName: "new_tweet").withRenderingMode(.alwaysOriginal), for: .normal)
        button.addTarget(self, action: #selector(handleActionButtonTapped), for: .touchUpInside)
        return button
    }()
    
    //MARK: Life Cycles
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        checkIfUserISLoggedIn()
//                signOutUser()
    }
    
    
    
    
    
    
    
    //MARK: Selectors
    
    @objc func handleActionButtonTapped(){
        guard let user = self.user else {return}
        
        let controller = UploadTweetController(user: user,config: .tweet)
        let nav = UINavigationController(rootViewController: controller)
        nav.modalPresentationStyle = .fullScreen
        present(nav, animated: true, completion: nil)
    }
    
    //MARK: Helper Functions
    
    
    //MARK: API
    func checkIfUserISLoggedIn(){
        
        if Auth.auth().currentUser?.uid == nil{
            
            DispatchQueue.main.async {
                let controller = UINavigationController(rootViewController: LoginController())
                
                if #available(iOS 13, *){
                    controller.isModalInPresentation = true
                    
                }
                
                controller.modalPresentationStyle = .fullScreen
                self.present(controller, animated: true, completion: nil)
            }
            
        }
        else{
            
            configureTabBarControllers()
            configureUI()
            fetchUser()
        }
    }
    
    
    func fetchUser(){
        
        guard let uid = Auth.auth().currentUser?.uid else {return}
        
        UserService.shared.fetchUser(uid:uid) {(user: User?,uid) in
            guard var user = user else {return}
            user.id = uid
            self.user = user
        }
        
    }
    
    
    
    //MARK : Configure UI
    func configureUI(){
        
        view.addSubview(actionButton)
        actionButton.anchor(bottom: view.safeAreaLayoutGuide.bottomAnchor,right: view.rightAnchor,paddingBottom: 64,
                            paddingRight: 16,width: 56,
                            height: 56)
        actionButton.layer.cornerRadius = 56/2
    }
    
    func configureTabBarControllers(){
        tabBar.barTintColor = .white
        tabBar.isTranslucent = false
        
        let feed = FeedController(collectionViewLayout: UICollectionViewFlowLayout())
        let navControllerFeed = templateNavController(image: #imageLiteral(resourceName: "home_unselected"), rootController: feed)
        
        
        
        
        let explore = ExploreController()
        let navControllerExplore = templateNavController(image: #imageLiteral(resourceName: "search_unselected"), rootController: explore)
        
        
        let notification = NotificationController()
        let navControllerNotification = templateNavController(image: #imageLiteral(resourceName: "like_unselected"), rootController: notification)
        
        let conversation = ConversationController()
        let navControllerConversation = templateNavController(image: #imageLiteral(resourceName: "ic_mail_outline_white_2x-1"), rootController: conversation)
        
        
        viewControllers = [navControllerFeed,navControllerExplore,navControllerNotification,navControllerConversation]
    }
    
    
    func templateNavController(image : UIImage, rootController : UIViewController) -> UINavigationController{
        
        
        let nav = UINavigationController(rootViewController: rootController)
        nav.tabBarItem.image = image
        nav.navigationBar.barTintColor = .white
        return nav
        
    }
    

}

extension MainTabController {
    
    func signOutUser(){
        do {
            
            try Auth.auth().signOut()
        }
        catch let error{
            
            print(error)
            
        }
        
        
    }
    
}
