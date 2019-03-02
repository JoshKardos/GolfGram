//
//  PostViewController.swift
//  TuTour
//
//  Created by Josh Kardos on 10/5/18.
//  Copyright © 2018 JoshTaylorKardos. All rights reserved.
//

import UIKit
import Firebase
class PostCellViewController: UITableViewCell {
    
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
        var userFound = false
        Database.database().reference().child("PostLikes").child(post.postId!).observe(.value) { (snapshot) in
            
            if let postDictionary = snapshot.value as? NSDictionary{
                
                for (key, value) in postDictionary{
                    if (key as! String)  == Auth.auth().currentUser?.uid{
                        print(true)
                        userFound = true
                        self.likesButtonActive = false
                        return
                    }
                }
                
            }
            self.likesButtonActive = true
        }
        
        
    }
    
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
    @IBAction func likePressed(_ sender: UIButton) {
        
        let postLikesRef = Database.database().reference().child("PostLikes")
        let thisPostLikes = postLikesRef.child(post.postId!)
        
        if likesButtonActive == true{
            print("ADD")
            let newLikeRef = thisPostLikes.child((Auth.auth().currentUser?.uid)!)
            newLikeRef.setValue(1)
            
            
        } else {
            print("Remove")
            //remove like
            thisPostLikes.child((Auth.auth().currentUser?.uid)!).removeValue()
            
        }
        updateUI()
    }
}
