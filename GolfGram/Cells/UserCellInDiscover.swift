//
//  UserCellViewController.swift
//  GolfGram
//
//  Created by Josh Kardos on 10/6/18.
//  Copyright © 2018 JoshTaylorKardos. All rights reserved.
//

import Foundation
import UIKit

import FirebaseAuth
import FirebaseDatabase

class UserCellInDiscover: UITableViewCell{
	
	
	@IBOutlet weak var cellImage: UIImageView!
	@IBOutlet weak var cellLabel: UILabel!
	let profileButton: UIButton = {
		let sendButton = UIButton(type: .system)
		sendButton.setTitle("Profile", for: .normal)
		sendButton.translatesAutoresizingMaskIntoConstraints = false
		sendButton.addTarget(self, action: #selector(goPressed), for: .touchUpInside)
		return sendButton
	}()
	
	
	
	@objc func goPressed(){
		
		
		
	}
	
	override func awakeFromNib() {
	
//		followButton.tintColor = UIColor.flatGreenDark
//		followButton.layer.cornerRadius = 5
//		followButton.layer.borderWidth = 1
//		followButton.layer.borderColor = UIColor.flatGreenDark.cgColor
		super.awakeFromNib()
		
	}
	
	override func setSelected(_ selected: Bool, animated: Bool) {
		super.setSelected(selected, animated: animated)
	}
}
