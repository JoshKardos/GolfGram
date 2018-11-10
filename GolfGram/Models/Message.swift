//
//  Message.swift
//  GolfGram
//
//  Created by Josh Kardos on 11/4/18.
//  Copyright © 2018 JoshTaylorKardos. All rights reserved.
//

import Foundation
class Message{
	var senderId: String?
	var text: String?
	var timestamp: NSNumber?
	var toId: String?
	
	init(senderIdString: String, textString: String, timestampFloat: NSNumber, toIdString: String){
		senderId = senderIdString
		text = textString
		timestamp = timestampFloat
		toId = toIdString
	}
}
