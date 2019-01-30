//
//  SignUpViewController.swift
//  TuTour
//
//  Created by Josh Kardos on 9/24/18.
//  Copyright © 2018 JoshTaylorKardos. All rights reserved.
//

import UIKit
import FirebaseAuth
import FirebaseDatabase
import FirebaseStorage
import ProgressHUD


class SignUpViewController: UIViewController {
	
	@IBOutlet weak var usernameTextField: UITextField!
	@IBOutlet weak var emailTextField: UITextField!
	@IBOutlet weak var passwordTextField: UITextField!
	@IBOutlet weak var profileImage: UIImageView!
	
	@IBOutlet weak var signUpButton: UIButton!
	var selectedImage : UIImage?
	//var imageURL:URL?
	
	override func viewDidLoad() {
        super.viewDidLoad()

		profileImage.layer.cornerRadius = 10
		
		profileImage.clipsToBounds = true
		
		let tapGesture = UITapGestureRecognizer(target: self, action: #selector(SignUpViewController.handleSelectProfileImageView))
		profileImage.isUserInteractionEnabled = true
		
		profileImage.addGestureRecognizer(tapGesture)
		
		//DEACTIVATE BUTTON ON LOAD
		signUpButton.setTitleColor(UIColor.lightText, for: UIControl.State.normal)
		signUpButton.isEnabled = false
		
		handleTextField()
		
		
        // Do any additional setup after loading the view.
    }
	
	override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
		view.endEditing(true)
	}
	
	func handleTextField(){
		usernameTextField.addTarget(self, action:#selector(self.textFieldDidChange), for: UIControl.Event.editingChanged)
		emailTextField.addTarget(self, action:#selector(self.textFieldDidChange), for: UIControl.Event.editingChanged)
		passwordTextField.addTarget(self, action:#selector(self.textFieldDidChange), for: UIControl.Event.editingChanged)
	
	}
	
	@objc func textFieldDidChange(){
		guard let username = usernameTextField.text, !username.isEmpty, let email = emailTextField.text, !email.isEmpty, let password = passwordTextField.text, !password.isEmpty else {
			
			signUpButton.setTitleColor(UIColor.lightText, for: UIControl.State.normal)
			signUpButton.isEnabled = false
			return
		}
		signUpButton.setTitleColor(UIColor.white, for: UIControl.State.normal)
		signUpButton.isEnabled = true
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
		view.endEditing(true)
		ProgressHUD.show("Waiting...", interaction: false)
		//Must have selected an image, image turned to jpeg
		if let profileImg = self.selectedImage{
			if let imageData = profileImg.jpegData(compressionQuality: 0.1) {

				AuthService.signUp(username: usernameTextField.text!, email: emailTextField.text!, password: passwordTextField.text!, imageData: imageData, onSuccess: {
				
				ProgressHUD.showSuccess("Success")
				self.performSegue(withIdentifier: "signUpToTabbarVC", sender: nil)
			
			}, onError: {errorString in
			
				ProgressHUD.showError(errorString!)
			})
			}
		} else {
			ProgressHUD.showError("Could not sign up user")
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
