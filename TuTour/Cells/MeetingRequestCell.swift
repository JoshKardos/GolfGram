//
//  MeetingRequestCell.swift
//  TuTour
//
//  Created by Josh Kardos on 1/23/19.
//  Copyright © 2019 JoshTaylorKardos. All rights reserved.
//

import Foundation
import FirebaseDatabase
import UIKit

class MeetingRequestCell: MessageCell{
	
	
	
	override func awakeFromNib() {

		super.awakeFromNib()
		
	}
	
	var meetingRequest: MeetingRequest?{
		didSet{
			
			//setupNameAndProfileImage()
			self.detailTextLabel?.text = meetingRequest?.subject
			if let date = meetingRequest?.date{

				let dateFormatter = DateFormatter()
				dateFormatter.dateFormat = "hh:mm:ss a"
				timeLabel.text = dateFormatter.string(from: date as Date)
			}

		}
	}
	var otherUser: User?{
		didSet{
			self.textLabel?.text = otherUser?.username
		}
		
		
	}
	
	override func layoutSubviews() {
		super.layoutSubviews()
	}
	//override func setupNameAndProfileImage(){
	//
//
//		if let id = meetingRequest?.meetingPartnerId() {
//
//			let ref = Database.database().reference().child("users").child(id)
//			ref.observeSingleEvent(of: .value) { (snapshot) in
//
//				if let dictionary = snapshot.value as? [String: AnyObject]{
//					self.textLabel?.text = dictionary["username"] as? String
//					if let profileImageUrl = dictionary["profileImageUrl"]{
//
//						let url = URL(string: profileImageUrl as! String)
//						let imageData = NSData.init(contentsOf: url as! URL)
//						self.profileImageView.image = UIImage(data: imageData as! Data)
//
//						print("Photo Set")
//
//					}
//				}
//			}
//		}
//
//	}
	
}
