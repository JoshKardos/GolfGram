//
//  CommentsTableViewController.swift
//  TuTour
//
//  Created by Josh Kardos on 3/3/19.
//  Copyright © 2019 JoshTaylorKardos. All rights reserved.
//

import Foundation
import UIKit
import Firebase
class CommentsTableViewController: UIViewController, UITableViewDataSource{
    
    var tabBarHeight = CGFloat()
    @IBOutlet weak var bottomContainerView: UIView!
    
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var textField: UITextField!
    @IBOutlet weak var sendButton: UIButton!
    
    var comments = [Comment]()
    
    
    var post: Post!{
        didSet{
            print(post.caption)
            loadComments()
        }
    }
    
    override func viewDidLoad() {
        
        tableView.dataSource = self
        tableView.separatorStyle = .none
        
        sendButton.setTitleColor(AppDelegate.theme_Color, for: .normal)
        
        
        self.tabBarController?.tabBar.isHidden = true
        setupBottomComponents()
        for index in comments.indices{
            print("Comment")
            print(comments[index])
        }
        
        
    }
    override func viewWillDisappear(_ animated: Bool) {
        self.tabBarController?.tabBar.isHidden = false
    }
    
    func loadComments(){
        
        guard let uid = Auth.auth().currentUser?.uid else { return }
        let postCommentsRef = Database.database().reference().child("post-comments").child(post.postId!)
        
        
        postCommentsRef.observe(.childAdded, with: { (snapshot) in
            
            let commentId = snapshot.key
            
            let commentsRef = Database.database().reference().child("comments").child(commentId)
            
            commentsRef.observeSingleEvent(of: .value, with: { (snapshot) in
                
                
                guard let dictionary = snapshot.value as? [String: AnyObject] else { return }
                
                let comment = Comment(dictionary: dictionary)
                
                self.comments.append(comment)
                print("COmment count \(self.comments.count)")

                    if let tableView = self.tableView{
                        print("RELOAD")
                        tableView.reloadData()
                    }
            })
            
        })
        
        
        
        
        
        
    }
    
    func setupBottomComponents(){
        
        textField.placeholder = "Enter comment..."
        textField.borderStyle = .none
        
    }
    @IBAction func sendPressed(_ sender: Any) {
        
        
        
        //update node
        if let commentText = textField.text{
            
            
            let postToCommentsRef = Database.database().reference().child("post-comments").child(post.postId!).childByAutoId()
            postToCommentsRef.setValue(1)
            
            let ref = Database.database().reference().child("comments").child(postToCommentsRef.key!)
            
            ref.updateChildValues(["text": commentText, "senderId": (Auth.auth().currentUser?.uid)!, "commentId": postToCommentsRef.key! , "timestamp": NSDate().timeIntervalSince1970, "postId": post.postId!])
        }
        
        self.textField.text = nil
        
        
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return comments.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "CommentCell", for: indexPath) as! CommentCell
        
        //set profile image to sender profile image
        
        Database.database().reference().child("users").child((Auth.auth().currentUser?.uid)!).observeSingleEvent(of: .value) { (snapshot) in
            if let dictionary = snapshot.value as? [String: AnyObject]{
                if let profileImageUrl = dictionary["profileImageUrl"]{
                    
                    DispatchQueue.global(qos: .userInteractive).async {
                        
                        
                        let url = URL(string: profileImageUrl as! String)
                        let imageData = NSData.init(contentsOf: url as! URL)
                        let image = UIImage(data: imageData as! Data)
                        
                        
                        DispatchQueue.main.async {
                            cell.senderProfileImage.image = image
                        }
                    }
                    
                }
                
                
            }
            
        }
        cell.commentsLabel.text = comments[indexPath.row].commentText
        cell.isUserInteractionEnabled = true
        
        return cell
        
        
    }
    
    //
    //    override func viewDidLoad() {
    //        print("Comments viewdidload")
    //        super.viewDidLoad()
    //        tableView.dataSource = self
    //        tableView.delegate = self
    //    }
    //
    //    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    //        return 5
    //    }
    //
    //    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    //        let cell = tableView.dequeueReusableCell(withIdentifier: "CommentCell", for: indexPath) as! CommentCell
    //        cell.commentsLabel.text = "Hello"
    //        cell.isUserInteractionEnabled = true
    //        return cell
    //    }
    
    
    
}
