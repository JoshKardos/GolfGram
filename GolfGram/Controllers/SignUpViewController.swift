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
import FirebaseStorage

class SignUpViewController: UIViewController {
	
	@IBOutlet weak var usernameTextField: UITextField!
	@IBOutlet weak var emailTextField: UITextField!
	@IBOutlet weak var passwordTextField: UITextField!
	@IBOutlet weak var profileImage: UIImageView!
	
	var selectedImage : UIImage?
	//var imageURL:URL?
	
	override func viewDidLoad() {
        super.viewDidLoad()

		profileImage.layer.cornerRadius = 10
		
		profileImage.clipsToBounds = true
		
		let tapGesture = UITapGestureRecognizer(target: self, action: #selector(SignUpViewController.handleSelectProfileImageView))
		profileImage.isUserInteractionEnabled = true
		
		profileImage.addGestureRecognizer(tapGesture)
		
        // Do any additional setup after loading the view.
    }
	
	@objc func handleSelectProfileImageView(){
		
		let pickerController = UIImagePickerController()
		//access to extension
		pickerController.delegate = (self as UIImagePickerControllerDelegate & UINavigationControllerDelegate)
		present(pickerController, animated: true, completion: nil)
		
		
		
	}
	@IBAction func dismiss_onClick(_ sender: Any) {
		dismiss(animated: true, completion: nil)
	}
	
	@IBAction func signUpPressed(_ sender: Any) {
		
		/////////////////////
		////Create User//////
		/////////////////////
		Auth.auth().createUser(withEmail: emailTextField.text!, password: passwordTextField.text!) { (user, error) in
			if error != nil {
				print("Eror creating user: \(error!.localizedDescription)")
				return
			}
		
			//Get reference to the profile images//
			///////////////////////////////////////
			let storageRef = Storage.storage().reference(forURL: "gs://golfgram-68599.appspot.com").child("profile_image").child((user?.user.uid)!)
			
			//Must have selected an image
			if let profileImg = self.selectedImage{
				print("Inside")
				
				//turn sleected photo into jpeg
				guard let imageData = profileImg.jpegData(compressionQuality: 0.1) else { fatalError("ERROR INSIDE")}
				
				//insert jpeg data into database with the url
				storageRef.putData(imageData, metadata: nil, completion: { (metadata, error) in
					if error != nil{
						print("Error \(error?.localizedDescription)")
						return
					}
					storageRef.downloadURL { (url, error) in
						if error != nil{
							print("Error \(error?.localizedDescription)")
							return
						}
						//get url of image
						guard let profileImageUrl = url?.absoluteString else {return}
						
						//get referenece to users in the database
						let usersRef = Database.database().reference().child("users")
						
						
						//save user(username, email, profileImage)
						usersRef.childByAutoId().setValue(["username": self.usernameTextField.text!, "email" : self.emailTextField.text!, "profileImageUrl": profileImageUrl])
					}
				})
			}
		}
	}
	
}


extension SignUpViewController: UIImagePickerControllerDelegate, UINavigationControllerDelegate{
	func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
		
		
		
		if let image = info[UIImagePickerController.InfoKey.originalImage] as? UIImage{
			self.selectedImage = image
			profileImage.image  = image
			
		}
		//print("** \(info) **")
		//profileImage.image = infoPhoto
		dismiss(animated: true, completion: nil)
	}
	
	
}
