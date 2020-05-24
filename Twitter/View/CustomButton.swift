//
//  CustomButton.swift
//  Twitter
//
//  Created by Vishal Lakshminarayanappa on 5/16/20.
//  Copyright © 2020 Vishal Lakshminarayanappa. All rights reserved.
//

import UIKit

class CustomButton : UIButton {
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
       setTitle("", for: .normal)
        setupButton()
        
    }
    
    init(title : String) {
        super.init(frame: .zero)
        
        setTitle(title, for: .normal)
        self.setupButton()
        
    }
    
    
    func setupButton(){
        
        setTitleColor(.mainBlue, for: .normal)
        backgroundColor = .white
        heightAnchor.constraint(equalToConstant: 50).isActive = true
        titleLabel?.font = UIFont.boldSystemFont(ofSize: 20)
        layer.cornerRadius = 5
        
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    
}
