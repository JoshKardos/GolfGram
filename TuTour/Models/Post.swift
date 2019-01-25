//
//  Post.swift
//  GolfGram
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
	
	
	init(captionString: String, photoIdString: String, photoUrlString: String, senderIdString: String){
		caption = captionString
		photoId = photoIdString
		photoUrl = photoUrlString
		senderId = senderIdString
	}
	
}
