//
//  SubjectCell.swift
//  TuTour
//
//  Created by Josh Kardos on 12/27/18.
//  Copyright © 2018 JoshTaylorKardos. All rights reserved.
//

import UIKit

import FirebaseAuth
import FirebaseDatabase

class SubjectCell: UITableViewCell{

	
	@IBOutlet weak var cellLabel: UILabel!
	
	
	override func awakeFromNib() {
		
		//		followButton.tintColor = UIColor.flatGreenDark
		//		followButton.layer.cornerRadius = 5
		//		followButton.layer.borderWidth = 1
		//		followButton.layer.borderColor = UIColor.flatGreenDark.cgColor
		super.awakeFromNib()
		
	}
}
