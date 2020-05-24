//
//  AuthService.swift
//  Twitter
//
//  Created by Vishal Lakshminarayanappa on 5/16/20.
//  Copyright © 2020 Vishal Lakshminarayanappa. All rights reserved.
//

import UIKit
import Firebase


struct AuthCredential {
    let email : String
    let password : String
    let fullname : String
    let username : String
    let profileImage : UIImage
    
}


struct AuthService {
    
    static let shared = AuthService()
    
    private init() { }
    
    
    func signUser(email : String, password : String,completion: AuthDataResultCallback?){
        
        Auth.auth().signIn(withEmail: email, password: password, completion: completion)
        
    }
    
    
    func registerUser( credential : AuthCredential,completion : @escaping(Error?,DatabaseReference?)->Void){

        guard let imageData = credential.profileImage.jpegData(compressionQuality: 0.3) else {
            print("could not")
            return}
        let filename = NSUUID().uuidString
        let storageRef = STORAGE_PROFILE_IMAGES.child(filename)
        
        storageRef.putData(imageData, metadata: nil) { (meta, error) in

            
            storageRef.downloadURL { (url, error) in
                
                guard let profileImageURL = url?.absoluteString else {return}
                
                Auth.auth().createUser(withEmail: credential.email, password: credential.password) { (result, error) in
                    if let error = error{
                        
                        print("DEBUG Error : \(error.localizedDescription)" )
                        return
                        
                    }
                    
                    guard let uid = result?.user.uid else { return }
                    
                    let dictionary = ["email": credential.email,
                                      "fullname": credential.fullname,
                                      "username": credential.username,
                                      "profileImageURL":profileImageURL]
                    
                    REF_USERS.child(uid).updateChildValues(dictionary, withCompletionBlock: completion)
                    
                    
                }
                
            }
            
        }
        
    }
    
    
}
