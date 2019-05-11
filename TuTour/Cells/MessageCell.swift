//
//  MessageCell.swift
//  TuTour
//
//  Created by Josh Kardos on 11/26/18.
//  Copyright © 2018 JoshTaylorKardos. All rights reserved.
//

import Foundation
import UIKit
import Firebase

//table view when you click the dm btton first,
//cell for table that contains list of message threads with other users

class MessageCell: UITableViewCell{
	
	var databaseRef = Database.database().reference()
	
	let profileImageView: UIImageView = {
		let imageView = UIImageView()
		imageView.translatesAutoresizingMaskIntoConstraints = false
		imageView.layer.cornerRadius = 24
		imageView.layer.masksToBounds = true
		imageView.contentMode = .scaleAspectFill
		return imageView
	}()
	
	let timeLabel: UILabel = {
		let label = UILabel()
		label.text = "HH:MM:SS"
		label.font = UIFont.systemFont(ofSize: 13)
		label.textColor = UIColor.lightGray
		label.translatesAutoresizingMaskIntoConstraints = false
		return label
	}()
	
	var message: Message?{
		didSet{
			setupNameAndProfileImage()
			self.detailTextLabel?.text = message?.text
			
			if let seconds = message?.timestamp?.doubleValue{
				let timestampDate = NSDate(timeIntervalSince1970: seconds)
				
				let dateFormatter = DateFormatter()
				dateFormatter.dateFormat = "hh:mm:ss a"
				timeLabel.text = dateFormatter.string(from: timestampDate as Date)
			}
			
		}
	}

	
	//name and image in cell
	func setupNameAndProfileImage(){

		if let id = message?.chatPartnerId() {
			
			let ref = databaseRef.child("users").child(id)
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

	override func layoutSubviews() {
		super.layoutSubviews()
		
		textLabel?.frame = CGRect.init(x: 64, y: textLabel!.frame.origin.y - 2, width: textLabel!.frame.width, height: textLabel!.frame.height)
		
		detailTextLabel?.frame = CGRect.init(x: 64, y: detailTextLabel!.frame.origin.y + 2, width: detailTextLabel!.frame.width, height: detailTextLabel!.frame.height)
		
	}
	
	override func awakeFromNib() {
		addSubview(profileImageView)
		addSubview(timeLabel)
		
		profileImageView.leftAnchor.constraint(equalTo: self.leftAnchor, constant: 8).isActive = true
		profileImageView.centerYAnchor.constraint(equalTo: self.centerYAnchor).isActive = true
		profileImageView.widthAnchor.constraint(equalToConstant: 48).isActive = true
		profileImageView.heightAnchor.constraint(equalToConstant: 48).isActive = true
		
		timeLabel.rightAnchor.constraint(equalTo: self.rightAnchor).isActive = true
		timeLabel.topAnchor.constraint(equalTo: self.topAnchor, constant: 18).isActive = true
		timeLabel.widthAnchor.constraint(equalToConstant: 100).isActive = true
		timeLabel.heightAnchor.constraint(equalTo: (textLabel?.heightAnchor)!).isActive = true
		
		
		
	}
	

	
}
