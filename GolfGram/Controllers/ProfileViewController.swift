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
	@IBOutlet weak var registerAsTutorButton: UIButton!
	
	var isOtherUser = false//must change to false if vc is pushed programatically!!
	
	var uid: String?

	
//	func setupComponents(){
//		let containerView = UIView()
//		containerView.backgroundColor = UIColor.white
//		containerView.translatesAutoresizingMaskIntoConstraints = false
//		view.addSubview(containerView)
//		view.backgroundColor = UIColor.white
//
//		//constrain top
//		containerView.leftAnchor.constraint(equalTo: view.leftAnchor).isActive = true
//		containerView.topAnchor.constraint(equalTo: navigationController!.navigationBar.bottomAnchor).isActive = true
//		containerView.widthAnchor.constraint(equalTo: view.widthAnchor).isActive = true
//		containerView.heightAnchor.constraint(equalTo: view.heightAnchor).isActive = true
//
//		usernameTextField.text = usernameText
//
//		containerView.addSubview(usernameTextField)
//		//usernameTextField.widthAnchor.constraint(equalToConstant: 25)
//		usernameTextField.heightAnchor.constraint(equalToConstant: 25)
//
//	}
	

	@IBAction func tutorButton(_ sender: Any) {
	
				if isOtherUser == false{
		
					let storyboard: UIStoryboard = UIStoryboard(name: "Profile", bundle: nil)
					let subjectsVC = storyboard.instantiateViewController(withIdentifier: "Subjects") as! SubjectsViewController
		
					navigationController?.pushViewController(subjectsVC, animated: true)
					print("HERE" )
				} else{
					print("ELSE")
				}
	}
	
	func disableComponents(){
		
		dmButton.isEnabled = false
		dmButton.image = nil
		dmButton.title = nil

		
	}
	
	func fillUserInfo(uid: String){
		
		
		Database.database().reference().child("users").child(uid).observeSingleEvent(of: .value, with: {(snapshot) in

			let username = (snapshot.value as! NSDictionary)["username"] as! String
			self.usernameLabel?.text = username
			
			
			let profileImageString = (snapshot.value as! NSDictionary)["profileImageUrl"] as! String
			let url = URL(string: profileImageString)
			let imageData = NSData.init(contentsOf: url as! URL)
			self.profileImage?.image = UIImage(data: imageData as! Data)
			
			
			let emailString = (snapshot.value as! NSDictionary)["email"] as! String
			self.emailLabel?.text = emailString
			
		})
		
	}
	
    override func viewDidLoad() {
        super.viewDidLoad()
		
		dmButton?.tintColor = UIColor.flatGreenDark
		registerAsTutorButton?.backgroundColor = UIColor.white
		
		if let otherUser_ID = self.uid {
			
			self.isOtherUser = true
			print("OTHER USR")
			fillUserInfo(uid: otherUser_ID)
			registerAsTutorButton.backgroundColor = UIColor.yellow
			registerAsTutorButton.setTitle("Tutor Request", for: .normal)

		} else {
		
			let userID : String = (Auth.auth().currentUser?.uid)!
			fillUserInfo(uid: userID)
			isOtherUser = false
			registerAsTutorButton.reloadInputViews()
		
		}
	}
}
