////
////  SearchUsersViewController.swift
////  GolfGram
////
////  Created by Josh Kardos on 10/17/18.
////  Copyright © 2018 JoshTaylorKardos. All rights reserved.
////
//
//import Foundation
//import UIKit
//import FirebaseDatabase
//import FirebaseAuth
//import ProgressHUD
//class SearchUsersViewController: UITableViewController, UISearchResultsUpdating{
//	func updateSearchResults(for searchController: UISearchController) {
//		
//	}
//	
//	
//	let searchController = UISearchController(searchResultsController: nil)
//	@IBOutlet weak var searchBar: UISearchBar!
//	
//	
//	static var usersArray = [NSDictionary?]()
//	var filteredUsers = [NSDictionary?]()
//	
//	var databaseRef = Database.database().reference()
//	
//	
//	override func viewDidLoad() {
//		super.viewDidLoad()
//		
//		searchController.searchResultsUpdater = self
//		searchController.dimsBackgroundDuringPresentation = false
//		searchController.searchBar.tintColor = UIColor.flatGreenDark
//		definesPresentationContext = true
//		tableView.tableHeaderView = searchController.searchBar
//		
//		//remove in order to mae sure its a fresh search fucntion when signing in
//		SearchUsersViewController.usersArray.removeAll()
//		databaseRef.child("users").queryOrdered(byChild: "name").observe(.childAdded) { (snapshot) in
//			SearchUsersViewController.usersArray.append(snapshot.value as? NSDictionary)
//			
//			//self.insert
//		}
//	}
//	
//	//rows in table
//	override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
//		if searchController.isActive && searchController.searchBar.text != ""{
//			return filteredUsers.count
//		}
//		
//		return SearchUsersViewController.usersArray.count
//	}
//	
//	
//	//text to put in cell
//	override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
//		
//		let cell = tableView.dequeueReusableCell(withIdentifier: "userCell", for: indexPath) as! UserCellViewController
//		
//		let user : NSDictionary?
//		
//		if searchController.isActive && searchController.searchBar.text != ""{
//			user = filteredUsers[indexPath.row]
//		} else {
//			user = SearchUsersViewController.usersArray[indexPath.row]
//		}
//		
//		let url = URL(string: user?["profileImageUrl"] as! String)//NSURL.init(fileURLWithPath: posts[indexPath.row].photoUrl)
//		let imageData = NSData.init(contentsOf: url as! URL)
//		
//		cell.cellImage.image = UIImage(data: imageData as! Data)
//		cell.cellLabel.text = user?["username"] as? String
//		
//		
//		return cell
//	}
//}
//
//
////MARK: - Search Bar Methods
//extension SearchUsersViewController: UISearchBarDelegate{
//	
//	
//	func updateSearchResults(for searchController: UISearchController){
//		filterContent(searchText: self.searchController.searchBar.text!)
//	}
//	
//	func filterContent(searchText: String){
//		
//		self.filteredUsers = SearchUsersViewController.usersArray.filter{ user in
//			
//			let username = user!["username"] as? String
//			
//			return(username?.lowercased().contains(searchText.lowercased()))!
//			
//		}
//		
//		tableView.reloadData()
//		
//	}
//	
//	func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
//		//todoItems = todoItems?.filter("title CONTAINS[cd] %@",searchBar.text!).sorted(byKeyPath: "dateCreated", ascending: true)
//		tableView.reloadData()
//		
//	}
//	
//	//search bar text changed
//	func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
//		if searchBar.text?.count == 0 {
//			//loadItems()
//			
//			//Disaptch Queue object assigns projects to different thread
//			DispatchQueue.main.async {
//				searchBar.resignFirstResponder()
//			}
//			
//			
//			
//		}
//	}
//	
//}
