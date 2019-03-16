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
    
    
    override func viewDidLoad() {
        
        super.viewDidLoad()
        tableView.dataSource = self
        tableView.delegate = self
        logOutButton.tintColor = AppDelegate.theme_Color
        // Do any additional setup after loading the view.
        
    }
    fileprivate let postViewModelController = PostViewModelController()
    override func viewWillAppear(_ animated: Bool) {
        
        postViewModelController.loadPosts() { [weak self] (success, error) in
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
        
        return postViewModelController.viewModelsCount
    }
    
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "PostCell", for: indexPath) as! PostCell
        
        
        if let viewModel = postViewModelController.viewModel(at: (indexPath as NSIndexPath).row) {
            cell.configure(viewModel)
        }
        //        cell.isUserInteractionEnabled = true
        //        cell.delegate = self
        
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
struct PostViewModel {
    var caption: String?
    var postId: String?
    var photoUrl: String?
    var senderId: String?
    var numberOfLikes: Int?
    var numberOfComments: Int?
    var senderUsername: String?
    var senderUserProfileUrl: String?
    
    init(post: Post) {
        caption = post.caption
        postId = post.postId
        photoUrl = post.photoUrl
        senderId = post.senderId
        numberOfLikes = post.numberOfLikes
        numberOfComments = post.numberOfComments
        senderUsername = post.sender.username
        senderUserProfileUrl = post.sender.profileImageUrl
    }
}
//MARK: - SenderUsername
struct Post{
    var caption: String?
    var postId: String?
    var photoUrl: String?
    var senderId: String?
    var numberOfLikes: Int?
    var numberOfComments: Int?
//    var senderUsername: String?
//    var senderUserProfileUrl: String?
    var sender = User()
    init(captionString: String, photoIdString: String, photoUrlString: String, senderIdString: String){
        caption = captionString
        postId = photoIdString
        photoUrl = photoUrlString
        senderId = senderIdString
    }
    init(captionString: String, photoIdString: String, photoUrlString: String, senderIdString: String, numberOfLikesInt: Int, numberOfCommentsInt: Int){
        caption = captionString
        postId = photoIdString
        photoUrl = photoUrlString
        senderId = senderIdString
        numberOfLikes = numberOfLikesInt
        numberOfComments = numberOfCommentsInt
    }
    
}

//Mark: - FIX: Fetch sender information
class PostViewModelController {
    
    fileprivate var viewModels: [PostViewModel?] = []
    
    func loadPosts(_ completionBlock: @escaping (_ success: Bool, _ error: NSError?) -> ()){
        
        print("IN LOAD POSTS")
        let ref = Database.database().reference()
        
        
        
        //access posts
        ref.child("posts").queryOrderedByKey().observeSingleEvent(of: .value, with: { (snap) in//get all posts
            
            if let postsSnap = snap.value as? [String: [String: AnyObject]]{
                
                var posts = [Post]()
                for(_, post) in postsSnap {
                    
                    if var post = PostViewModelController.parse(post) {
                        
                        //dont call function, just create new queries...
                        ref.child("users").child(post.senderId!).observeSingleEvent(of: .value, with: { (snapshot) in
                            let user = User(json: snapshot.value as! [String: AnyObject])
                            post.sender = user
                                
                            
                        })
                        
                        ref.child("post-likes").child(post.postId!).observe(.value, with: { (snapshot) in
                            
                            post.numberOfLikes = Int(snapshot.childrenCount)
                        })
                        ref.child("post-comments").child(post.postId!).observe(.value, with: { (snapshot) in
                            
                            post.numberOfComments = Int(snapshot.childrenCount)
                        })
                        
                        posts.append(post)
                        
                    } else {
                        completionBlock(false, nil)
                    }
                }
                DispatchQueue.main.async {
                    print("Post size \(posts.count)")
                    self.viewModels = PostViewModelController.initViewModels(posts)
                    completionBlock(true, nil)
                }
            } else {
                completionBlock(false, nil)
            }
            
            
        })
    }
    
    var viewModelsCount: Int {
        return viewModels.count
    }
    
    func viewModel(at index: Int) -> PostViewModel? {
        guard index >= 0 && index < viewModelsCount else { return nil }
        return viewModels[index]
    }
    
}

//struct PostStatistics{
//    let numberOfLikes
//    let numberOfComments =
//
//}

private extension PostViewModelController {
    
    static func parse(_ post: [String: AnyObject]) -> Post? {
        
        let caption = post["caption"] as! String
        let postId = post["postId"] as! String
        let photoUrl = post["photoUrl"]as! String
        let senderId = post["senderId"] as! String
        
        return Post(captionString: caption, photoIdString: postId, photoUrlString: photoUrl, senderIdString: senderId)
    }
    
    static func initViewModels(_ posts: [Post?]) -> [PostViewModel?] {
        return posts.map { post in
            if let post = post {
                return PostViewModel(post: post)
            } else {
                return nil
            }
        }
    }
    
}
