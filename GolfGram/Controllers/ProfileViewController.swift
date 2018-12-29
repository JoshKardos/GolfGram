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
	
    override func viewDidLoad() {
        super.viewDidLoad()
	
		dmButton?.tintColor = UIColor.flatGreenDark
		
		
		let userID : String = (Auth.auth().currentUser?.uid)!
		print("Current user ID is" + userID)
		
		Database.database().reference().child("users").child(userID).observeSingleEvent(of: .value, with: {(snapshot) in
			print("******* \(snapshot.value)")
			
			let username = (snapshot.value as! NSDictionary)["username"] as! String
		
			self.usernameLabel?.text = username
			
			let profileImageString = (snapshot.value as! NSDictionary)["profileImageUrl"] as! String
			let url = URL(string: profileImageString)
			let imageData = NSData.init(contentsOf: url as! URL)
			self.profileImage?.image = UIImage(data: imageData as! Data)

			let emailString = (snapshot.value as! NSDictionary)["email"] as! String
			self.emailLabel?.text = emailString
			
			print(username)
			
			
		})
	}
}
