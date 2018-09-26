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
	var imageURL:URL?
	
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
		
		
		Auth.auth().createUser(withEmail: emailTextField.text!, password: passwordTextField.text!) { (user, error) in
			
			if error != nil {
				print("Eror creating user: \(error!.localizedDescription)")
				return
			}
			
			let uid = user?.user.uid
			
			let storageRef = Storage.storage().reference(forURL: "gs://golfgram-68599.appspot.com").child("profile_image").child(uid!)
			
			if let profileImg = self.selectedImage{
				print("Inside")
				guard let imageData = profileImg.jpegData(compressionQuality: 0.1) else { fatalError("ERROR INSIDE")}
				
				storageRef.putData(imageData, metadata: nil, completion: { (metadata, error) in
					if error != nil{
						print("AYO ERROR")
						return
					}
					
					storageRef.downloadURL { (url, error) in
						
						guard let profileImageUrl = url?.absoluteString else {return}
						
						
						let ref = Database.database().reference()
						let usersReference = ref.child("users")
						
						
						usersReference.childByAutoId().setValue(["username": self.usernameTextField.text!, "email" : self.emailTextField.text!, "profileImageUrl": profileImageUrl])
					
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
