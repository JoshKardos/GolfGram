//
//  SignInViewController.swift
//  GolfGram
//
//  Created by Josh Kardos on 9/24/18.
//  Copyright © 2018 JoshTaylorKardos. All rights reserved.
//

import UIKit
import FirebaseAuth

class SignInViewController: UIViewController {
	@IBOutlet weak var emailTextField: UITextField!
	@IBOutlet weak var passwordTextField: UITextField!
	@IBOutlet weak var signInButton: UIButton!
	
	override func viewDidLoad() {
		super.viewDidLoad()
		
		//DEACTIVATE BUTTON ON LOAD
		signInButton.setTitleColor(UIColor.lightText, for: UIControl.State.normal)
		signInButton.isEnabled = false
		
		handleTextField()
		
	}
	
	override func viewDidAppear(_ animated: Bool) {
		super.viewDidAppear(animated)
		if Auth.auth().currentUser != nil {
			self.performSegue(withIdentifier: "signInToTabbarVC", sender: nil)
		}
	}
	func handleTextField(){
		emailTextField.addTarget(self, action:#selector(SignUpViewController.textFieldDidChange), for: UIControl.Event.editingChanged)
		passwordTextField.addTarget(self, action:#selector(SignUpViewController.textFieldDidChange), for: UIControl.Event.editingChanged)
		
	}
	
	@objc func textFieldDidChange(){
		guard let email = emailTextField.text, !email.isEmpty, let password = passwordTextField.text, !password.isEmpty else {
			signInButton.setTitleColor(UIColor.lightText, for: UIControl.State.normal)
			signInButton.isEnabled = false
			return
		}
		signInButton.setTitleColor(UIColor.white, for: UIControl.State.normal)
		signInButton.isEnabled = true
	}
	
	@IBAction func signInButton(_ sender: Any) {
		
		
		AuthService.signIn(email: emailTextField.text!, password: passwordTextField.text!, onSuccess:{
			//print("OnSuccess")
			self.performSegue(withIdentifier: "signInToTabbarVC", sender: nil)
			
		}, onError: { errorString in
			
			print(errorString!)
			
		})
	}
	
	
	
}
