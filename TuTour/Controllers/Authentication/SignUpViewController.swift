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


class SignUpViewController: UIViewController, UIPickerViewDataSource, UIPickerViewDelegate{
    
    
    @IBOutlet weak var fullNameTextField: UITextField!
    @IBOutlet weak var usernameTextField: UITextField!
    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    @IBOutlet weak var majorTextField: UITextField!
    @IBOutlet weak var schoolTextField: UITextField!
    @IBOutlet weak var profileImage: UIImageView!
    @IBOutlet weak var majorAndSchoolSelector: UIPickerView!
    @IBOutlet weak var signUpButton: UIButton!
    var selectedImage : UIImage?
    //var imageURL:URL?
    @IBOutlet weak var tagsTextField: UITextField!
    @IBOutlet weak var addTagButton: UIButton!
    @IBOutlet weak var tagsLabel: UILabel!
    var tagsArray = [String]()
    
    let schoolArray = ["SJSU", "UCSD", "UCLA"]
    let majorArray = ["Engineering", "English", "Media"]
    let yearArray = ["19", "20", "21", "22"]
    
    var school = ""
    var major = ""
    var year = ""
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //initial state of picker
        school = schoolArray[0]
        major = majorArray[0]
        year = yearArray[0]
        
        majorAndSchoolSelector.delegate = self
        majorAndSchoolSelector.dataSource = self
        //tagsTextField.delegate = self
        
        
        profileImage.layer.cornerRadius = 40
        profileImage.clipsToBounds = true
        
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(SignUpViewController.handleSelectProfileImageView))
        profileImage.isUserInteractionEnabled = true
        
        profileImage.addGestureRecognizer(tapGesture)
        
        //DEACTIVATE BUTTON ON LOAD
        signUpButton.setTitleColor(UIColor.lightText, for: UIControl.State.normal)
        signUpButton.isEnabled = false
        
        handleTextField()
        
        addTagButton.isEnabled = false
        handleTags()//disable addTagButton if textfield is empty
        // Do any additional setup after loading the view.
    }
    
    @IBAction func addTagButtonPressed(_ sender: UIButton) {
        
        print("ADD")
        if tagsTextField.text != nil && tagsTextField.text != ""{
            
            tagsArray.append(tagsTextField.text!)
            tagsLabel.text?.append(" #\(tagsTextField.text!)")
            tagsTextField.text = nil
            addTagButton.isEnabled = false
        }
        
        
        
        
    }
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 3
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        
        if component == 0 {//first picker
            return majorArray.count
        }else if component == 1{
            return schoolArray.count
        }
        return yearArray.count
    }
    
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        if component == 0 {//first picker
            return majorArray[row]
        }else if component == 1{
            return schoolArray[row]
        }
        return yearArray[row]
        
    }
    
    func pickerView(_ pickerView: UIPickerView, attributedTitleForRow row: Int, forComponent component: Int) -> NSAttributedString? {
        
        if component == 0 {
            return NSAttributedString(string: majorArray[row], attributes: [NSAttributedString.Key.foregroundColor: UIColor.white])
        }else if component == 1{
            return NSAttributedString(string: schoolArray[row], attributes: [NSAttributedString.Key.foregroundColor: UIColor.white])
        }
        return NSAttributedString(string: yearArray[row], attributes: [NSAttributedString.Key.foregroundColor: UIColor.white])
        
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        
        if component == 0 {
            major = majorArray[row]
        }else if component == 1 {
            school = schoolArray[row]
        }else{
            year = yearArray[row]
        }
        
        let holder = "\(major) in \(school) graduating \(year)"
        
        print(holder)
    }
    
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        view.endEditing(true)
    }
    
    func handleTextField(){
        fullNameTextField.addTarget(self, action:#selector(self.textFieldDidChange), for: UIControl.Event.editingChanged)
        usernameTextField.addTarget(self, action:#selector(self.textFieldDidChange), for: UIControl.Event.editingChanged)
        emailTextField.addTarget(self, action:#selector(self.textFieldDidChange), for: UIControl.Event.editingChanged)
        passwordTextField.addTarget(self, action:#selector(self.textFieldDidChange), for: UIControl.Event.editingChanged)
        
    }
    
    func handleTags(){
        tagsTextField.addTarget(self, action: #selector(self.tagsDidChange), for: UIControl.Event.editingChanged)
        
    }
    
    @objc func tagsDidChange(){
        
        if (tagsTextField.text?.trimmingCharacters(in: .whitespaces).isEmpty)!{
            addTagButton.isEnabled = false
        } else {
            addTagButton.isEnabled = true
        }
        
        
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
                
                AuthService.signUp(fullname: fullNameTextField.text!, username: usernameTextField.text!, email: emailTextField.text!, password: passwordTextField.text!, school: school, major: major, year: year, imageData: imageData, onSuccess:{
                    
                    
                    ProgressHUD.showSuccess("Success")
                    self.performSegue(withIdentifier: "signUpToDaySelect", sender: nil)
                    
                }, onError: {errorString in
                    
                    ProgressHUD.showError(errorString!)
                })
            }
        } else {
            ProgressHUD.showError("Need a Profile Picture...")
        }
    }
}


extension SignUpViewController: UIImagePickerControllerDelegate, UINavigationControllerDelegate{//}, UITextFieldDelegate{
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        
        
        
        if let image = info[UIImagePickerController.InfoKey.originalImage] as? UIImage{
            self.selectedImage = image
            profileImage.image  = image
            
        }
        dismiss(animated: true, completion: nil)
    }
    
    
}
