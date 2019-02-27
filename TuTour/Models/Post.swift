//
//  Post.swift
//  TuTour
//
//  Created by Josh Kardos on 10/5/18.
//  Copyright © 2018 JoshTaylorKardos. All rights reserved.
//

import Foundation
class Post{
	var caption: String?
	var photoId: String?
	var photoUrl: String?
	var senderId: String?
    var numberOfLikes: Int?
    var numberOfComments: Int?
	
	init(captionString: String, photoIdString: String, photoUrlString: String, senderIdString: String){
		caption = captionString
		photoId = photoIdString
		photoUrl = photoUrlString
		senderId = senderIdString
	}
    init(captionString: String, photoIdString: String, photoUrlString: String, senderIdString: String, numberOfLikesInt: Int, numberOfCommentsInt: Int){
        caption = captionString
        photoId = photoIdString
        photoUrl = photoUrlString
        senderId = senderIdString
        numberOfLikes = numberOfLikesInt
        numberOfComments = numberOfCommentsInt
    }
	static let Posts = [Post(captionString: "Helloasddsdas asfsafasfsafsaf asfsfasfsaf asfasfasfasfa sfasfsafasf asfasfsafsa fsafas fsa fsaf safsafsafsa fasfsfasdfgargadfa beggadfdavdsdbfbvfsdvfv dsvsdvfdbvsadf", photoIdString:"HELLO", photoUrlString: "String", senderIdString: "String", numberOfLikesInt: 45, numberOfCommentsInt: 3), Post(captionString: "Hey", photoIdString:"Hey", photoUrlString: "Hey", senderIdString: "String", numberOfLikesInt: 22, numberOfCommentsInt: 25)]
}
