//
//  ConversationController.swift
//  Twitter
//
//  Created by Vishal Lakshminarayanappa on 4/4/20.
//  Copyright © 2020 Vishal Lakshminarayanappa. All rights reserved.
//

import UIKit

class ConversationController : UIViewController{
    
    
   //MARK: Properties
    
    //MARK: Life Cycles
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        configureUI()
    }
    
    
    
    
    //MARK: Selectors
    
    //MARK: Helper Functions
    func configureUI(){
        view.backgroundColor = .white
        navigationItem.title = "Messages"
    }
}
