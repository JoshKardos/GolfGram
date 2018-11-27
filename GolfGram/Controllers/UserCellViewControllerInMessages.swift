//
//  UserCellViewControllerInMessages.swift
//  GolfGram
//
//  Created by Josh Kardos on 11/9/18.
//  Copyright © 2018 JoshTaylorKardos. All rights reserved.
//

import Foundation

import UIKit

import FirebaseAuth
import FirebaseDatabase

class UserCellViewControllerInMessages: UITableViewCell{

	@IBOutlet weak var cellLabel: UILabel!
	@IBOutlet weak var cellImage: UIImageView!
	
	let profileButton: UIButton = {
		let sendButton = UIButton(type: .system)
		sendButton.setTitle("Profile", for: .normal)
		sendButton.translatesAutoresizingMaskIntoConstraints = false
		sendButton.addTarget(self, action: #selector(goPressed), for: .touchUpInside)
		return sendButton
	}()
	
	override func awakeFromNib() {

		
		//profileButton.rightAnchor.constraint(equalTo: containerView.rightAnchor).isActive = true
		//profileButton.centerYAnchor.constraint(equalTo: containerView.centerYAnchor).isActive = true
		//profileButton.widthAnchor.constraint(equalToConstant: 80).isActive = true

		//profileButton.heightAnchor.constraint(equalTo: containerView.heightAnchor).isActive = true
		super.awakeFromNib()

	}
//
	@objc func goPressed(){
//
//		let cell
//
	}
	override func setSelected(_ selected: Bool, animated: Bool) {
		super.setSelected(selected, animated: animated)
	}

}
