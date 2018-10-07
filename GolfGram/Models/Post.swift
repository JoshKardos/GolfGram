//
//  Post.swift
//  GolfGram
//
//  Created by Josh Kardos on 10/5/18.
//  Copyright © 2018 JoshTaylorKardos. All rights reserved.
//

import Foundation
class Post{
	var caption: String
	var photoUrl: String
	
	
	init(captionText: String, photoUrlString: String){
		caption = captionText
		photoUrl = photoUrlString
	}
	
}
