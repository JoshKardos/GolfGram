//
//  User.swift
//  TuTour
//
//  Created by Josh Kardos on 11/3/18.
//  Copyright © 2018 JoshTaylorKardos. All rights reserved.
//

import Foundation
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
}
