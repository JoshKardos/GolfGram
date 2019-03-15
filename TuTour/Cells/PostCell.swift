//
//  PostViewController.swift
//  TuTour
//
//  Created by Josh Kardos on 10/5/18.
//  Copyright © 2018 JoshTaylorKardos. All rights reserved.
//

import UIKit
import Firebase
class PostCell: UITableViewCell {
    
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
    
    func configure(_ viewModel: PostViewModel) {
        setOpaqueBackground()
        profileImage.downloadImageFromUrl(viewModel.photoUrl!)
        usernameLabel.text = viewModel.senderUsername
        
        if let likeCount = viewModel.numberOfLikes{
            likesCount = likeCount
        }
        if let commentCount = viewModel.numberOfComments{
            commentsCount = commentCount
        }
        
        captionLabel.text = viewModel.caption
        postImage.downloadImageFromUrl(viewModel.photoUrl!)
        
        //timeAgoLabel.text = post.timestamp
        universalIcon.isHidden = false
        
        
        ///////////////////////////////////////////////
        //Check if currentUser has liked this post/////
        ///////////////////////////////////////////////
        Database.database().reference().child("post-likes").child(viewModel.postId!).observe(.value) { (snapshot) in
            
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
        Database.database().reference().child("post-comments").child(viewModel.postId!).observe(.value) { (snapshot) in
            self.commentsCount = Int(snapshot.childrenCount)
            
        }
        
        
    }
//    func updateUI(){
//        Database.database().reference().child("users").child(post.senderId!).observeSingleEvent(of: .value, with: {(snapshot) in
//            if let snapshotValue = (snapshot.value as? NSDictionary){
//                if let username = snapshotValue["username"] as? String{
//                    self.usernameLabel.text = username
//                }
//                if let profileImageURL = snapshotValue["profileImageUrl"] as? String{
//                    DispatchQueue.global(qos: .userInteractive).async {
//
//
//                        let url = URL(string: profileImageURL)
//                        let imageData = NSData.init(contentsOf: url as! URL)
//                        let image = UIImage(data: imageData as! Data)
//
//                        DispatchQueue.main.async {
//                            self.profileImage.image = image
//                        }
//                    }
//                }
//            }
//        })
//        //timeAgoLabel.text = post.timestamp
//        universalIcon.isHidden = false
//        captionLabel.text = post.caption
//        let url = URL(string: post.photoUrl!)
//        let imageData = NSData.init(contentsOf: url as! URL)
//        postImage.image = UIImage(data: imageData as! Data)
//
//
//
//        ///////////////////////////////////////////////
//        //Check if currentUser has liked this post/////
//        ///////////////////////////////////////////////
//        Database.database().reference().child("post-likes").child(post.postId!).observe(.value) { (snapshot) in
//
//            self.likesCount = Int(snapshot.childrenCount)
//            if let postDictionary = snapshot.value as? NSDictionary{
//
//                for (key, value) in postDictionary{
//                    if (key as! String)  == Auth.auth().currentUser?.uid{
//                        self.likesButtonActive = false
//                        return
//                    }
//                }
//
//            }
//            self.likesButtonActive = true
//        }
//
//
//
//        //////////////////////////////////////////
//        //Check amount of comments on this post///
//        //////////////////////////////////////////
//        Database.database().reference().child("post-comments").child(post.postId!).observe(.value) { (snapshot) in
//            self.commentsCount = Int(snapshot.childrenCount)
//
//        }
//
//
//
//    }
//
    ////    var post: Post!{
    //        didSet {
    //
    //            self.updateUI()
    //
    //        }
    //    }

    var likesButtonActive = Bool()//didset
    

    var likesCount = 0{
        didSet{
            setUpStatsLabel()
        }
    }
    var commentsCount = 0{
        didSet{
            setUpStatsLabel()
        }
    }
    var sharesCount = 0{
        didSet{
            
            setUpStatsLabel()
            
        }
    }
    func setUpStatsLabel(){
        postStatsLabel.text = "\(likesCount) Likes     \(commentsCount) Comments     \(sharesCount) Shares"
    }
    
    
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
    
    //Mark: - FIX
    @IBAction func commentPressed(_ sender: UIButton) {
        
        
       // delegate.cellCommentPressed(post: post)
        
    }
    
    
    //Mark: - FIX
    @IBAction func likePressed(_ sender: UIButton) {
//
//        let postLikesRef = Database.database().reference().child("post-likes")
//        let thisPostLikes = postLikesRef.child(post.postId!)
//
//        if likesButtonActive == true{
//
//            let newLikeRef = thisPostLikes.child((Auth.auth().currentUser?.uid)!)
//            newLikeRef.setValue(1)
//
//
//        } else {
//            //remove like
//            thisPostLikes.child((Auth.auth().currentUser?.uid)!).removeValue()
//
//        }
//
//        updateUI()
    }
}

extension UIImageView {
    
    func downloadImageFromUrl(_ url: String){
        
        DispatchQueue.global(qos: .userInteractive).async {
            
            
            let url = URL(string: url)
            let imageData = NSData.init(contentsOf: url as! URL)
            let image = UIImage(data: imageData as! Data)
            
            DispatchQueue.main.async {
                self.image = image
            }
        }
        
    }
    
}

private extension PostCell {
    static let defaultBackgroundColor = UIColor.groupTableViewBackground
    
    func setOpaqueBackground() {
        alpha = 1.0
        backgroundColor = PostCell.defaultBackgroundColor
        
        self.profileImage.alpha = 1.0
//        self.profileImage.backgroundColor! = PostCell.defaultBackgroundColor

    }
}
