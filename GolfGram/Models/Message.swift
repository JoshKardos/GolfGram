//
//  Message.swift
//  GolfGram
//
//  Created by Josh Kardos on 11/4/18.
//  Copyright © 2018 JoshTaylorKardos. All rights reserved.
//

import Foundation
import FirebaseAuth
class Message: NSObject{
	var senderId: String?
	var text: String?
	var timestamp: NSNumber?
	var toId: String?
	
	override init(){
		super.init()
	}
	init(senderIdString: String, textString: String, timestampFloat: NSNumber, toIdString: String){
		senderId = senderIdString
		text = textString
		timestamp = timestampFloat
		toId = toIdString
	}
	
	func chatPartnerId() -> String?{
		
		let uid = Auth.auth().currentUser!.uid
		
		if senderId == uid{
			return toId
		}else{
			return senderId
		}
	}
}
