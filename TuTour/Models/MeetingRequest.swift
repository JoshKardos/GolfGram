//
//  Meeting.swift
//  TuTour
//
//  Created by Josh Kardos on 1/19/19.
//  Copyright © 2019 JoshTaylorKardos. All rights reserved.
//

import Foundation
import FirebaseDatabase
import FirebaseAuth

class MeetingRequest{
	
	var date: Date?
	var location: String?
	var tutorUid: String?
	var tutoreeUid: String?
	var subject: String?
    var meetingId: String?

    var lastUserToSendId: String?
	
	func setLocation(location: String){
		self.location = location
	}
	func setDate(date: Date){
		self.date = date
	}
    func setLastPersonToSendId(uid: String){
        self.lastUserToSendId = uid
    }
    
    init(tutor: String, tutoree: String, subject: String, meetingId: String) {
        self.tutorUid = tutor
        self.tutoreeUid = tutoree
        self.subject = subject
        self.meetingId = meetingId
    }
	init(tutor: String, tutoree: String, subject: String) {
		self.tutorUid = tutor
		self.tutoreeUid = tutoree
		self.subject = subject
	}
	
	func meetingPartnerId() -> String?{
		
		let uid = Auth.auth().currentUser!.uid
		
		if tutorUid == uid{
			return tutoreeUid
		}else{
			return tutorUid
		}
	}
	
	func getOtherUser() -> User?{
		let ref = Database.database().reference().child(self.meetingPartnerId()!)
		ref.observe(.value) { (snapshot) in
			print("FSFSFSF \(snapshot)")
		}
		return nil
	}
}
