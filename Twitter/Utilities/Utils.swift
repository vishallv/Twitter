//
//  Utils.swift
//  Twitter
//
//  Created by Vishal Lakshminarayanappa on 5/16/20.
//  Copyright © 2020 Vishal Lakshminarayanappa. All rights reserved.
//

import UIKit

class Utils {
    
    
    func createContainerView(withImage image : UIImage, withTextField textField : UITextField) -> UIView{
        
        let view = UIView()
        let iv = UIImageView()
        view.heightAnchor.constraint(equalToConstant: 50).isActive = true
        
        iv.image = image.withRenderingMode(.alwaysOriginal)
        view.addSubview(iv)
        iv.anchor(left: view.leftAnchor,bottom: view.bottomAnchor,
                  paddingLeft: 8,paddingBottom: 8,
                  width: 24,height: 24)
        
        
        view.addSubview(textField)
        textField.anchor(left: iv.rightAnchor,bottom: view.bottomAnchor,right: view.rightAnchor
                         ,paddingLeft: 8,paddingBottom: 8)
        
        let dividerView = UIView()
        dividerView.backgroundColor = .white
        
        view.addSubview(dividerView)
        dividerView.anchor(left: view.leftAnchor,bottom: view.bottomAnchor,right: view.rightAnchor,
                           paddingLeft: 8,height: 0.75)
        
        
        
        
        
        return view
        
        
        
    }
    
    func createTextField(withPlaceHolder placeholder : String, isSecure : Bool = false) -> UITextField{
           
        let tf = UITextField()
        tf.textColor = .white
        tf.font = UIFont.systemFont(ofSize: 16)
        tf.attributedPlaceholder = NSAttributedString(string: placeholder,
                                                      attributes: [NSAttributedString.Key.foregroundColor : UIColor.white])
        
        tf.isSecureTextEntry = isSecure
        
        return tf
           
           
       }
    
    func attributedButton(_ firstPart : String,_ secondPart : String) -> UIButton{
        let button = UIButton()
        
        let attTitle = NSMutableAttributedString(string: firstPart,
                                                 attributes: [NSAttributedString.Key.font : UIFont.systemFont(ofSize: 16),
                                                              NSAttributedString.Key.foregroundColor : UIColor.white])
        attTitle.append(NSAttributedString(string: secondPart,
                                           attributes: [NSAttributedString.Key.font : UIFont.boldSystemFont(ofSize: 16),
                                                        NSAttributedString.Key.foregroundColor : UIColor.white]))
        
        button.setAttributedTitle(attTitle, for: .normal)
        
        
        return button
        
        
    }
}
