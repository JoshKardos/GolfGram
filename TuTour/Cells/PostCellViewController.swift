//
//  PostViewController.swift
//  TuTour
//
//  Created by Josh Kardos on 10/5/18.
//  Copyright © 2018 JoshTaylorKardos. All rights reserved.
//

import UIKit

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
    
    var post: Post!{
        didSet {
            self.updateUI()
        }
    }
    
    func updateUI(){
        //profileImage.image = post
    }
    
    
    //    @IBOutlet weak var cellImage: UIImageView!
//    @IBOutlet weak var usernameLabel: UILabel!
//    @IBOutlet weak var cellLabel: UILabel!
//    
//    override func awakeFromNib() {
//        super.awakeFromNib()
//    }
//    
//    override func setSelected(_ selected: Bool, animated: Bool) {
//        super.setSelected(selected, animated: animated)
//    }
	
}
