//
//  EditProfileFooter.swift
//  Twitter
//
//  Created by Vishal Lakshminarayanappa on 5/23/20.
//  Copyright © 2020 Vishal Lakshminarayanappa. All rights reserved.
//

import UIKit

protocol EditProfileFooterDelegate : class {
    func handleLogOut()
}

class EditProfileFooter :UIView{
    
    //MARK: Properties
    
    private lazy var logOutButton : UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("Log Out", for: .normal)
        button.setTitleColor(.red, for: .normal)
        button.backgroundColor = .systemGroupedBackground
        button.addTarget(self, action: #selector(handleLogOut), for: .touchUpInside)
        return button
    }()
    
    weak var delegate : EditProfileFooterDelegate?
    //MARK: Life Cycle
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        addSubview(logOutButton)
        logOutButton.anchor(top:topAnchor,left: leftAnchor,bottom: bottomAnchor,right: rightAnchor)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    //MARK: Selector
    @objc func handleLogOut(){
        delegate?.handleLogOut()
    }
    
    //MARK: Helper Function
}
