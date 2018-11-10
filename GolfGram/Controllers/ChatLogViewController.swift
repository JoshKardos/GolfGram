//
//  ChatLogViewController.swift
//  GolfGram
//
//  Created by Josh Kardos on 10/14/18.
//  Copyright © 2018 JoshTaylorKardos. All rights reserved.
//

import Foundation
import UIKit
import FirebaseDatabase
import FirebaseAuth
class ChatLogViewController: UIViewController, UITextFieldDelegate {

	var otherUser: User? = nil
	
	
	lazy var inputTextField: UITextField = {
		let textField = UITextField()
		textField.placeholder = "Enter message..."
		textField.translatesAutoresizingMaskIntoConstraints = false
		textField.delegate = self
		return textField
	}()
	
	let sendButton: UIButton = {
		let sendButton = UIButton(type: .system)
		sendButton.setTitle("Send", for: .normal)
		sendButton.translatesAutoresizingMaskIntoConstraints = false
		sendButton.addTarget(self, action: #selector(sendPressed), for: .touchUpInside)
		return sendButton
	}()
	
	
	
	override func viewDidLoad() {
		super.viewDidLoad()
		self.title = otherUser?.username
		view.backgroundColor = UIColor.white
		setupInputComponents()
	
	}
	
	
	func setupInputComponents(){
	
		let containerView = UIView()
		containerView.translatesAutoresizingMaskIntoConstraints = false
		view.addSubview(containerView)
		
		//constrain bottom
		containerView.leftAnchor.constraint(equalTo: view.leftAnchor).isActive = true
		containerView.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: tabBarController!.tabBar.frame.size.height * (-1)).isActive = true
		containerView.widthAnchor.constraint(equalTo: view.widthAnchor).isActive = true
		containerView.heightAnchor.constraint(equalToConstant: 50).isActive = true
		
		
		containerView.addSubview(sendButton)
		
		sendButton.rightAnchor.constraint(equalTo: containerView.rightAnchor).isActive = true
		sendButton.centerYAnchor.constraint(equalTo: containerView.centerYAnchor).isActive = true
		sendButton.widthAnchor.constraint(equalToConstant: 80).isActive = true
		
		sendButton.heightAnchor.constraint(equalTo: containerView.heightAnchor).isActive = true
		
		
		
		containerView.addSubview(inputTextField)
		
		inputTextField.leftAnchor.constraint(equalTo: containerView.leftAnchor, constant: 8).isActive = true
		inputTextField.centerYAnchor.constraint(equalTo: containerView.centerYAnchor).isActive = true
		inputTextField.rightAnchor.constraint(equalTo: sendButton.leftAnchor).isActive = true
		inputTextField.heightAnchor.constraint(equalTo: containerView.heightAnchor).isActive = true
		
		let separatorLineView = UIView()
		separatorLineView.backgroundColor = UIColor.lightGray
		separatorLineView.translatesAutoresizingMaskIntoConstraints = false
		containerView.addSubview(separatorLineView)

		separatorLineView.leftAnchor.constraint(equalTo: containerView.leftAnchor).isActive = true
		separatorLineView.topAnchor.constraint(equalTo: containerView.topAnchor).isActive = true
		separatorLineView.widthAnchor.constraint(equalTo: containerView.widthAnchor).isActive = true
		separatorLineView.heightAnchor.constraint(equalToConstant: 1).isActive = true
	}
	override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
		view.endEditing(true)
	}
	
	
	@objc func sendPressed(){
		let uid = Auth.auth().currentUser!.uid
		let ref = Database.database().reference().child("messages")
		let childRef = ref.childByAutoId()
		
		let timestamp = Int(NSDate().timeIntervalSince1970)
		let toId = otherUser!.uid
		
		let values = ["text": inputTextField.text!, "senderID": uid, "toId": toId, "timestamp": timestamp] as [String : Any]

		childRef.updateChildValues(values, withCompletionBlock: { (error, snapshot) in
			if error != nil{
				print(error)
				return
			}
			
			let userMessagesRef = Database.database().reference().child("user-messages").child(uid)
			let messageId = childRef.key
			
			
			//userMessagesRef.setValue([messageId: 1])
			userMessagesRef.updateChildValues([messageId!: 1])
			
			
			let recipientUserMessagesRef = Database.database().reference().child("user-messages").child(toId!)
			recipientUserMessagesRef.updateChildValues([messageId!: 1])
		})
	}
	
	
	
//	@IBAction func sendPressed(_ sender: Any) {
//		let ref = Database.database().reference().child("messages")
//		let childRef = ref.childByAutoId()
//		let values = ["text": textField.text!, "sender": "Josh K"]
//		childRef.setValue(values)//updateChildValues(values)
//
//	}
	
}
