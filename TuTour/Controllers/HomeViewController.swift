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
    var renderredCells = [PostCell]()
    
    override func viewDidLoad() {
        
        super.viewDidLoad()
        tableView.dataSource = self
        tableView.delegate = self
        logOutButton.tintColor = AppDelegate.theme_Color
        
        // Do any additional setup after loading the view.
        loadPosts() { [weak self] (success, error) in
            guard let strongSelf = self else { return }
            if !success {
                DispatchQueue.main.async {
                    let title = "Error"
                    if let error = error {
                        print("HERE ! \(error)")
                        //                        strongSelf.showError(title, message: error.localizedDescription)
                    } else {
                        print("HERE !!!! \(error)")
                        //                        strongSelf.showError(title, message: NSLocalizedString("Can't retrieve contacts.", comment: "The message displayed when contacts can’t be retrieved."))
                    }
                }
            } else {
                DispatchQueue.main.async {
                    strongSelf.tableView.reloadData()
                }
            }
        }
    }
    var posts = [Post]()
   
    
    
    func loadPosts(_ completionBlock: @escaping (_ success: Bool, _ error: NSError?) -> ()){
        posts = []
        print("IN LOAD POSTS")
        let ref = Database.database().reference()
        
        
        
        //access posts
        ref.child("posts").queryOrderedByKey().observe(.value, with: { (snap) in//get all posts
            
            if let postsSnap = snap.value as? [String: [String: AnyObject]]{
                
                for(_, post) in postsSnap {
                    
                    let postId = post["postId"] as! String
                    ref.child("post-likes").child(postId).observeSingleEvent(of: .value, with: { (snapshot) in
                        
                        
                        let numberOfLikes = Int(snapshot.childrenCount)
                        
                        ref.child("post-comments").child(postId).observeSingleEvent(of: .value, with: { (snapshot) in
                            
                            let numberOfComments = Int(snapshot.childrenCount)
                            
                            ref.child("users").child(post["senderId"] as! String).observeSingleEvent(of: .value, with: { (snapshot) in
                                let dictionary = snapshot.value as! [String: AnyObject]
                                let username = (dictionary["username"] as! String)
                                
                                let profileImageString = (snapshot.value as! NSDictionary)["profileImageUrl"] as! String
                                
                                let post = Post(dictionary: post, numComments: numberOfComments, numLikes: numberOfLikes, username: username, profileImageUrl: profileImageString)
                                
                                self.posts.append(post)
                                DispatchQueue.main.async {
                                    self.tableView.reloadData()
                                }
                            })

                            
                            
                            
                        })
                    })
                    
                }
                
                completionBlock(true, nil)
                print("COMPLETE")
            } else {
                completionBlock(false, nil)
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
        
        var cell = tableView.dequeueReusableCell(withIdentifier: "PostCell", for: indexPath) as! PostCell
        if indexPath.row < renderredCells.count{
            
            cell = renderredCells[indexPath.row]
            
        } else {
            cell.configure(posts[indexPath.row])
            renderredCells.append(cell)
        }
        cell.delegate = self
        
        return cell
    }
    
    //MARK: - Fix (post)
    func cellCommentPressed(post: Post){
        let storyboard = UIStoryboard(name: "Home", bundle: nil)
        var commentVC = storyboard.instantiateViewController(withIdentifier: "CommentsViewController") as! CommentsTableViewController
        
        commentVC.post = post
        navigationController?.pushViewController(commentVC, animated: true)
    }
    
}


//MARK: - SenderUsername
class Post{
    var caption: String?
    var postId: String?
    var photoUrl: String?
    var senderId: String?
    var numberOfLikes: Int?
    var numberOfComments: Int?
    var senderUsername: String?
    var profileImageUrl: String?
   
    init(dictionary: [String: AnyObject], numComments: Int, numLikes: Int, username: String, profileImageUrl: String){
        
        
        caption = (dictionary["caption"] as! String)
        postId = (dictionary["postId"] as! String)
        photoUrl = (dictionary["photoUrl"] as! String)
        senderId = (dictionary["senderId"] as! String)
        
        //get statistics
        numberOfLikes = numLikes
        print("LIKES \(numberOfLikes)")
        numberOfComments = numComments
        print("Comments \(numberOfComments)")
        senderUsername = username
        self.profileImageUrl = profileImageUrl
        
        //get sender info
    }
    
}
//                    if var post = PostViewModelController.parse(post) {
//
//                        //dont call function, just create new queries...
//                        ref.child("users").child(post.senderId!).observeSingleEvent(of: .value, with: { (snapshot) in
//                            let user = User(json: snapshot.value as! [String: AnyObject])
//                            post.sender = user
//
//                        })
//
//                        ref.child("post-likes").child(post.postId!).observe(.value, with: { (snapshot) in
//
//                            post.numberOfLikes = Int(snapshot.childrenCount)
//                        })
//                        ref.child("post-comments").child(post.postId!).observe(.value, with: { (snapshot) in
//
//                            post.numberOfComments = Int(snapshot.childrenCount)
//                        })
//
//                        posts.append(post)
//
//                    } else {
//                        completionBlock(false, nil)
//                    }
//                }
//                DispatchQueue.main.async {
//                    print("Post size \(posts.count)")
//                    self.viewModels = PostViewModelController.initViewModels(posts)
//                    completionBlock(true, nil)
//                }
//            } else {
//                completionBlock(false, nil)

