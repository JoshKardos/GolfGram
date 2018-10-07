//
//  UserCellViewController.swift
//  GolfGram
//
//  Created by Josh Kardos on 10/6/18.
//  Copyright © 2018 JoshTaylorKardos. All rights reserved.
//

import Foundation
import UIKit

class UserCellViewController: UITableViewCell {
	
	
	@IBOutlet weak var cellImage: UIImageView!
	@IBOutlet weak var cellLabel: UILabel!
	
	override func awakeFromNib() {
		super.awakeFromNib()
	}
	
	override func setSelected(_ selected: Bool, animated: Bool) {
		super.setSelected(selected, animated: animated)
	}
	
}
