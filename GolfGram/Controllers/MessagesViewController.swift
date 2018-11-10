//
//  MessagesViewController.swift
//  GolfGram
//
//  Created by Josh Kardos on 11/3/18.
//  Copyright © 2018 JoshTaylorKardos. All rights reserved.
//

import Foundation
import UIKit
import FirebaseDatabase
import FirebaseAuth
class MessagesViewController:UITableViewController{
	
	var usersMessaged = [User]()
	var databaseRef = Database.database().reference()

	var messages = [Message]()
	
	
	override func viewDidLoad() {
		
		
		super.viewDidLoad()
		tableView.dataSource = self
		
		
		usersMessaged.removeAll()
		loadUsersMessaged()
		
		
	}
	override func viewWillAppear(_ animated: Bool) {
		
		usersMessaged.removeAll()
		loadUsersMessaged()
	
	}
		//rows in table
	override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {

		return self.messages.count///self.usersMessaged.count
	
	}
	//text to put in cell
	override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
		let cell = tableView.dequeueReusableCell(withIdentifier: "userMessageCell", for: indexPath)
		
		let message = messages[indexPath.row]
		
//		if let toId = message.toId {
//
//			let ref = databaseRef.child("users")
//
//		}
		
		
		cell.textLabel?.text = message.text
			
//		let cell = tableView.dequeueReusableCell(withIdentifier: "userMessageCell", for: indexPath) as! UserCellViewController
//
//		let user = usersMessaged[indexPath.row]
//
//		let url = URL(string: user.profileImageUrl as! String)//NSURL.init(fileURLWithPath: posts[indexPath.row].photoUrl)
//		let imageData = NSData.init(contentsOf: url as! URL)
//
//		cell.cellImage.image = UIImage(data: imageData as! Data)
//		cell.cellLabel.text = user.username as? String
//
//		//checkFollowing(indexPath: indexPath)
//
		return cell
		
	}

	//when row is sleected
	override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
		
	}
	

	func loadUsersMessaged(){
		
		let ref = Database.database().reference().child("messages")
		
		ref.observe(.childAdded) { (snapshot) in
			if let dictionary = snapshot.value as? [String: Any]{
				
				let message = Message(senderIdString: dictionary["senderID"] as! String, textString: dictionary["text"] as! String, timestampFloat: dictionary["timestamp"] as! NSNumber, toIdString: dictionary["toId"] as! String)
				print(message.text!)
				self.messages.append(message)
				
				DispatchQueue.main.async {
					self.tableView.reloadData()
				}
				
			}
		}
	
	}
	
	private func setupNameAndProfileImage(message: Message){
		let chatPartnerId: String?
	
		let uid = Auth.auth().currentUser!.uid
		
		if message.senderId == uid{
			
			chatPartnerId = message.toId
		}else{
			chatPartnerId = message.senderId
		}
		
		if let id = chatPartnerId {
			
			let ref = Database.database().reference().child("users").child(id)
			ref.observeSingleEvent(of: .value) { (snapshot) in
				if let dictionary = snapshot.value as? [String: Any]{
					/*
					self.textLabel?.text = dictionary["username"] as? String
					if let profileImageUrl = dictionary["profileImageUrl"] as? String{
						self.profileImageView.loadImagesUsingCacheWithUrlString(profileImageUrl)
					}
			

					*/
				}
			}
			
		}
	}
}
