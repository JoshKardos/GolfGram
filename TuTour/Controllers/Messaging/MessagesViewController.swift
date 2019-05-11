//
//  MessagesViewController.swift
//  TuTour
//
//  Created by Josh Kardos on 11/3/18.
//  Copyright © 2018 JoshTaylorKardos. All rights reserved.
//

import Foundation
import UIKit
import FirebaseDatabase
import FirebaseAuth
import ProgressHUD
class MessagesViewController:UITableViewController{
	
	var usersMessaged = [User]()
	var databaseRef = Database.database().reference()

	var messages = [Message]()
	var messagesDictionary = [String: Message]()
	
	override func viewDidLoad() {
		
//        ProgressHUD.show("Loading...")
		super.viewDidLoad()
		tableView.dataSource = self
		
		
		usersMessaged.removeAll()
		loadUserMessages()
		
	}
	override func viewWillAppear(_ animated: Bool) {
		
	
	}
		//rows in table
	override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {

		return self.messagesDictionary.count///self.usersMessaged.count
	
	}
	//text to put in cell
	override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
		
		let cell = tableView.dequeueReusableCell(withIdentifier: "userMessageCell", for: indexPath) as! MessageCell
		
		let message = messages[indexPath.row]
		
		cell.message = message
		
		return cell
		
	}
	
	override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
		return 72
	}

	//when row is sleected
	override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
		
		let message = messages[indexPath.row]
		
		guard let chatPartnerId = message.chatPartnerId() else {
			return
		}

		let ref = Database.database().reference().child("users").child(chatPartnerId)
		
		ref.observeSingleEvent(of: .value) { (snapshot) in
			
			
			guard let dictionary = snapshot.value as? [String: AnyObject] else{ return }
			
			
			//some users may not have followers or following, may bring an error later?
			var user = self.validUser(dictionary: dictionary)
			
			user!.uid = chatPartnerId
			
			self.showChatController(otherUser: user!)
			
		}

	}
	
	
	//method allows for a user without any followers or following be created as a valid user
	func validUser(dictionary: [String: AnyObject]) -> User?{
		
		if let followers = dictionary["followers"]{
			if let following =  dictionary["following"]{
				return User(emailString: dictionary["email"] as! String, followersStrings: dictionary["followers"] as! NSDictionary, followingStrings: dictionary["following"] as! NSDictionary, profileImageUrlString: dictionary["profileImageUrl"] as! String, uidString: dictionary["uid"]as! String, usernameString: dictionary["username"]as! String)
			}
			else {
				return User(emailString: dictionary["email"] as! String, profileImageUrlString: dictionary["profileImageUrl"] as! String, uidString: dictionary["uid"]as! String, usernameString: dictionary["username"]as! String)
			}
		} else {
			return User(emailString: dictionary["email"] as! String, profileImageUrlString: dictionary["profileImageUrl"] as! String, uidString: dictionary["uid"]as! String, usernameString: dictionary["username"]as! String)
		}
		
	}
	func showChatController(otherUser: User){
		
		let chatLogController = ChatLogViewController()
		
		chatLogController.otherUser = otherUser
		
		navigationController?.pushViewController(chatLogController, animated: true)
	}
	
	
	
	func loadUserMessages(){
		
		guard let uid = Auth.auth().currentUser?.uid else{
			return
		}
		//ref of users messages keys
		let ref = Database.database().reference().child("user-messages").child(uid)
		
		//iterate through messages keys
		ref.observe(.childAdded) { (snapshot) in
			
			//reference to message by using message key
			let messageId = snapshot.key
			let messageRef = Database.database().reference().child("messages").child(messageId)
			
			
			//observe message reference
			messageRef.observe(.value, with: { (snapshot) in
				
				if let dictionary = snapshot.value as? [String: Any]{
					
					let message = Message(senderIdString: dictionary["senderID"] as! String, textString: dictionary["text"] as! String, timestampFloat: dictionary["timestamp"] as! NSNumber, toIdString: dictionary["toId"] as! String)

					//should always work
					if let toId = message.chatPartnerId()  {
	
							self.messagesDictionary[toId] = message
							self.messages = Array(self.messagesDictionary.values)
							self.messages.sort(by: { (m1, m2) -> Bool in
								return (m1.timestamp!.intValue > m2.timestamp!.intValue)
							})
					}
					
					self.timer?.invalidate()
					self.timer = Timer.scheduledTimer(timeInterval: 0.1, target: self, selector: #selector(self.handleReloadTable), userInfo: nil, repeats: false)
					
			
				}
			})
		}
	}
	
	var timer: Timer?
	@objc func handleReloadTable(){
		DispatchQueue.main.async {
			self.tableView.reloadData()
		}
	}
}
