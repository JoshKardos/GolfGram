//
//  PostViewController.swift
//  TuTour
//
//  Created by Josh Kardos on 10/5/18.
//  Copyright © 2018 JoshTaylorKardos. All rights reserved.
//

import UIKit
import Firebase
import ProgressHUD
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
    @IBOutlet weak var skillsRequiredTextView: UITextView!
    
    
    var postId = String()
    var post: Post?
    func configure(_ post: Post) {
        
        self.selectionStyle = .none
        self.post = post
        postId = post.postId!
        setOpaqueBackground()
        usernameLabel.text = post.senderUsername
        
        if let likeCount = post.numberOfLikes{
            likesCount = likeCount
        }
        if let commentCount = post.numberOfComments{
            commentsCount = commentCount
        }
        
        captionLabel.text = post.caption
        postImage.downloadImageFromString(post.photoUrl!)
        profileImage.downloadImageFromString(post.profileImageUrl!)
        //timeAgoLabel.text = post.timestamp
        universalIcon.isHidden = false
        
        
        
        //set up required stats label
        skillsRequiredTextView.layer.cornerRadius = 16
        if post.skillsRequired.count > 0 {
            skillsRequiredTextView.text = ""
            
            for skill in post.skillsRequired{
                skillsRequiredTextView.text = skillsRequiredTextView.text! + "\u{2022}\(skill)" + "\n"
            }
        } else {
            skillsRequiredTextView.text = "None"
        }
        
        
        
        
        ///////////////////////////////////////////////
        //Check if currentUser has liked this post/////
        ///////////////////////////////////////////////
        Database.database().reference().child("post-likes").child(post.postId!).observe(.value) { (snapshot) in
            
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
        
        
        
        
        
        
    }
    
    var likesButtonActive = Bool()//didset
    
    
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
        postStatsLabel.text = "\(likesCount) Likes     \(commentsCount) Comments"
    }
    
    
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
    
    //Mark: - FIX
    @IBAction func commentPressed(_ sender: UIButton) {
        
        
        delegate.cellCommentPressed(post: post!)
        
    }
    
    
    
    //Mark: - FIX
    @IBAction func likePressed(_ sender: UIButton) {
        
        let postLikesRef = Database.database().reference().child("post-likes")
        let thisPostLikes = postLikesRef.child(postId)
        
        if likesButtonActive == true{
            
            let newLikeRef = thisPostLikes.child((Auth.auth().currentUser?.uid)!)
            newLikeRef.setValue(1)
            
            
        } else {
            //remove like
            thisPostLikes.child((Auth.auth().currentUser?.uid)!).removeValue()
            
        }
    }
    
    
    @IBAction func requestPressed(_ sender: Any) {
        if (post!.senderId!) != (Auth.auth().currentUser?.uid)!{
            
            delegate.requestPressed(post: post!)
            
        } else {
            
            ProgressHUD.showError("Can't meet with yourself")
        
        }
    }
}

extension UIImageView {
    
    func downloadImageFromString(_ url: String){
        
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
