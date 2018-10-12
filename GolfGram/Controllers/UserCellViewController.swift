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

class UserCellViewController: UITableViewCell {
	
	
	@IBOutlet weak var cellImage: UIImageView!
	@IBOutlet weak var cellLabel: UILabel!
	
	
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
