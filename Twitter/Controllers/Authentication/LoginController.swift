//
//  LoginController.swift
//  Twitter
//
//  Created by Vishal Lakshminarayanappa on 5/10/20.
//  Copyright © 2020 Vishal Lakshminarayanappa. All rights reserved.
//

import UIKit

class  LoginController : UIViewController{
    
    
    //MARK: Properties
    
    private let logoImageView : UIImageView = {
        let iv = UIImageView()
        iv.contentMode = .scaleAspectFit
        iv.clipsToBounds = true
        iv.image = #imageLiteral(resourceName: "TwitterLogo")
        return iv
    }()
    
    private lazy var emailContainerView  : UIView = {
        
        let view = Utils().createContainerView(withImage: #imageLiteral(resourceName: "mail"), withTextField: emailTextField)
        return view
    }()
    
    private lazy var passwordContainerView  : UIView = {
        
        let view = Utils().createContainerView(withImage: #imageLiteral(resourceName: "ic_lock_outline_white_2x"), withTextField: passwordTextField)
        return view
    }()
    
    private let emailTextField : UITextField = {
        return Utils().createTextField(withPlaceHolder: "Email")
    }()
    
    private let passwordTextField : UITextField = {
        return Utils().createTextField(withPlaceHolder: "Password",isSecure: true)
    }()
    
    private let loginButton  :UIButton = {
        let button = CustomButton(title: "Login")
        button.addTarget(self, action: #selector(handleLogin), for: .touchUpInside)
        return button
        
    }()
    
    private let dontHaveAccountButton : UIButton = {
        
        let button =  Utils().attributedButton("Don't have account?", " Sign Up")
        button.addTarget(self, action: #selector(showSignUp), for: .touchUpInside)
        return button
    }()
    
    
    
    //MARK: Life Cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        configureUI()
    }
    
    
    //MARK: Selector
    
    @objc func handleLogin(){
        guard let email = emailTextField.text else {return}
        guard let password = passwordTextField.text else {return}
        
        
        AuthService.shared.signUser(email: email, password: password) { [weak self](result, error) in
            if let error = error{
                print("Error login \(error.localizedDescription)")
                
            }
            
            
            guard let window = UIApplication.shared.windows.first(where: {$0.isKeyWindow}) else {return}
            
            guard let controller = window.rootViewController as? MainTabController else {return}
            controller.checkIfUserISLoggedIn()
            self?.dismiss(animated: true, completion: nil)
            
            
        }
    }
    
    @objc func showSignUp(){
        let controller = SignUpController()
        
        navigationController?.pushViewController(controller, animated: true)
        
    }
    
    //MARK: Helper Function
    
    func configureUI(){
 
        setupNavigation()
        view.addSubview(logoImageView)
        logoImageView.centerX(inView: self.view)
        logoImageView.anchor(top: view.safeAreaLayoutGuide.topAnchor,paddingTop: 0,
                             width: 150,height: 150)
        
        
        let stack = UIStackView(arrangedSubviews: [emailContainerView,passwordContainerView,loginButton])
        stack.axis = .vertical
        stack.spacing = 20
        stack.distribution = .fillEqually
        
        
        view.addSubview(stack)
        stack.anchor(top:logoImageView.bottomAnchor,left: view.leftAnchor,right: view.rightAnchor,
                     paddingLeft: 32,paddingRight: 32)
        
        view.addSubview(dontHaveAccountButton)
        dontHaveAccountButton.anchor(left : view.leftAnchor,bottom: view.safeAreaLayoutGuide.bottomAnchor,right: view.rightAnchor,
                                     paddingLeft: 40,paddingRight: 40)
    }
    
}


extension LoginController{
    
    
    func setupNavigation(){
        
         view.backgroundColor = .mainBlue
         navigationController?.navigationBar.barStyle = .black
         navigationController?.navigationBar.isHidden = true
    }
    
}


//MARK: Properties

//MARK: Life Cycle

//MARK: Selector

//MARK: Helper Function
