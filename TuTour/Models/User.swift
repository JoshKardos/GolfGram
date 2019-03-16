//
//  User.swift
//  TuTour
//
//  Created by Josh Kardos on 11/3/18.
//  Copyright © 2018 JoshTaylorKardos. All rights reserved.
//

import Foundation
import FirebaseDatabase
class User: NSObject{
	var email: String?
	var followers: NSDictionary?
	var following: NSDictionary?
	var profileImageUrl: String?
	var uid: String?
	var username: String?
	
	override init(){
		super.init()
	}
	init(emailString: String, followersStrings: NSDictionary, followingStrings: NSDictionary, profileImageUrlString: String, uidString: String, usernameString: String){
		email = emailString
		followers = followersStrings
		following = followingStrings
		profileImageUrl = profileImageUrlString
		uid = uidString
		username = usernameString
	}
	init(emailString: String, profileImageUrlString: String, uidString: String, usernameString: String){
		email = emailString
		profileImageUrl = profileImageUrlString
		uid = uidString
		username = usernameString
	}
    init(json: [String: AnyObject]){
        email = json["email"] as! String
        profileImageUrl = json["profileImageUrl"] as! String
        uid = json["uid"] as! String
        username = json["username"] as! String
    }
//	init(uid: String){
//		Database.database().reference().child("users").child(uid).observe(.value) { (snapshot) in
//			print(snapshot)
//			let user = snapshot.value as! NSDictionary
//			
//			print(user["email"] as! String)
//			
//			
//			self.email = user["email"] as! String
//			self.profileImageUrl = user["profileImageUrl"] as! String
//			self.uid = user["uid"] as! String
//			self.username = user["username"] as! String
//		}
//	}
}
