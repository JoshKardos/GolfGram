//
//  ProfileViewController.swift
//  TuTour
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

	var meeting: MeetingRequest?
	
	@IBAction func tutorButton(_ sender: Any) {
	
		if isOtherUser == false{//is current users profile
		
			let storyboard: UIStoryboard = UIStoryboard(name: "Profile", bundle: nil)
			let subjectsVC = storyboard.instantiateViewController(withIdentifier: "Subjects") as! SubjectsViewController
		
			navigationController?.pushViewController(subjectsVC, animated: true)
			print("HERE" )
		
		} else{//is other users profile
			selectMeetingOptions()
			print("ELSE")
		
		}
	}
	
	func selectMeetingOptions(){
		
		let storyboard: UIStoryboard = UIStoryboard(name: "Profile", bundle: nil)
		let timeOptionsVC = storyboard.instantiateViewController(withIdentifier: "TimeOptions") as! DatePickerViewController
		
		timeOptionsVC.meeting = meeting
		navigationController?.pushViewController(timeOptionsVC, animated: true)
	
		
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
		
		if let otherUser_ID = self.uid {//other users pprofile
			
			self.isOtherUser = true
			fillUserInfo(uid: otherUser_ID)
			registerAsTutorButton.backgroundColor = UIColor.yellow
			registerAsTutorButton.setTitle("Tutor Request", for: .normal)

		} else {//current users profile
		
			let userID : String = (Auth.auth().currentUser?.uid)!
			fillUserInfo(uid: userID)
			isOtherUser = false
			registerAsTutorButton.reloadInputViews()
		
		}
	}
}
