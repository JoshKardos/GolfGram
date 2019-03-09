//
//  HomeViewController.swift
//  TuTour
//
//  Created by Josh Kardos on 9/25/18.
//  Copyright © 2018 JoshTaylorKardos. All rights reserved.
//

import UIKit
import FirebaseAuth
import FirebaseDatabase
import ChameleonFramework

class HomeViewController: UITableViewController {
    
    @IBOutlet weak var logOutButton: UIBarButtonItem!
    
    var posts = [Post]()
    var selectedPost: Post?
    
    override func viewDidLoad() {
        
        super.viewDidLoad()
        tableView.dataSource = self
        tableView.delegate = self
        logOutButton.tintColor = AppDelegate.theme_Color
        // Do any additional setup after loading the view.
        Database.database().reference().child("users").child((Auth.auth().currentUser?.uid)!).observeSingleEvent(of: .value, with: {(snapshot) in
            
            if !snapshot.exists(){
                self.logout()
            }
            
        })
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        
        posts.removeAll()
        loadPosts()
    }
    func loadPosts(){
        
        
        let ref = Database.database().reference()
        
        posts.removeAll()
        
        //access posts
        ref.child("posts").queryOrderedByKey().observeSingleEvent(of: .value, with: { (snap) in//get all posts
            
            if let posts = snap.value as? [String: AnyObject]{
                for(_, post) in posts {
                    //individual post
                    if let userId = post["senderId"] as? String {
                        if let caption = post["caption"] as? String, let photoId = post["postId"] as? String, let photoUrl = post["photoUrl"]as? String, let senderId = post["senderId"] as? String{
                            
                            let posst = Post(captionString: caption, photoIdString: photoId, photoUrlString: photoUrl, senderIdString: senderId)
                            self.posts.append(posst)
                            
                        }
                    }
                }
                self.tableView.reloadData()
            }
        })
    }
    
    
    
    func logout(){
        do {
            try Auth.auth().signOut()
            
            let storyboard = UIStoryboard(name: "Start", bundle: nil)
            
            let signInVC = storyboard.instantiateViewController(withIdentifier: "SignInViewController")
            
            present(signInVC, animated: true, completion: nil)
            
        } catch let logoutError{
            
            print(logoutError)
            
        }
    }
    

    @IBAction func logoutPressed(_ sender: Any) {
        
        logout()
        
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return posts.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "PostCell", for: indexPath) as! PostCell
        
        cell.post = posts[indexPath.row]
        cell.isUserInteractionEnabled = true
        cell.delegate = self
        
        return cell
    }
    
    func cellCommentPressed(post: Post){
        let storyboard = UIStoryboard(name: "Home", bundle: nil)
        var commentVC = storyboard.instantiateViewController(withIdentifier: "CommentsViewController") as! CommentsTableViewController
        commentVC.post = post
        navigationController?.pushViewController(commentVC, animated: true)
    }
    
}
