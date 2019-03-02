//
//  Post.swift
//  TuTour
//
//  Created by Josh Kardos on 10/5/18.
//  Copyright © 2018 JoshTaylorKardos. All rights reserved.
//

import Foundation
import FirebaseDatabase

class Post{
	var caption: String?
	var postId: String?
	var photoUrl: String?
	var senderId: String?
    var numberOfLikes: Int?
    var numberOfComments: Int?
	
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
	static let Posts = [Post(captionString: "Helloasddsdas asfsafasfsafsaf asfsfasfsaf asfasfasfasfa sfasfsafasf asfasfsafsa fsafas fsa fsaf safsafsafsa fasfsfasdfgargadfa beggadfdavdsdbfbvfsdvfv dsvsdvfdbvsadf", photoIdString:"HELLO", photoUrlString: "String", senderIdString: "String", numberOfLikesInt: 45, numberOfCommentsInt: 3), Post(captionString: "Hey", photoIdString:"Hey", photoUrlString: "Hey", senderIdString: "String", numberOfLikesInt: 22, numberOfCommentsInt: 25)]
    
    
//    func isLikedByUser(userId: String)->Bool{
//        
//        var userFound = Bool()
//        print("initialized userfound is \(userFound)")
//        Database.database().reference().child("PostLikes").child(postId!).observe(.value) { (snapshot) in
//            
//            let postDictionary = snapshot.value as? NSDictionary
//            
//            for (key, value) in postDictionary!{
//                if (key as! String)  == userId{
//                    print(true)
//                    userFound = true
//                    cell.updateU
//                }
//            }
//
//
//            
//        }
//        
//        
//        print("returned userfound is \(userFound)")
//        return userFound
//        
//    }
}
