//
//  ActionSheetCell.swift
//  Twitter
//
//  Created by Vishal Lakshminarayanappa on 5/21/20.
//  Copyright © 2020 Vishal Lakshminarayanappa. All rights reserved.
//

import UIKit

class ActionSheetCell: UITableViewCell {
    
    //MARK: Properties
    
    var option : ActionSheetOption?{
        didSet{
            configure()
        }
    }
    
    private let optionImageView : UIImageView = {
        
        let iv = UIImageView()
        iv.contentMode = .scaleAspectFit
        iv.clipsToBounds = true
        iv.image = #imageLiteral(resourceName: "twitter_logo_blue")
        return iv
    }()
    
    private let titleLabel : UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 18)
        label.text = "Test Option"
        return label
    }()
    
    //MARK: Life Cycle
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        selectionStyle = .none
        addSubview(optionImageView)
        optionImageView.centerY(inView: self)
        optionImageView.setDimensions(height: 36, width: 36)
        optionImageView.anchor(left: leftAnchor ,paddingLeft:  8)
        
        addSubview(titleLabel)
        titleLabel.anchor(left : optionImageView.rightAnchor, paddingLeft: 12)
        titleLabel.centerY(inView: self)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    //MARK: Selector
    
    //MARK: Helper Function
    func configure(){
        titleLabel.text = option?.description
    }
    
}
