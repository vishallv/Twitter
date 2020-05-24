//
//  ActionSheetLauncher.swift
//  Twitter
//
//  Created by Vishal Lakshminarayanappa on 5/21/20.
//  Copyright © 2020 Vishal Lakshminarayanappa. All rights reserved.
//

import UIKit

private let reuseIdentifier = "ActionSheetLauncherCell"

protocol ActionSheetLauncherDelegate:class {
    func didSelect(option : ActionSheetOption)
}
class ActionSheetLauncher: NSObject{
    
    //MARK : Properties
    private let user: User
    
    private let tableView = UITableView()
    private var window : UIWindow?
    private lazy var viewModel = ActionSheetViewModel(user: user)
    weak var delegate : ActionSheetLauncherDelegate?
    
    private lazy var blackView : UIView = {
        let view = UIView()
        view.alpha = 0
        view.backgroundColor = UIColor(white: 0, alpha: 0.5)
        let tap = UITapGestureRecognizer(target: self, action: #selector(handleDismissal))
        view.addGestureRecognizer(tap)
        return view
    }()
    private lazy var footerView : UIView = {
        let view =  UIView()
        
        view.addSubview(cancelButton)
        cancelButton.heightAnchor.constraint(equalToConstant: 50).isActive = true
        cancelButton.centerY(inView: view)
        cancelButton.anchor(left : view.leftAnchor, right: view.rightAnchor,
                            paddingLeft: 12,paddingRight: 12)
        cancelButton.layer.cornerRadius = 50/2
        return view
    }()
    
    private lazy var cancelButton : UIButton = {
        let button = UIButton(type: .system)
        button.backgroundColor = .systemGroupedBackground
        button.setTitle("Cancel", for: .normal)
        button.titleLabel?.font = UIFont.systemFont(ofSize: 18)
        button.setTitleColor(.black, for: .normal)
        button.addTarget(self, action: #selector(handleDismissal), for: .touchUpInside)
        return button
    }()
    
    //MARK: Life Cycle
    init(user:User) {
        self.user = user
        super.init()
        configureTableView()
    }
    
    
    //MARK: Helper
    
    func show(){
        
        guard let window = UIApplication.shared.windows.first(where: {$0.isKeyWindow}) else {return}
        self.window = window
        window.addSubview(blackView)
        blackView.frame = window.frame
        
        window.addSubview(tableView)
        let height = CGFloat(viewModel.options.count * 60) + 80
        tableView.frame = CGRect(x: 0, y: window.frame.height, width: window.frame.width, height: height)
        
        UIView.animate(withDuration: 0.5) {
            self.blackView.alpha = 1
            self.tableView.frame.origin.y -= height
        }
    }
    
    func configureTableView(){
        tableView.backgroundColor = .white
        tableView.delegate = self
        tableView.dataSource = self
        tableView.rowHeight = 60
        tableView.separatorStyle = .none
        tableView.layer.cornerRadius = 5
        tableView.isScrollEnabled = false
        tableView.register(ActionSheetCell.self, forCellReuseIdentifier: reuseIdentifier)
    }
    
    
    //MARK: Selector
    
    @objc func handleDismissal(){
        UIView.animate(withDuration: 0.5) {
            self.blackView.alpha = 0
            self.tableView.frame.origin.y += 300
        }
    }
}
extension ActionSheetLauncher : UITableViewDelegate{
    
    func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
        return footerView
    }
    
    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return 60
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let option = viewModel.options[indexPath.row]
        
        UIView.animate(withDuration: 0.5, animations: {
            self.blackView.alpha = 0
            self.tableView.frame.origin.y += 300
        }) { (_) in
            self.delegate?.didSelect(option: option)
        }
        
    }
    
}

extension ActionSheetLauncher : UITableViewDataSource{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel.options.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: reuseIdentifier, for: indexPath) as! ActionSheetCell
        cell.option = viewModel.options[indexPath.row]
        return cell
    }
    
    
}
