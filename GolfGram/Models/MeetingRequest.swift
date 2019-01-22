//
//  Meeting.swift
//  GolfGram
//
//  Created by Josh Kardos on 1/19/19.
//  Copyright © 2019 JoshTaylorKardos. All rights reserved.
//

import Foundation
class MeetingRequest{
	
	var date: Date?
	var location: String?
	var tutorUid: String?
	var tutoreeUid: String?
	var subject: String?
	
	
	func setLocation(location: String){
		self.location = location
	}
	func setDate(date: Date){
		self.date = date
	}
	
	init(tutor: String, tutoree: String, subject: String) {
		self.tutorUid = tutor
		self.tutoreeUid = tutoree
		self.subject = subject
	}
}
