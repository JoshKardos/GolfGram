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
class ChatLogViewController: UIViewController, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout ,UICollectionViewDelegate , UITextFieldDelegate {
	
	var messages = [Message]()
	var collectionView: UICollectionView?
	var otherUser: User?{
		didSet {
			navigationItem.title = otherUser?.username

			observeMessages()
		}
	}
	
	let cellId = "cellId"
	
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
		
		let layout = UICollectionViewFlowLayout()
		collectionView = UICollectionView(frame: self.view.frame, collectionViewLayout: layout)
		collectionView!.register(DirectMessageBubble.self, forCellWithReuseIdentifier: cellId)
		
		collectionView!.contentInset = UIEdgeInsets(top: 8, left: 0, bottom: 0, right: 0)
		collectionView!.alwaysBounceVertical = true
		collectionView!.delegate = self
		collectionView!.dataSource = self
		self.view.addSubview(collectionView!)
		
		collectionView!.backgroundColor = UIColor.white
		
		setupBottomComponents()
	
	}
	
	func observeMessages(){
		
		guard let uid = Auth.auth().currentUser?.uid else { return }
		let userMessagesRef = Database.database().reference().child("user-messages").child(uid)
		
		
		userMessagesRef.observe(.childAdded, with: { (snapshot) in
			
			let messageId = snapshot.key
			
			let messagesRef = Database.database().reference().child("messages").child(messageId)
			
			messagesRef.observeSingleEvent(of: .value, with: { (snapshot) in
				
				
				guard let dictionary = snapshot.value as? [String: AnyObject] else { return }
				print("** \(dictionary)")
				let message = Message(dictionary: dictionary)
				
				if message.chatPartnerId() == self.otherUser?.uid{
					self.messages.append(message)
					
					DispatchQueue.main.async {
						self.collectionView!.reloadData()
					}
					
				}
				
			})
		}, withCancel: nil)
	}
	
	
	func numberOfSections(in collectionView: UICollectionView) -> Int {
		return 1
	}
	func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
		return messages.count
	}
	
	func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
		
		let cell = collectionView.dequeueReusableCell(withReuseIdentifier: cellId, for: indexPath) as! DirectMessageBubble
		let message = messages[indexPath.row]
		cell.textView.text = message.text
		
		
		cell.bubbleWidthAnchor?.constant = estimatedFrameForText(text: message.text!).width + 32
		
		return cell
	}
	
	private func estimatedFrameForText(text: String) -> CGRect{
		
		let size = CGSize(width: 200, height: 1000)
		let options = NSStringDrawingOptions.usesFontLeading.union(.usesLineFragmentOrigin)
		return NSString(string: text).boundingRect(with: size, options: options, attributes: [NSAttributedString.Key.font : UIFont.systemFont(ofSize: 16)], context: nil)
		
	}
	
	func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
		
		var height: CGFloat?
		
		if let text = messages[indexPath.item].text{
			height = estimatedFrameForText(text: text).height + 20
		}
		
		return CGSize(width: view.frame.width, height: height!)
	}
	func setupBottomComponents(){
	
		let containerView = UIView()
		containerView.backgroundColor = UIColor.white
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
			self.inputTextField.text = nil
			let userMessagesRef = Database.database().reference().child("user-messages").child(uid)
			let messageId = childRef.key
			
			userMessagesRef.updateChildValues([messageId!: 1])
			
			
			let recipientUserMessagesRef = Database.database().reference().child("user-messages").child(toId!)
			recipientUserMessagesRef.updateChildValues([messageId!: 1])
		})
	}
	
	
	
}
