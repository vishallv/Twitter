//
//  EditProfileController.swift
//  Twitter
//
//  Created by Vishal Lakshminarayanappa on 5/23/20.
//  Copyright © 2020 Vishal Lakshminarayanappa. All rights reserved.
//

import UIKit

private let reuseIdentifier = "EditProfileControllerCell"
protocol EditProfileControllerDelegate : class{
    func controller(_ controller : EditProfileController,updateUser user : User)
    func logOutTheUser()
}

class EditProfileController : UITableViewController{
    //MARK: Properties
    
    private var user : User
    private lazy var headerView = EditProfileHeader(user: user)
    private let imagePicker = UIImagePickerController()
    private let footerView = EditProfileFooter()
    private var userInfoChanged = false
    private var imageChanged :Bool{
        return selectedImage != nil
    }
    
    weak var delegate : EditProfileControllerDelegate?
    
    private var selectedImage : UIImage?{
        didSet{
            headerView.profileImageView.image = selectedImage
        }
    }
    
    //MARK: Life Cycle
    
    init(user : User) {
        self.user = user
        super.init(style: .plain)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        configureNavigationBar()
        configureUI()
    }
    
    //MARK: Selector
    @objc func handleCancelPressed(){
        self.dismiss(animated: true, completion: nil)
    }
    
    @objc func handleSave(){
        view.endEditing(true)
        guard imageChanged || userInfoChanged else {return}
        updateUserData()
        
    }
    
    //MARK: API
    
    func updateUserData(){
        if imageChanged && !userInfoChanged{
            print("ONLY PHOTO")
            updateProfileImage()
        }
        if !imageChanged && userInfoChanged{
            print("ONLY TEXT")
            UserService.shared.saveUserData(user: user) { (err, ref) in
                
                self.delegate?.controller(self, updateUser: self.user)
                //            self?.dismiss(animated: true, completion: nil)
            }
        }
        
        if imageChanged && userInfoChanged{
            print("BOTH")
            UserService.shared.saveUserData(user: user) { (err, ref) in
                self.updateProfileImage()
            }
        }
        
        
    }
    
    func updateProfileImage(){
        guard let image = selectedImage else {return}
        
        UserService.shared.updateProfileImage(image: image) { (profileImageURl) in
            self.user.profileImageURL = profileImageURl
            
            self.delegate?.controller(self, updateUser: self.user)
        }
    }
    
    //MARK: Helper Function
    
    func configureNavigationBar(){
        navigationController?.navigationBar.barTintColor = .mainBlue
        navigationController?.navigationBar.barStyle = .black
        navigationController?.navigationBar.isTranslucent = false
        title = "Edit Profile"
        navigationController?.navigationBar.tintColor = .white
        navigationItem.leftBarButtonItem = UIBarButtonItem(barButtonSystemItem: .cancel, target: self, action: #selector(handleCancelPressed))
        navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .save, target: self, action: #selector(handleSave))
//        navigationItem.rightBarButtonItem?.isEnabled = false
    }
    
    func configureUI(){
        
        tableView.tableHeaderView = headerView
        tableView.register(EditProfileCell.self, forCellReuseIdentifier: reuseIdentifier)
        footerView.delegate = self
        footerView.frame = CGRect(x: 0, y: 0, width: view.frame.width, height: 50)
        headerView.frame = CGRect(x: 0, y: 0, width: view.frame.width, height: 180)
        tableView.tableFooterView = footerView
        headerView.delegate = self
        
        imagePicker.delegate = self
        imagePicker.allowsEditing = true
        
    }
}

extension EditProfileController : EditProfileHeaderDelegate{
    func didTapProfilePhoto() {
        present(imagePicker, animated: true, completion: nil)
    }
    
    
}
extension EditProfileController {
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return EditProfileOption.allCases.count
        
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: reuseIdentifier, for: indexPath) as! EditProfileCell
        
        guard let type = EditProfileOption(rawValue: indexPath.row) else {return cell}
        let viewModel = EditProfileViewModel(user: user, type: type)
        cell.viewModel = viewModel
        cell.delegate = self
        return cell
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        guard let option = EditProfileOption(rawValue: indexPath.row) else {return 0}
        
        if option == .bio{
            return 100
        }
        
        return 48
    }
    
   
}

extension EditProfileController : UINavigationControllerDelegate , UIImagePickerControllerDelegate{
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        
        guard let image = info[.editedImage] as? UIImage else {return}
        self.selectedImage = image
        dismiss(animated: true, completion: nil)
    }
}


extension EditProfileController : EditProfileCellDelegate{
    func updateUserInfo(_ cell: EditProfileCell) {
        guard let viewModel = cell.viewModel else {return}
        
        userInfoChanged = true
        navigationItem.rightBarButtonItem?.isEnabled = true
        switch viewModel.type{
            
        case .fullname:
            guard let fullname = cell.infoTextField.text else {return}
            user.fullname = fullname
        case .username:
            guard let username = cell.infoTextField.text else {return}
            user.username = username
        case .bio:
            user.bio = cell.bioTextView.text
            
        }
        
    }
    
    
}

extension EditProfileController : EditProfileFooterDelegate{
    func handleLogOut() {
        let alert = UIAlertController(title: nil, message: "Are you sure you want to log out?", preferredStyle: .actionSheet)
        
        alert.addAction(UIAlertAction(title: "Log Out", style: .destructive, handler: { (_) in
            self.dismiss(animated: true) {
                self.delegate?.logOutTheUser()
            }
        }))
        
        alert.addAction(UIAlertAction(title: "cancel", style: .cancel, handler: nil))
        
        present(alert, animated: true, completion: nil)
    }
    
    
}
