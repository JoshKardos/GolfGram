//
//  DirectMessageCell.swift
//  GolfGram
//
//  Created by Josh Kardos on 11/30/18.
//  Copyright © 2018 JoshTaylorKardos. All rights reserved.
//

import Foundation
import UIKit
class DirectMessageBubble: UICollectionViewCell{
	let textView: UITextView = {
		let tv = UITextView()
		tv.text = "SAMPLE TEXT"
		tv.font = UIFont.systemFont(ofSize: 16)
		tv.translatesAutoresizingMaskIntoConstraints = false
		tv.backgroundColor = UIColor.clear
		tv.textColor = UIColor.white
		return tv
	}()
	
	let bubbleView: UIView = {
		let view = UIView()
		view.backgroundColor = UIColor.blue// UIColor(red: 0, green: 137, blue: 249)
		view.translatesAutoresizingMaskIntoConstraints = false
		view.layer.cornerRadius = 16
		view.layer.masksToBounds = true
		return view
	}()
	var bubbleWidthAnchor: NSLayoutConstraint?
	override init(frame: CGRect) {
		super.init(frame: frame)
		
		addSubview(bubbleView)
		addSubview(textView)
		
		bubbleView.rightAnchor.constraint(equalTo: self.rightAnchor, constant: -8).isActive = true
		bubbleView.topAnchor.constraint(equalTo: self.topAnchor).isActive = true
		bubbleView.heightAnchor.constraint(equalTo: self.heightAnchor).isActive = true
		
		bubbleWidthAnchor = bubbleView.widthAnchor.constraint(equalToConstant: 	200)
		bubbleWidthAnchor?.isActive = true
		
		//constraints
		textView.leftAnchor.constraint(equalTo: bubbleView.leftAnchor, constant: 8).isActive = true
		textView.topAnchor.constraint(equalTo: self.topAnchor).isActive = true
		
		textView.rightAnchor.constraint(equalTo: bubbleView.rightAnchor).isActive = true
		textView.heightAnchor.constraint(equalTo: self.heightAnchor).isActive = true
		
		
	
	}
	
	required init?(coder aDecoder: NSCoder) {
		fatalError("init(coder:) has not been implemented")
	}
	
}
