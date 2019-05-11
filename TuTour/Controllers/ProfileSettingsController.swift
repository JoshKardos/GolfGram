//
//  ProfileSettingsController.swift
//  TuTour
//
//  Created by Alan Boo on 2/5/19.
//  Copyright © 2019 JoshTaylorKardos. All rights reserved.
//

import UIKit
import FirebaseAuth
import FirebaseDatabase
import FirebaseStorage
import TextFieldEffects


class ProfileSettingsController: UIViewController, UITextFieldDelegate, UIPickerViewDelegate, UIPickerViewDataSource {
  
    

    
    @IBOutlet weak var confirm: UIButton!
    @IBOutlet weak var updateButton: UIButton!
    @IBOutlet weak var profilePhoto: UIImageView!
    @IBOutlet weak var nameField: UITextField!
    @IBOutlet weak var schoolField: UITextField!
    @IBOutlet weak var majorField: UITextField!
    @IBOutlet weak var yearField: UITextField!
    @IBOutlet weak var descriptionField: UITextField!
    
    let userID = Auth.auth().currentUser!.uid
    var selectedPhoto: UIImage?
    var photoURLString: String?
    
    var currentTextField = UITextField()
    var pickerView = UIPickerView()
    
    let schoolArray = ["SJSU", "UCSD", "UCLA"]
    let majorArray = ["Engineering", "English", "Media"]
    let yearArray = ["19", "20", "21", "22"]
    
    // pressed confirm button to update all data
    @IBAction func confirmAction(_ sender: Any) {
        
        let usersRef = Database.database().reference().child("users")
        
        //Get reference to the profile images//
        ///////////////////////////////////////
        let storageRef = Storage.storage().reference(forURL: "gs://golfgram-68599.appspot.com").child("profile_image").child(userID)
        
        
        if let profileImage = self.selectedPhoto {
            if let imageData = profileImage.jpegData(compressionQuality: 0.1) {
                
                storageRef.putData(imageData, metadata: nil, completion: { (metadata, error) in
                    if error != nil{
                        print("Error \(String(describing: error?.localizedDescription))")
                        return
                    }
                    
                    storageRef.downloadURL { (url, error) in
                        if error != nil{
                            print("Error \(String(describing: error?.localizedDescription))")
                            return
                        }
                        //get url of image
                        guard let profileImageUrl = url?.absoluteString else {return}
                        
                        //self.photoURLString = profileImageUrl
                        let updatedValueList = ["fullname": self.nameField.text!, "major": self.majorField.text!, "school": self.schoolField.text!, "year": self.yearField.text!, "profileImageUrl": profileImageUrl, "description": self.descriptionField.text!]
                        
                        usersRef.child(self.userID).updateChildValues(updatedValueList)
                        
                    }
                })
            }
            
        } else {
            let updatedValueList = ["fullname": self.nameField.text!, "major": self.majorField.text!, "school": self.schoolField.text!, "year": self.yearField.text!, "profileImageUrl": self.photoURLString!, "description": self.descriptionField.text!]
            usersRef.child(self.userID).updateChildValues(updatedValueList)
        }
        

    }
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        if currentTextField == schoolField {
            return schoolArray.count
        } else if currentTextField == majorField {
            return majorArray.count
        } else if currentTextField == yearField {
            return yearArray.count
        } else {
            return 0
        }
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        if currentTextField == schoolField {
            return schoolArray[row]
        } else if currentTextField == majorField {
            return majorArray[row]
        } else if currentTextField == yearField {
            return yearArray[row]
        } else {
            return ""
        }
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        if currentTextField == schoolField {
            self.schoolField.text = schoolArray[row]
            self.view.endEditing(true)
        } else if currentTextField == majorField {
            self.majorField.text = majorArray[row]
            self.view.endEditing(true)
        } else if currentTextField == yearField {
            self.yearField.text = yearArray[row]
            self.view.endEditing(true)
        }
    }
    
    func textFieldDidBeginEditing(_ textField: UITextField) {
        self.pickerView.delegate = self
        self.pickerView.dataSource = self
        
        currentTextField = textField
        
        if currentTextField == schoolField {
            print("SCHOOOOOL")
            currentTextField.inputView = pickerView
        } else if currentTextField == majorField {
           currentTextField.inputView = pickerView
        } else if currentTextField == yearField {
            currentTextField.inputView = pickerView
        }
    }
    
    func getData(uid: String) {
    
        Database.database().reference().child("users").child(uid).observeSingleEvent(of: .value, with: {(snapshot) in
            
                let profileImageString = (snapshot.value as! NSDictionary)["profileImageUrl"] as! String
                let url = URL(string: profileImageString)
                self.photoURLString = profileImageString
            
                let imageData = NSData.init(contentsOf: url as! URL!)
                self.profilePhoto?.image = UIImage(data: imageData as! Data!)
            
                let nameString = ((snapshot.value as! NSDictionary)["fullname"] as! String)
                self.nameField.text = nameString
                let schoolString = ((snapshot.value as! NSDictionary)["school"] as! String)
                self.schoolField.text = schoolString
                let majorString = ((snapshot.value as! NSDictionary)["major"] as! String)
                self.majorField.text = majorString
                let yearString = ((snapshot.value as! NSDictionary)["year"] as! String)
                self.yearField.text = yearString
                //let descString = ((snapshot.value as! NSDictionary)["description"] as! String)
                //self.descriptionField.text = descString
            
            })
        
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        confirm.backgroundColor = AppDelegate.theme_Color
        nameField.tintColor = AppDelegate.theme_Color
        schoolField.tintColor = AppDelegate.theme_Color
        majorField.tintColor = AppDelegate.theme_Color
        yearField.tintColor = AppDelegate.theme_Color
        descriptionField.tintColor = AppDelegate.theme_Color
        
        //Photo update functionality
        profilePhoto.layer.cornerRadius = 40
        profilePhoto.clipsToBounds = true
        
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(SignUpViewController.handleSelectProfileImageView))
        profilePhoto.isUserInteractionEnabled = true
        
        profilePhoto.addGestureRecognizer(tapGesture)

        profilePhoto.clipsToBounds = true
        getData(uid: userID)
        
    }
    
    
    @objc func handleSelectProfileImageView() {
        let pickerController = UIImagePickerController()
        //access to extension
        pickerController.delegate = (self as UIImagePickerControllerDelegate & UINavigationControllerDelegate)
        present(pickerController, animated: true, completion: nil)
        
    }
    
}

extension ProfileSettingsController: UIImagePickerControllerDelegate, UINavigationControllerDelegate{
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        
        
        
        if let image = info[UIImagePickerController.InfoKey.originalImage] as? UIImage{
            self.selectedPhoto = image
            profilePhoto.image  = image
            
        }
        //print("** \(info) **")
        //profileImage.image = infoPhoto
        dismiss(animated: true, completion: nil)
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        view.endEditing(true)
    }
}
