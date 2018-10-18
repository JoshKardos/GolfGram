//
//  MessagesViewController.swift
//  GolfGram
//
//  Created by Josh Kardos on 10/14/18.
//  Copyright © 2018 JoshTaylorKardos. All rights reserved.
//

import Foundation
import UIKit
import FirebaseDatabase
class MessagesViewController: UIViewController {
	
	@IBOutlet weak var sendButton: UIButton!
	
	
	@IBOutlet weak var textField: UITextField!
	override func viewDidLoad() {
		super.viewDidLoad()
		
		navigationItem.title = "Chat Log"
	
	}
	override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
		view.endEditing(true)
	}
	
	
	@IBAction func sendPressed(_ sender: Any) {
		let ref = Database.database().reference().child("messages")
		let childRef = ref.childByAutoId()
		let values = ["text": textField.text!, "name": "Josh K"]
		childRef.setValue(values)//updateChildValues(values)
		
	}
	
}
