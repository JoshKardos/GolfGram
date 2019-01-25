//
//  MeetingRequestCell.swift
//  GolfGram
//
//  Created by Josh Kardos on 1/23/19.
//  Copyright © 2019 JoshTaylorKardos. All rights reserved.
//

import Foundation
import FirebaseDatabase
import UIKit
class MeetingRequestCell: UITableViewCell{
	override func awakeFromNib() {
		
		
		addSubview(profileImageView)
		
		profileImageView.leftAnchor.constraint(equalTo: self.leftAnchor, constant: 8).isActive = true
		profileImageView.centerYAnchor.constraint(equalTo: self.centerYAnchor).isActive = true
		profileImageView.widthAnchor.constraint(equalToConstant: 48).isActive = true
		profileImageView.heightAnchor.constraint(equalToConstant: 48).isActive = true
	}
	
	let profileImageView: UIImageView = {
		let imageView = UIImageView()
		imageView.translatesAutoresizingMaskIntoConstraints = false
		imageView.layer.cornerRadius = 24
		imageView.layer.masksToBounds = true
		imageView.contentMode = .scaleAspectFill
		return imageView
	}()
	
	var meetingRequest: MeetingRequest?{
		didSet{
			setupNameAndProfileImage()
//			self.detailTextLabel?.text = message?.text
//
//			if let seconds = message?.timestamp?.doubleValue{
//				let timestampDate = NSDate(timeIntervalSince1970: seconds)
//
//				let dateFormatter = DateFormatter()
//				dateFormatter.dateFormat = "hh:mm:ss a"
//				timeLabel.text = dateFormatter.string(from: timestampDate as Date)
//			}
			
		}
		
	}
	override func layoutSubviews() {
		super.layoutSubviews()
		
		textLabel?.frame = CGRect.init(x: 64, y: textLabel!.frame.origin.y - 2, width: textLabel!.frame.width, height: textLabel!.frame.height)
		
		detailTextLabel?.frame = CGRect.init(x: 64, y: detailTextLabel!.frame.origin.y + 2, width: detailTextLabel!.frame.width, height: detailTextLabel!.frame.height)
		
	}
	private func setupNameAndProfileImage(){
		
		if let id = meetingRequest?.meetingPartnerId() {
			
			let ref = Database.database().reference().child("users").child(id)
			ref.observeSingleEvent(of: .value) { (snapshot) in
				
				if let dictionary = snapshot.value as? [String: AnyObject]{
					self.textLabel?.text = dictionary["username"] as? String
					if let profileImageUrl = dictionary["profileImageUrl"]{
						
						let url = URL(string: profileImageUrl as! String)
						let imageData = NSData.init(contentsOf: url as! URL)
						self.profileImageView.image = UIImage(data: imageData as! Data)
						
					}
				}
			}
		}
		
	}
	
}
