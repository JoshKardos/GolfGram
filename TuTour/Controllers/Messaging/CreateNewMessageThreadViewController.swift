//
//  CreateNewMessageThreadViewController.swift
//  TuTour
//
//  Created by Josh Kardos on 9/25/18.
//  Copyright © 2018 JoshTaylorKardos. All rights reserved.
//

import UIKit
import FirebaseDatabase
import FirebaseAuth
import ProgressHUD
class CreateNewMessageThreadViewController: UITableViewController, UISearchResultsUpdating {
	
	let searchController = UISearchController(searchResultsController: nil)
	@IBOutlet weak var searchBar: UISearchBar!
	
	
	static var usersArray = [NSDictionary?]()
	var filteredUsers = [NSDictionary?]()
	var personToMessage = [NSDictionary?]()
	
	var databaseRef = Database.database().reference()
	var chatLogController: ChatLogViewController?
	
	override func viewDidLoad() {
		super.viewDidLoad()
		
		searchController.searchResultsUpdater = self
		searchController.dimsBackgroundDuringPresentation = false
		searchController.searchBar.tintColor = AppDelegate.theme_Color
		definesPresentationContext = true
		tableView.tableHeaderView = searchController.searchBar
		
		//remove in order to mae sure its a fresh search fucntion when signing in
		CreateNewMessageThreadViewController.usersArray.removeAll()
		databaseRef.child("users").queryOrdered(byChild: "name").observe(.childAdded) { (snapshot) in
			CreateNewMessageThreadViewController.usersArray.append(snapshot.value as? NSDictionary)
			
			//self.insert
		}
	}
	
	func showChatController(otherUser: User){
		
		let chatLogController = ChatLogViewController()
		chatLogController.otherUser = otherUser
	
		navigationController?.pushViewController(chatLogController, animated: true)
	}
	
	
	//MARK: - Tableview Methods
	
	//rows in table
	override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
		if searchController.isActive && searchController.searchBar.text != ""{
			return filteredUsers.count
		}
		
		return 0
	}
	
	//text to put in cell
	override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
		
		let cell = tableView.dequeueReusableCell(withIdentifier: "userCell", for: indexPath) as! UserCellInNewMessages
		
		let user : NSDictionary?
		
		if searchController.isActive && searchController.searchBar.text != ""{
			user = filteredUsers[indexPath.row]

			
		} else {
			user = DiscoverViewController.usersArray[indexPath.row]
		}
		
		let url = URL(string: user?["profileImageUrl"] as! String)//NSURL.init(fileURLWithPath: posts[indexPath.row].photoUrl)
		let imageData = NSData.init(contentsOf: url as! URL)
		
		cell.cellImage.image = UIImage(data: imageData as! Data)
		cell.cellLabel.text = user?["username"] as? String
		return cell
	}
	
	//when row is selected
	override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
		var otherUserObject: User?
		let uid = Auth.auth().currentUser!.uid
		let refUsers = Database.database().reference().child("users")
		let refMessages = Database.database().reference().child("messages")
		if searchController.isActive && searchController.searchBar.text != ""{
			dismiss(animated: true) {

				let otherUser = self.filteredUsers[indexPath.row]
				if otherUser!["uid"] as! String != uid{
					
					//ugly code because null exception is thrown when trying to message a user with no followers or follwing
					if let followers = otherUser!["followers"]{
						if let following =  otherUser!["following"]{
							otherUserObject = User(emailString: otherUser!["email"] as! String, followersStrings: otherUser!["followers"] as! NSDictionary, followingStrings: otherUser!["following"] as! NSDictionary, profileImageUrlString: otherUser!["profileImageUrl"] as! String, uidString: otherUser!["uid"]as! String, usernameString: otherUser!["username"]as! String)
						}
						else {
							otherUserObject = User(emailString: otherUser!["email"] as! String, profileImageUrlString: otherUser!["profileImageUrl"] as! String, uidString: otherUser!["uid"]as! String, usernameString: otherUser!["username"]as! String)
						}
					} else {
						otherUserObject = User(emailString: otherUser!["email"] as! String, profileImageUrlString: otherUser!["profileImageUrl"] as! String, uidString: otherUser!["uid"]as! String, usernameString: otherUser!["username"]as! String)
					}
					
					
					self.showChatController(otherUser: otherUserObject!)
				} else{
					ProgressHUD.showError("Cannot message yourself")
				}
		
			}
		}
		else{
			ProgressHUD.showError("Search for someone")
		}
	}
	
}

//MARK: - Search Bar Methods
extension CreateNewMessageThreadViewController: UISearchBarDelegate{
	
	
	func updateSearchResults(for searchController: UISearchController){
		filterContent(searchText: self.searchController.searchBar.text!)
	}
	
	func filterContent(searchText: String){
		
		self.filteredUsers = CreateNewMessageThreadViewController.usersArray.filter{ user in
			
			let username = user!["username"] as? String
			
			return(username?.lowercased().contains(searchText.lowercased()))!
			
		}
		
		tableView.reloadData()
		
	}
	
	func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
		tableView.reloadData()
		
	}
	
	//search bar text changed
	func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
		if searchBar.text?.count == 0 {
			
			//Disaptch Queue object assigns projects to different thread
			DispatchQueue.main.async {
				searchBar.resignFirstResponder()
			}
		}
	}
	
}
