//
//  HomeViewController.swift
//  GolfGram
//
//  Created by Josh Kardos on 9/25/18.
//  Copyright © 2018 JoshTaylorKardos. All rights reserved.
//

import UIKit
import FirebaseAuth
import FirebaseDatabase

class HomeViewController: UIViewController {

	@IBOutlet weak var tableView: UITableView!
	var posts = [Post]()
	override func viewDidLoad() {
        super.viewDidLoad()
		tableView.dataSource = self
		loadPosts()
        // Do any additional setup after loading the view.
    }
	
	func loadPosts(){
	
		//access posts
		Database.database().reference().child("posts").observe(.childAdded) { (snapshot) in
			if let dict = snapshot.value as? [String:Any] {
	
				//store dictionay values into post and append
				let post = Post(captionText: dict["caption"] as! String, photoUrlString: dict["photoUrl"] as! String)
				self.posts.append(post)
				
				self.tableView.reloadData()
		
			}
		
		}
		
		
	}
	@IBAction func logoutPressed(_ sender: Any) {
		
		print(Auth.auth().currentUser)
		
		do {
			try Auth.auth().signOut()
			
			let storyboard = UIStoryboard(name: "Start", bundle: nil)
			
			let signInVC = storyboard.instantiateViewController(withIdentifier: "SignInViewController")
			
			self.present(signInVC, animated: true, completion: nil)
		
		} catch let logoutError{
		
			print(logoutError)
		
		}
	
	}
	

}

//provide info to table view

extension HomeViewController: UITableViewDataSource{
	func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
		return posts.count
	}

	func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
		print("HERE")
		print(posts[indexPath.row].photoUrl)
		let cell = tableView.dequeueReusableCell(withIdentifier: "PostCell", for: indexPath) as! PostCellViewController

		let url = URL(string: posts[indexPath.row].photoUrl)//NSURL.init(fileURLWithPath: posts[indexPath.row].photoUrl)
		let imageData = NSData.init(contentsOf: url as! URL)
		cell.backgroundColor = UIColor.flatPink
		cell.cellImage.image = UIImage(data: imageData as! Data)
		cell.cellLabel.text = self.posts[indexPath.row].caption
		
		
		return cell
	}






}
