//
//  ActionButton.swift
//  Twitter
//
//  Created by Vishal Lakshminarayanappa on 5/17/20.
//  Copyright © 2020 Vishal Lakshminarayanappa. All rights reserved.
//

import UIKit

class ActionButton : UIButton{
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
//        setTitle("", for: .normal)
        setupButton()
        
    }
    
    init(image : UIImage) {
        super.init(frame: .zero)
        
        setImage(image.withRenderingMode(.alwaysOriginal), for: .normal)
        self.setupButton()
        
    }
    
    
    func setupButton(){

        tintColor = .darkGray
        setDimensions(height: 20, width: 20)
        layer.cornerRadius = 5
        
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}


