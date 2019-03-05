//
//  PostViewController.swift
//  TuTour
//
//  Created by Josh Kardos on 10/5/18.
//  Copyright © 2018 JoshTaylorKardos. All rights reserved.
//

import UIKit
import Firebase
class PostCellViewController: UITableViewCell,UITableViewDataSource {
    
    var delegate = HomeViewController()
    @IBOutlet weak var profileImage: UIImageView!
    @IBOutlet weak var usernameLabel: UILabel!
    @IBOutlet weak var timeAgoLabel: UILabel!
    @IBOutlet weak var universalIcon: UIImageView!
    @IBOutlet weak var captionLabel: UILabel!
    @IBOutlet weak var postImage: UIImageView!
    @IBOutlet weak var postStatsLabel: UILabel!
    @IBOutlet weak var likesButton: UIButton!
    @IBOutlet weak var commentButton: UIButton!
    @IBOutlet weak var shareButton: UIButton!
    
    var likesButtonActive = Bool()//didset
    
    var post: Post!{
        didSet {
            
            self.updateUI()
        
        }
    }
    
    var likesCount = Int(){
        didSet{
            setUpStatsLabel()
        }
    }
    var commentsCount = Int(){
        didSet{
            setUpStatsLabel()
        }
    }
    var sharesCount = Int(){
        didSet{
            
            setUpStatsLabel()
            
        }
    }
    func setUpStatsLabel(){
        postStatsLabel.text = "\(likesCount) Likes     \(commentsCount) Comments     \(sharesCount) Shares"
    }
    
    func updateUI(){
        Database.database().reference().child("users").child(post.senderId!).observeSingleEvent(of: .value, with: {(snapshot) in
            if let snapshotValue = (snapshot.value as? NSDictionary){
                if let username = snapshotValue["username"] as? String{
                    self.usernameLabel.text = username
                }
                if let profileImageURL = snapshotValue["profileImageUrl"] as? String{
                    let url = URL(string: profileImageURL)
                    let imageData = NSData.init(contentsOf: url as! URL)
                    self.profileImage.image = UIImage(data: imageData as! Data)
                }
            }
        })
        //timeAgoLabel.text = post.timestamp
        universalIcon.isHidden = false
        captionLabel.text = post.caption
        let url = URL(string: post.photoUrl!)
        let imageData = NSData.init(contentsOf: url as! URL)
        postImage.image = UIImage(data: imageData as! Data)
        
        
        
        ///////////////////////////////////////////////
        //Check if currentUser has liked this post/////
        ///////////////////////////////////////////////
        Database.database().reference().child("PostLikes").child(post.postId!).observe(.value) { (snapshot) in
            
            self.likesCount = Int(snapshot.childrenCount)
            if let postDictionary = snapshot.value as? NSDictionary{
                
                for (key, value) in postDictionary{
                    if (key as! String)  == Auth.auth().currentUser?.uid{
                        self.likesButtonActive = false
                        return
                    }
                }
                
            }
            self.likesButtonActive = true
        }
        
        
        
        //////////////////////////////////////////
        //Check amount of comments on this post///
        //////////////////////////////////////////
        Database.database().reference().child("post-comments").child(post.postId!).observe(.value) { (snapshot) in
            self.commentsCount = Int(snapshot.childrenCount)
            
        }
        
        
        
    }
    
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    

    
    @IBAction func commentPressed(_ sender: UIButton) {
        
        
        print("Comment Pressed")
        
        delegate.cellCommentPressed(post: post)
        
    }
    
    @IBAction func likePressed(_ sender: UIButton) {
        
        let postLikesRef = Database.database().reference().child("PostLikes")
        let thisPostLikes = postLikesRef.child(post.postId!)
        
        if likesButtonActive == true{
            
            let newLikeRef = thisPostLikes.child((Auth.auth().currentUser?.uid)!)
            newLikeRef.setValue(1)
            
            
        } else {
            //remove like
            thisPostLikes.child((Auth.auth().currentUser?.uid)!).removeValue()
            
        }
        
        updateUI()
    }
}
extension PostCellViewController{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return 5
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "CommentCell", for: indexPath) as! CommentCell
        
        cell.commentsLabel.text = "Hello"
        return cell
    }
    
}
