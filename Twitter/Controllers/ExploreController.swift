//
//  ExploreController.swift
//  Twitter
//
//  Created by Vishal Lakshminarayanappa on 4/4/20.
//  Copyright © 2020 Vishal Lakshminarayanappa. All rights reserved.
//

import UIKit

class ExploreController : UITableViewController{
    
    
    //MARK: Properties
    var users = [User](){
        didSet{
            DispatchQueue.main.async {
                self.tableView.reloadData()
            } 
        }
    }
    
    var filteredUsers = [User](){
        didSet{
            DispatchQueue.main.async {
                self.tableView.reloadData()
            }
        }
    }
    
    private var isSearchMode : Bool{
        
        return searchController.isActive && !searchController.searchBar.text!.isEmpty
    }
    
    private let searchController = UISearchController(searchResultsController: nil)
    
    //MARK: Life Cycles
    override func viewWillAppear(_ animated: Bool) {
           super.viewWillAppear(animated)
           
           navigationController?.navigationBar.isHidden = false
           navigationController?.navigationBar.barStyle = .default
       }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureUI()
        fetchUsers()
        configureSearchController()
    }
    
    
    
    
    //MARK: Selectors
    
    //MARK: Helper Functions
    func fetchUsers(){
        
        UserService.shared.fetchUsers { [weak self](users) in
            
            guard let users = users else {return}
            self?.users = users
            
        }
    }
    
    func configureUI(){
        view.backgroundColor = .white
        navigationItem.title = "Explore"
        tableView.register(UserCell.self, forCellReuseIdentifier: UserCell.resuerIdentifier)
        tableView.rowHeight = 60
        tableView.separatorStyle = .none
        tableView.tableFooterView = UIView()
        
    }
    func configureSearchController(){
        searchController.searchResultsUpdater = self
        searchController.obscuresBackgroundDuringPresentation = false
        searchController.hidesNavigationBarDuringPresentation = false
        searchController.searchBar.placeholder = "Search for user"
        navigationItem.searchController = searchController
        definesPresentationContext = false
        
    }
    
}

extension ExploreController{
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return isSearchMode ? filteredUsers.count : users.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        
        let cell = tableView.dequeueReusableCell(withIdentifier: UserCell.resuerIdentifier, for: indexPath) as! UserCell
        
        let user = isSearchMode ? filteredUsers[indexPath.row] : users[indexPath.row]
        cell.user = user
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let user = isSearchMode ? filteredUsers[indexPath.row] : users[indexPath.row]
        let controller = ProfileController(user: user)
        
        navigationController?.pushViewController(controller, animated: true)
    }
    
    
}
extension ExploreController : UISearchResultsUpdating{
    func updateSearchResults(for searchController: UISearchController) {
        guard let searchText = searchController.searchBar.text?.lowercased() else {return}
        
        filteredUsers = self.users.filter({$0.username.lowercased().contains(searchText) || $0.fullname.lowercased().contains(searchText)})
        

        
    }
    
    
}
