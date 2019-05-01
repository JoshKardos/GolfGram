//
//  CommontCell.swift
//  TuTour
//
//  Created by Josh Kardos on 3/2/19.
//  Copyright © 2019 JoshTaylorKardos. All rights reserved.
//

import Foundation
import UIKit
import Firebase
class CommentCell: UITableViewCell{
    
    @IBOutlet weak var commentsLabel: UILabel!
    @IBOutlet weak var senderProfileImage: UIImageView!
    
    func configure(_ comment: Comment){
        senderProfileImage.downloadImageFromString(comment.senderImageUrl)
        commentsLabel.text = comment.commentText
        
    }
    
}
