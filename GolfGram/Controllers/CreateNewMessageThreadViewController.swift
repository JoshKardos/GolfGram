//
//  CreateNewMessageThreadViewController.swift
//  GolfGram
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
	
	
	override func viewDidLoad() {
		super.viewDidLoad()
		print("loaded")
		searchController.searchResultsUpdater = self
		searchController.dimsBackgroundDuringPresentation = false
		searchController.searchBar.tintColor = UIColor.flatGreenDark
		definesPresentationContext = true
		tableView.tableHeaderView = searchController.searchBar
		
		//remove in order to mae sure its a fresh search fucntion when signing in
		CreateNewMessageThreadViewController.usersArray.removeAll()
		databaseRef.child("users").queryOrdered(byChild: "name").observe(.childAdded) { (snapshot) in
			CreateNewMessageThreadViewController.usersArray.append(snapshot.value as? NSDictionary)
			
			//self.insert
		}
	}
	
	//MARK: - Tableview Methods
	
	//rows in table
	override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
		if searchController.isActive && searchController.searchBar.text != ""{
			return filteredUsers.count
		}
		
		return CreateNewMessageThreadViewController.usersArray.count
	}
	
	//text to put in cell
	override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
		
		let cell = tableView.dequeueReusableCell(withIdentifier: "userCell", for: indexPath) as! UserCellViewController
		
		let user : NSDictionary?
		
		if searchController.isActive && searchController.searchBar.text != ""{
			user = filteredUsers[indexPath.row]
		} else {
			user = CreateNewMessageThreadViewController.usersArray[indexPath.row]
		}
		
		let url = URL(string: user?["profileImageUrl"] as! String)//NSURL.init(fileURLWithPath: posts[indexPath.row].photoUrl)
		let imageData = NSData.init(contentsOf: url as! URL)
		
		cell.cellImage.image = UIImage(data: imageData as! Data)
		cell.cellLabel.text = user?["username"] as? String
		
		return cell
	}
	
	//when row is sleected
	override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
		
		let uid = Auth.auth().currentUser!.uid
		let ref = Database.database().reference().child("users")
		
		let otherUser = CreateNewMessageThreadViewController.usersArray[indexPath.row]
		let otherUserUid = otherUser!["uid"] as! String
		if uid != otherUserUid{
			if searchController.isActive && searchController.searchBar.text != "" {
				
				if tableView.cellForRow(at: indexPath)?.accessoryType == .checkmark{
					
					tableView.cellForRow(at: indexPath)?.accessoryType = .none
					
				}else {
					
					tableView.cellForRow(at: indexPath)?.accessoryType = .checkmark
					print(filteredUsers.count)
					print("MESSAGE TO \(filteredUsers[indexPath.row])")
					
				}
			} else {
				
				
				if tableView.cellForRow(at: indexPath)?.accessoryType == .checkmark{
					tableView.cellForRow(at: indexPath)?.accessoryType = .none
					
				}else {
					tableView.cellForRow(at: indexPath)?.accessoryType = .checkmark
					print(CreateNewMessageThreadViewController.usersArray.count)
					print("MESSAGE TO \(CreateNewMessageThreadViewController.usersArray[indexPath.row])")
					
				}
				
			}
		} else {
			
			ProgressHUD.showError("Cannot message yourself")
			
		}
		
		//
		//		if tableView.cellForRow(at: indexPath)?.accessoryType == .checkmark{
		//			tableView.cellForRow(at: indexPath)?.accessoryType = .none
		//
		//		}else {
		//			tableView.cellForRow(at: indexPath)?.accessoryType = .checkmark
		//			print(filteredUsers.count)
		//			print("MESSAGE TO \(filteredUsers[indexPath.row])")
		//
		//		}
		
		
		
		ref.removeAllObservers()
		
	}
	//	func checkFollowing(indexPath: IndexPath){
	//		let uid = Auth.auth().currentUser!.uid
	//		let ref = Database.database().reference()
	//
	//		let otherUser = CreateNewMessageThreadViewController.usersArray[indexPath.row]
	//		let otherUserUid = otherUser!["uid"] as! String
	//
	//		ref.child("users").child(uid).child("following").queryOrderedByKey().observeSingleEvent(of: .value) { (snapshot) in
	//
	//			if let following = snapshot.value as? [String:AnyObject]{
	//
	//				for(ke, value) in following {
	//					if value as! String == otherUserUid{
	//
	//						self.tableView.cellForRow(at: indexPath)?.accessoryType = .checkmark
	//
	//
	//					}
	//				}
	//			}
	//
	//		}
	//		ref.removeAllObservers()
	//
	//	}
	
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
		//todoItems = todoItems?.filter("title CONTAINS[cd] %@",searchBar.text!).sorted(byKeyPath: "dateCreated", ascending: true)
		tableView.reloadData()
		
	}
	
	//search bar text changed
	func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
		if searchBar.text?.count == 0 {
			//loadItems()
			
			//Disaptch Queue object assigns projects to different thread
			DispatchQueue.main.async {
				searchBar.resignFirstResponder()
			}
			
			
			
		}
	}
	
}
