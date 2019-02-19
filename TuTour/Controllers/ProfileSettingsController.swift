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
import TextFieldEffects

class ProfileSettingsController: UIViewController, UITextFieldDelegate, UIPickerViewDelegate, UIPickerViewDataSource {
  
    
    @IBOutlet weak var updateButton: UIButton!
    @IBOutlet weak var profilePhoto: UIImageView!
    @IBOutlet weak var nameField: UITextField!
    @IBOutlet weak var schoolField: UITextField!
    @IBOutlet weak var majorField: UITextField!
    @IBOutlet weak var yearField: UITextField!
    @IBOutlet weak var descriptionField: UITextField!
    
    
    var currentTextField = UITextField()
    var pickerView = UIPickerView()
    
//    var nameFieldIsao: IsaoTextField!
//    var schoolFieldIsao: IsaoTextField!
//    var majorFieldIsao: IsaoTextField!
//    var yearFieldIsao: IsaoTextField!
//    var descFieldIsao: IsaoTextField!
    
    let schoolArray = ["SJSU", "UCSD", "UCLA"]
    let majorArray = ["Engineering", "English", "Media"]
    let yearArray = ["19", "20", "21", "22"]
    
    
    @IBAction func confirmAction(_ sender: Any) {
        
        
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
            })
        
    }
    
    // Convert UITextFields to Isao
//    func styleFields(field: UITextField) -> IsaoTextField {
//
//        let styledField = IsaoTextField(frame: field.frame)
//        styledField.activeColor = UIColor(red: 0/255, green: 106/255, blue: 255/255, alpha: 1.0)
//        styledField.inactiveColor = .lightGray
//
//        return styledField
//    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        let userID = Auth.auth().currentUser!.uid
        
//        self.nameFieldIsao = styleFields(field: nameField)
//        nameFieldIsao.placeholder = "Name"
//
//        self.schoolFieldIsao = styleFields(field: schoolField)
//        schoolFieldIsao.placeholder = "School"
//
//        self.majorFieldIsao = styleFields(field: majorField)
//        majorFieldIsao.placeholder = "Major"
//
//        self.yearFieldIsao = styleFields(field: yearField)
//        yearFieldIsao.placeholder = "Year"
//
//        self.descFieldIsao = styleFields(field: descriptionField)
//        descFieldIsao.placeholder = "Description"
        
        getData(uid: userID)
        
        //self.view.addSubview(nameFieldIsao)
        //self.view.addSubview(schoolFieldIsao)
        //self.view.addSubview(majorFieldIsao)
        //self.view.addSubview(yearFieldIsao)
        //self.view.addSubview(descFieldIsao)
        //self.view.addSubview(pickerView)
    }
    

    
}
