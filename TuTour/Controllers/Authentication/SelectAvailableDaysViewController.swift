//
//  DaySelectInSignUpViewController.swift
//  TuTour
//
//  Created by Josh Kardos on 2/12/19.
//  Copyright © 2019 JoshTaylorKardos. All rights reserved.
//

import Foundation
import UIKit
import Firebase
class SelectAvailableDaysViewController: UIViewController{
    
    
    @IBOutlet var daySwitches: [UISwitch]!
    //Monday
    //Tuesday
    //Wednesday
    //Thursday
    //Friday
    //Saturday
    //Sunday
    @IBOutlet var dayLabels: [UILabel]!
    
    
    //ADD tag elements
    @IBOutlet weak var tagsTextField: UITextField!
    @IBOutlet weak var addTagButton: UIButton!
    var tagsArray = [String]()
    @IBOutlet var addedTagsLabels: [AddedTagsLabelViewInSignUp]!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        addTagButton.isEnabled = false
        handleTags()//disable addTagButton if textfield is empty
        // Do any additional setup after loading the view.
        
        updateTagsFromArray()
        
        //initiliaze each tag label's signup vc as self
        //needed for when user deletes an added tag
        for i in 0..<addedTagsLabels.count{
            addedTagsLabels[i].signUpViewController = self
        }
        self.hideKeyboard()
        
    }
    
    @IBAction func addTagButtonPressed(_ sender: UIButton) {
        
        print("ADD")
        if tagsTextField.text != nil && tagsTextField.text != ""{
            
            tagsArray.append(tagsTextField.text!)
            tagsTextField.text = nil
            addTagButton.isEnabled = false
        }
        updateTagsFromArray()
        
    }
    
    func updateTagsFromArray(){
        for i in 0..<addedTagsLabels.count{
            if i < tagsArray.count{
                addedTagsLabels[i].isHidden = false
                addedTagsLabels[i].label.text = tagsArray[i]
            } else {
                addedTagsLabels[i].isHidden = true
            }
        }
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
    
    
    @IBAction func addDays(_ sender: UIButton) {
        
        var daysOpen = [String]()
        
        for i in 0..<daySwitches.count{
            
            if daySwitches[i].isOn == true{
                
                daysOpen.append(dayLabels[i].text!)
            }
        }
        
        var daysOpenMap = [String: Int]()
        for index in daysOpen.indices{
            daysOpenMap[daysOpen[index]] = 1
        }
        if daysOpenMap.count > 0{ Database.database().reference().child("users").child((Auth.auth().currentUser?.uid)!).child("availableDays").setValue(daysOpenMap)
        }
        
        var skillsMap = [String: Int]()
        for index in tagsArray.indices{
            skillsMap[tagsArray[index]] = 1
        }
        if daysOpenMap.count > 0{ Database.database().reference().child("users").child((Auth.auth().currentUser?.uid)!).child("skills").setValue(skillsMap)
        }
        
        
        
    }
    

    
    
}

extension UIViewController
{
    func hideKeyboard()
    {
        let tap: UITapGestureRecognizer = UITapGestureRecognizer(
            target: self,
            action: #selector(UIViewController.dismissKeyboard))
        
        tap.cancelsTouchesInView = false
        view.addGestureRecognizer(tap)
    }
    
    @objc func dismissKeyboard()
    {
        view.endEditing(true)
    }
}
