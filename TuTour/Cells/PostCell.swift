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
    
    var postId = String()
    
    func configure(_ viewModel: PostViewModel) {
        
        postId = viewModel.postId!
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
        
        Database.database().reference().child("post-likes").child(viewModel.postId!).observe(.childAdded) { (snapshot) in
            
            self.likesCount = Int(snapshot.childrenCount)
            
        }
        Database.database().reference().child("post-likes").child(viewModel.postId!).observe(.childRemoved) { (snapshot) in
            
            self.likesCount = Int(snapshot.childrenCount)
            
        }
        
        //////////////////////////////////////////
        //Check amount of comments on this post///
        //////////////////////////////////////////
        Database.database().reference().child("post-comments").child(viewModel.postId!).observe(.value) { (snapshot) in
            self.commentsCount = Int(snapshot.childrenCount)
            
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

        let postLikesRef = Database.database().reference().child("post-likes")
        let thisPostLikes = postLikesRef.child(postId)

        if likesButtonActive == true{

            let newLikeRef = thisPostLikes.child((Auth.auth().currentUser?.uid)!)
            newLikeRef.setValue(1)


        } else {
            //remove like
            thisPostLikes.child((Auth.auth().currentUser?.uid)!).removeValue()

        }

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
