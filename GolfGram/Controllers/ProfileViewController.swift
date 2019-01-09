//
//  ProfileViewController.swift
//  GolfGram
//
//  Created by Josh Kardos on 9/25/18.
//  Copyright © 2018 JoshTaylorKardos. All rights reserved.
//

import UIKit
import FirebaseAuth
import FirebaseDatabase
class ProfileViewController: UIViewController {
	
	@IBOutlet weak var profileImage: UIImageView!
	@IBOutlet weak var usernameLabel: UILabel!
	@IBOutlet weak var emailLabel: UILabel!
	@IBOutlet weak var dmButton: UIBarButtonItem!
	
	
	var uid: String?
	
///////////////////////////////////////////////////////////////////////////////////////////
	//use these variables when view is called programatically
	var usernameText: String?
	var profilePic: UIImageView?
	
	var isStoryboard = true//must change to false if vc is pushed programatically!!
	
	var usernameTextField: UILabel {
	
		let textField = UILabel()
		textField.backgroundColor = UIColor.lightGray
		textField.text = usernameText!
		textField.translatesAutoresizingMaskIntoConstraints = false
//		textField.delegate = self
		textField.textColor = UIColor.white
		return textField

	}
////////////////////////////////////////////////////////////////////////////////////
	
	func setupComponents(){
		let containerView = UIView()
		containerView.backgroundColor = UIColor.white
		containerView.translatesAutoresizingMaskIntoConstraints = false
		view.addSubview(containerView)
		view.backgroundColor = UIColor.white
		
		//constrain top
		containerView.leftAnchor.constraint(equalTo: view.leftAnchor).isActive = true
		containerView.topAnchor.constraint(equalTo: navigationController!.navigationBar.bottomAnchor).isActive = true
		containerView.widthAnchor.constraint(equalTo: view.widthAnchor).isActive = true
		containerView.heightAnchor.constraint(equalTo: view.heightAnchor).isActive = true
		
		usernameTextField.text = usernameText
	
		containerView.addSubview(usernameTextField)
		//usernameTextField.widthAnchor.constraint(equalToConstant: 25)
		usernameTextField.heightAnchor.constraint(equalToConstant: 25)
		
	}
	
	func fillUserInfo(uid: String){
		
		
		Database.database().reference().child("users").child(uid).observeSingleEvent(of: .value, with: {(snapshot) in

			let username = (snapshot.value as! NSDictionary)["username"] as! String
			self.usernameText = username
			
			self.usernameLabel?.text = username
			
			let profileImageString = (snapshot.value as! NSDictionary)["profileImageUrl"] as! String
			let url = URL(string: profileImageString)
			let imageData = NSData.init(contentsOf: url as! URL)
			self.profilePic?.image = UIImage(data: imageData as! Data)
			
			self.profileImage?.image = UIImage(data: imageData as! Data)
			
			let emailString = (snapshot.value as! NSDictionary)["email"] as! String
			self.emailLabel?.text = emailString
			
			if self.isStoryboard == false{
				self.setupComponents()
			}
		})
		
	}
	
    override func viewDidLoad() {
        super.viewDidLoad()
		
		dmButton?.tintColor = UIColor.flatGreenDark
		print("HERE*")
		
		let userID : String = (Auth.auth().currentUser?.uid)!
		
		if isStoryboard == true{
			fillUserInfo(uid: userID)
		}else {
			fillUserInfo(uid: uid!)
			
		}
	}
}
