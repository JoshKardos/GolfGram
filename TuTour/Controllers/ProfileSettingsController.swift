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

class ProfileSettingsController: UIViewController {
  
    
    @IBOutlet weak var updateButton: UIButton!
    @IBOutlet weak var profilePhoto: UIImageView!
    @IBOutlet weak var nameField: UITextField!
    @IBOutlet weak var schoolField: UITextField!
    @IBOutlet weak var majorField: UITextField!
    @IBOutlet weak var yearField: UITextField!
    @IBOutlet weak var descriptionField: UITextField!
    
    func getPhoto(uid: String) {
        
        Database.database().reference().child("users").child(uid).observeSingleEvent(of: .value, with: {(snapshot) in
            
            let profileImageString = (snapshot.value as! NSDictionary)["profileImageUrl"] as! String
            let url = URL(string: profileImageString)
            let imageData = NSData.init(contentsOf: url as! URL)
            self.profilePhoto?.image = UIImage(data: imageData as! Data)
            
        })
        
    }
    
    func styleFields(field: UITextField) -> IsaoTextField {
        
        let styledField = IsaoTextField(frame: field.frame)
        //styledField.placeholderColor = .lightGray
        styledField.activeColor = UIColor(red: 0/255, green: 106/255, blue: 255/255, alpha: 1.0)
        styledField.inactiveColor = .lightGray
        
        return styledField
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let userID = Auth.auth().currentUser!.uid
        
        getPhoto(uid: userID)
        
        
        let nameFieldHoshi = styleFields(field: nameField)
        nameFieldHoshi.placeholder = "Name"
        let schoolFieldHoshi = styleFields(field: schoolField)
        schoolFieldHoshi.placeholder = "School"
        let majorFieldHoshi = styleFields(field: majorField)
        majorFieldHoshi.placeholder = "Major"
        let yearFieldHoshi = styleFields(field: yearField)
        yearFieldHoshi.placeholder = "Year"
        let descriptionFieldHoshi = styleFields(field: descriptionField)
        descriptionFieldHoshi.placeholder = "Description"

        
        self.view.addSubview(nameFieldHoshi)
        self.view.addSubview(schoolFieldHoshi)
        self.view.addSubview(majorFieldHoshi)
        self.view.addSubview(yearFieldHoshi)
        self.view.addSubview(descriptionFieldHoshi)
    }
    

    
}
