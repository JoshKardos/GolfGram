//
//  SignUpViewController.swift
//  GolfGram
//
//  Created by Josh Kardos on 9/24/18.
//  Copyright © 2018 JoshTaylorKardos. All rights reserved.
//

import UIKit
import FirebaseAuth
import FirebaseDatabase


class SignUpViewController: UIViewController {
	@IBOutlet weak var usernameTextField: UITextField!
	@IBOutlet weak var emailTextField: UITextField!
	@IBOutlet weak var passwordTextField: UITextField!
	@IBOutlet weak var profileImage: UIImageView!
	
	
	override func viewDidLoad() {
        super.viewDidLoad()

		profileImage.layer.cornerRadius = 10
		profileImage.clipsToBounds = true
        // Do any additional setup after loading the view.
    }
    
	@IBAction func dismiss_onClick(_ sender: Any) {
		dismiss(animated: true, completion: nil)
	}
	
	@IBAction func signUpPressed(_ sender: Any) {
		
		
		Auth.auth().createUser(withEmail: emailTextField.text!, password: passwordTextField.text!) { (user, error) in
			
			if error != nil {
				print("Eror creating user: \(error!.localizedDescription)")
				return
			}
			let ref = Database.database().reference()
			let usersReference = ref.child("users")
			usersReference.childByAutoId().setValue(["username": self.usernameTextField.text!, "email" : self.emailTextField.text!])
			//let newUserReference = usersReference.child(idUser)
		}
	}
	
}
