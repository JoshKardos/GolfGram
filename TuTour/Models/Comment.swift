//
//  Comment.swift
//  TuTour
//
//  Created by Josh Kardos on 3/3/19.
//  Copyright © 2019 JoshTaylorKardos. All rights reserved.
//

import Foundation
class Comment{
    
    var senderId: String
    var commentId: String
     var senderImageUrl: String
    var commentText: String
    var timestamp: NSNumber
    var postId: String
    
    init(dictionary: [String: Any]){
        
        self.senderId = dictionary["senderId"] as! String
        self.senderImageUrl = dictionary["senderProfileImageUrl"] as! String
        self.commentId = dictionary["commentId"] as! String
        self.commentText = dictionary["text"] as! String
        self.timestamp = dictionary["timestamp"] as! NSNumber
        self.postId = dictionary["postId"] as! String
        
        
        
    }
    
    
    
}
