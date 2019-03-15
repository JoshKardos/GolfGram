//
//  DiscoverViewController.swift
//  TuTour
//
//  Created by Josh Kardos on 9/25/18.
//  Copyright © 2018 JoshTaylorKardos. All rights reserved.
//

import UIKit
import FirebaseDatabase
import FirebaseAuth
import ProgressHUD

class DiscoverViewController: UITableViewController, UISearchResultsUpdating {
	
	let searchController = UISearchController(searchResultsController: nil)
	@IBOutlet weak var searchBar: UISearchBar!
	var subject: String?
	static var usersArray = [NSDictionary?]()
	var filteredUsers = [NSDictionary?]()
	
	var databaseRef = Database.database().reference()
	let cellId = "tutorCell"

	override func viewDidLoad() {
        super.viewDidLoad()
        

		searchController.searchResultsUpdater = self
		searchController.dimsBackgroundDuringPresentation = false
		searchController.searchBar.tintColor = AppDelegate.theme_Color
		definesPresentationContext = true
		tableView.tableHeaderView = searchController.searchBar
		
		
		tableView!.register(UserCellInDiscover.self, forCellReuseIdentifier: cellId)
		
		DiscoverViewController.usersArray.removeAll()
		
		
		databaseRef.child("subject-tutors").child(subject!).child("tutors").observe(.childAdded) { (snapshot1) in
			self.databaseRef.child("users").child(snapshot1.key).observe(.value, with: { (snapshot2) in
				
				DiscoverViewController.usersArray.append(snapshot2.value as? NSDictionary)
				
				
			})
			self.timer?.invalidate()
			self.timer = Timer.scheduledTimer(timeInterval: 0.1, target: self, selector: #selector(self.handleReloadCollection), userInfo: nil, repeats: false)
		}
		
	}

	var timer: Timer?
	@objc func handleReloadCollection(){
		DispatchQueue.main.async {
			self.tableView.reloadData()//.collectionView!.reloadData()
		}
	}



	//MARK: - Tableview Methods
	
	//rows in table
	override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
		if searchController.isActive && searchController.searchBar.text != ""{
			return filteredUsers.count
		}
		
		return DiscoverViewController.usersArray.count
	}
	
	//text to put in cell
	override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
		
		let cell = tableView.dequeueReusableCell(withIdentifier: cellId, for: indexPath)
		
		let user : NSDictionary?
		
		if searchController.isActive && searchController.searchBar.text != ""{
			user = filteredUsers[indexPath.row]
		} else {
			user = DiscoverViewController.usersArray[indexPath.row]
		}
		
	
		
		let url = URL(string: user?["profileImageUrl"] as! String)//NSURL.init(fileURLWithPath: posts[indexPath.row].photoUrl)
		let imageData = NSData.init(contentsOf: url as! URL)

		cell.textLabel?.text = user?["username"] as? String
		cell.imageView?.image = UIImage(data: imageData as! Data)
		if user!["uid"] as! String == Auth.auth().currentUser?.uid{
			cell.backgroundColor = UIColor.lightGray
		}
		return cell
	}
	
	//when row is selected
	override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
		
		let otherUser: NSDictionary!
		
		
		if searchController.isActive && searchController.searchBar.text != ""{
			otherUser = filteredUsers[indexPath.row]
		} else {
			otherUser = DiscoverViewController.usersArray[indexPath.row]
		}

	
		
		let otherUserUid = otherUser!["uid"] as! String
		
		if otherUserUid == Auth.auth().currentUser?.uid{
			ProgressHUD.showError("Cannot tutor yourself")
			return
		}
		
		let storyboard: UIStoryboard = UIStoryboard(name: "Profile", bundle: nil)
		let otherUserProfile = storyboard.instantiateViewController(withIdentifier: "Profile") as! ProfileViewController

		otherUserProfile.uid = otherUserUid
		otherUserProfile.disableComponents()
	
		var meeting = MeetingRequest(tutor: otherUserUid, tutoree:(Auth.auth().currentUser?.uid)!, subject: subject!)
		
		otherUserProfile.meeting = meeting
		navigationController?.pushViewController(otherUserProfile, animated: true)
		

	
	}
	func checkFollowing(indexPath: IndexPath){
		let uid = Auth.auth().currentUser!.uid
		let ref = Database.database().reference()
		
		let otherUser = DiscoverViewController.usersArray[indexPath.row]
		let otherUserUid = otherUser!["uid"] as! String
		
		ref.child("users").child(uid).child("following").queryOrderedByKey().observeSingleEvent(of: .value) { (snapshot) in
			
			if let following = snapshot.value as? [String:AnyObject]{
				
				for(ke, value) in following {
					if value as! String == otherUserUid{
					
						self.tableView.cellForRow(at: indexPath)?.accessoryType = .checkmark
					
						
					}
				}
			}
				
		}
		ref.removeAllObservers()
		
	}
	
}

//MARK: - Search Bar Methods
extension DiscoverViewController: UISearchBarDelegate{
	
	
	func updateSearchResults(for searchController: UISearchController){
		filterContent(searchText: self.searchController.searchBar.text!)
	}
	
	func filterContent(searchText: String){
		
		self.filteredUsers = DiscoverViewController.usersArray.filter{ user in
			
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
			
			//Disaptch Queue object assigns projects to different thread
			DispatchQueue.main.async {
				searchBar.resignFirstResponder()
			}
			
			
			
		}
	}
	
}
