//
//  SignUpController.swift
//  Twitter
//
//  Created by Vishal Lakshminarayanappa on 5/10/20.
//  Copyright © 2020 Vishal Lakshminarayanappa. All rights reserved.
//

import UIKit
import Firebase

class  SignUpController : UIViewController{
    
    
    //MARK: Properties
    
    private var profileImage : UIImage?
    private let imagePicker = UIImagePickerController()
    
    private let plusPhotoButton : UIButton = {
        let button = UIButton(type: .system)
        button.setImage(#imageLiteral(resourceName: "plus_photo"), for: .normal)
        button.tintColor = .white
        button.addTarget(self, action: #selector(handleAddProfilePhoto), for: .touchUpInside)
        return button
    }()
    
    private lazy var emailContainerView  : UIView = {
        
        let view = Utils().createContainerView(withImage: #imageLiteral(resourceName: "mail"), withTextField: emailTextField)
        return view
    }()
    
    private lazy var passwordContainerView  : UIView = {
        
        let view = Utils().createContainerView(withImage: #imageLiteral(resourceName: "ic_lock_outline_white_2x"), withTextField: passwordTextField)
        return view
    }()
    
    private lazy var fullnameContainerView  : UIView = {
        
        let view = Utils().createContainerView(withImage: #imageLiteral(resourceName: "ic_person_outline_white_2x"), withTextField: fullnameTextField)
        return view
    }()
    private lazy var usernameContainerView  : UIView = {
        
        let view = Utils().createContainerView(withImage: #imageLiteral(resourceName: "ic_person_outline_white_2x"), withTextField: usernameTextField)
        return view
    }()
    
    private let emailTextField : UITextField = {
        return Utils().createTextField(withPlaceHolder: "Email")
    }()
    
    private let passwordTextField : UITextField = {
        return Utils().createTextField(withPlaceHolder: "Password",isSecure: true)
    }()
    private let fullnameTextField : UITextField = {
        return Utils().createTextField(withPlaceHolder: "Full name")
    }()
    private let usernameTextField : UITextField = {
        return Utils().createTextField(withPlaceHolder: "Username")
    }()
    
    private let signUpButton  :UIButton = {
        let button = CustomButton(title: "Sign Up")
        button.addTarget(self, action: #selector(handleSignUp), for: .touchUpInside)
        return button
        
    }()
    
    
    
    private let alreadyHaveAccountButton : UIButton = {
        
        let button =  Utils().attributedButton("Already have account?", " Sign In")
        button.addTarget(self, action: #selector(showSignIn), for: .touchUpInside)
        return button
    }()
    
    //MARK: Life Cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        configureUI()
    }
    
    
    //MARK: Selector
    
    @objc func handleSignUp(){
        guard let profileImage = profileImage else {return}
        guard let email = emailTextField.text else {return}
        guard let password = passwordTextField.text else {return}
        guard let fullname = fullnameTextField.text else {return}
        guard let username = usernameTextField.text?.lowercased() else {return}
        

        let credential = AuthCredential(email: email, password: password, fullname: fullname, username: username, profileImage: profileImage)
        
        AuthService.shared.registerUser(credential: credential) {[weak self] (error, ref) in
            
        
            if let error = error{
                
                print("Error Sign up : \(error.localizedDescription)")
            }
            
            guard let window = UIApplication.shared.windows.first(where: {$0.isKeyWindow}) else {return}
            
            guard let controller = window.rootViewController as? MainTabController else {return}
            controller.checkIfUserISLoggedIn()
            self?.dismiss(animated: true, completion: nil)
            
            
        }
    
        
    }
    @objc func handleAddProfilePhoto(){
        present(imagePicker, animated: true, completion: nil)
    }
    
    @objc func showSignIn(){
        navigationController?.popViewController(animated: true)
        
    }
    
    //MARK: Helper Function
    
    func configureUI(){
        
        view.backgroundColor = .mainBlue
        imagePicker.delegate = self
        imagePicker.allowsEditing = true
        
        view.addSubview(plusPhotoButton)
        plusPhotoButton.centerX(inView: self.view)
        plusPhotoButton.anchor(top: view.safeAreaLayoutGuide.topAnchor,paddingTop: 0,
                               width: 150,height: 150)
        
        
        let stack = UIStackView(arrangedSubviews: [emailContainerView, passwordContainerView, fullnameContainerView,
                                                   usernameContainerView,signUpButton])
        stack.axis = .vertical
        stack.spacing = 20
        stack.distribution = .fillEqually
        
        
        view.addSubview(stack)
        stack.anchor(top:plusPhotoButton.bottomAnchor,left: view.leftAnchor,right: view.rightAnchor,
                     paddingLeft: 32,paddingRight: 32)
        
        view.addSubview(alreadyHaveAccountButton)
        alreadyHaveAccountButton.anchor(left : view.leftAnchor,bottom: view.safeAreaLayoutGuide.bottomAnchor,right: view.rightAnchor,
                                        paddingLeft: 40,paddingRight: 40)
    }
    
}

//MARK: UIImagePickerDelegate

extension SignUpController : UIImagePickerControllerDelegate,UINavigationControllerDelegate{
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        
        
        guard let profileImage = info[.editedImage] as? UIImage else {return}
        
        self.profileImage = profileImage
        
        self.plusPhotoButton.setImage(profileImage.withRenderingMode(.alwaysOriginal), for: .normal)
        plusPhotoButton.layer.cornerRadius = 150/2
        plusPhotoButton.layer.masksToBounds = true
        plusPhotoButton.imageView?.contentMode = .scaleAspectFill
        plusPhotoButton.imageView?.clipsToBounds = true
        plusPhotoButton.layer.borderColor = UIColor.white.cgColor
        plusPhotoButton.layer.borderWidth = 3
        
        dismiss(animated: true, completion: nil)
    }
    
}
