//
//  CaptionTextView.swift
//  Twitter
//
//  Created by Vishal Lakshminarayanappa on 5/17/20.
//  Copyright © 2020 Vishal Lakshminarayanappa. All rights reserved.
//

import UIKit

class CaptionTextView : UITextView{
    
    let placeholderLabel : UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 16)
        label.textColor = .darkGray
        label.text = "What's happening?"
        return label
        
    }()
    
    
    override init(frame: CGRect, textContainer: NSTextContainer?) {
        super.init(frame: frame, textContainer: textContainer)
        
        
        backgroundColor = .white
        font = UIFont.systemFont(ofSize: 16)
        isScrollEnabled = false
        heightAnchor.constraint(equalToConstant: 100).isActive = true
        
        addSubview(placeholderLabel)
        placeholderLabel.anchor(top: topAnchor,left: leftAnchor,
                                paddingTop: 8,paddingLeft: 4)
        
        
        
        NotificationCenter.default.addObserver(self, selector: #selector(handleTextViewChange), name: UITextView.textDidChangeNotification, object: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    @objc func handleTextViewChange(){
        
        placeholderLabel.isHidden = !text.isEmpty
    }
    
    
    
}
