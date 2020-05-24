//
//  EditProfileCell.swift
//  Twitter
//
//  Created by Vishal Lakshminarayanappa on 5/23/20.
//  Copyright © 2020 Vishal Lakshminarayanappa. All rights reserved.
//

import UIKit

protocol EditProfileCellDelegate : class {
    func updateUserInfo(_ cell : EditProfileCell)
}

class EditProfileCell : UITableViewCell{
    
    //MARK: Properties
    var viewModel : EditProfileViewModel?{
        didSet{
            configure()
        }
    }
    
    weak var delegate : EditProfileCellDelegate?
    
    let titleLabel : UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 14)
        label.text = "Name"
        return label
    }()
    
    lazy var infoTextField  : UITextField = {
        let tf = UITextField()
        tf.borderStyle = .none
        tf.font = UIFont.systemFont(ofSize: 14)
        tf.textAlignment = .left
        tf.textColor = .mainBlue
        tf.text = "Vishal"
        tf.addTarget(self, action: #selector(handleTextChanged), for: .editingDidEnd)
        return tf
    }()
    
    let bioTextView : UITextView = {
        let tv = UITextView()
        tv.font = UIFont.systemFont(ofSize: 14)
        tv.textColor = .mainBlue
//        tv.text = "Bio"
        return tv
    }()
    
    //MARK: Life Cycle
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        selectionStyle = .none
        
        addSubview(titleLabel)
        titleLabel.widthAnchor.constraint(equalToConstant: 100).isActive = true
        titleLabel.anchor(top : topAnchor, left:  leftAnchor, paddingTop: 12, paddingLeft: 16)
        
        addSubview(infoTextField)
        infoTextField.anchor(top: topAnchor,left: titleLabel.rightAnchor,bottom: bottomAnchor,right: rightAnchor,
                             paddingTop: 4,paddingLeft: 16,paddingRight: 8)
        
        addSubview(bioTextView)
        bioTextView.anchor(top: topAnchor,left: titleLabel.rightAnchor,bottom: bottomAnchor,right: rightAnchor,
                             paddingTop: 4,paddingLeft: 16,paddingRight: 8)
        
        NotificationCenter.default.addObserver(self, selector: #selector(handleTextChanged), name: UITextView.textDidEndEditingNotification, object: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    //MARK: Selector
    
    @objc func handleTextChanged(){
        
        delegate?.updateUserInfo(self)
    }
    
    //MARK: Helper Function
    func configure(){
        guard let viewModel = viewModel else {return}
        
        infoTextField.isHidden = viewModel.shouldHideTextField
        bioTextView.isHidden = viewModel.shouldHideBioView
        titleLabel.text = viewModel.titleLabelText
        
        infoTextField.text = viewModel.optionValue
        bioTextView.text = viewModel.optionValue
        
    }
}

