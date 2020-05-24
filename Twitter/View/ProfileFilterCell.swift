//
//  ProfileFilterCell.swift
//  Twitter
//
//  Created by Vishal Lakshminarayanappa on 5/18/20.
//  Copyright © 2020 Vishal Lakshminarayanappa. All rights reserved.
//

import UIKit

class ProfileFilterCell : UICollectionViewCell{
    
    static let reuseIdentifier = "ProfileFilterCell"
    //MARK: Properties
    
    var option : ProfileFilterOptions!{
        didSet{
        
        titleLabel.text = option.description
        }
    }
    
    private let titleLabel : UILabel = {
        let label = UILabel()
        label.textColor = .lightGray
        label.text = "Tweet"
        label.font = UIFont.systemFont(ofSize: 14)
        return label
    }()
    
    
    override var isSelected: Bool{
        
        didSet{
            
            
            titleLabel.font = isSelected ? UIFont.boldSystemFont(ofSize: 16) : UIFont.systemFont(ofSize: 14)
            titleLabel.textColor = isSelected ? .mainBlue : .lightGray
        }
    }
    //MARK: Life Cycle
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        backgroundColor = .white
        
        addSubview(titleLabel)
        titleLabel.centerX(inView: self)
        titleLabel.centerY(inView: self)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    //MARK: Selector
    
    //MARK: Helper Function

}
