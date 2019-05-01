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
import TaggerKit
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

    var tagsArray = [String]()
    
    @IBOutlet weak var addedTagsCollectionView: UIView!
    @IBOutlet weak var tagsTextField: TKTextField!
    var addedTagsCollection = TKCollectionView()
    @IBOutlet weak var topTagsCollection: UIView!
    var filteredTagsCollection = TKCollectionView()
    override func tagIsBeingAdded(name: String?) {
        print("TAG ADDED")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        addedTagsCollection.tags = []
//        tagsTextField.tintColor = AppDelegate.theme_Color
        Database.database().reference().child("users").child((Auth.auth().currentUser?.uid)!).child("skills").observe(.value) { (snapshot) in
            let dictionary = snapshot.value as! [String: AnyObject]
            
            for (skill, _) in dictionary{
                print(skill)
                self.addedTagsCollection.tags.append(skill)
            }
            
            
            
            
            
            //all tags
            self.add(self.filteredTagsCollection, toView: self.topTagsCollection)
            self.filteredTagsCollection.action = .addTag
            self.filteredTagsCollection.receiver = self.addedTagsCollection
            
            //add tags
            self.add(self.addedTagsCollection, toView: self.addedTagsCollectionView)
            self.addedTagsCollection.action = .removeTag
            
            
            self.tagsTextField.sender = self.filteredTagsCollection
            self.tagsTextField.receiver = self.addedTagsCollection
            
            
            
            
            self.addedTagsCollection.delegate = self
            self.filteredTagsCollection.delegate = self

            
        }
        
        
        
        for sw in daySwitches {
            sw.onTintColor = AppDelegate.theme_Color
        }
        for i in 0..<dayLabels.count{
            
            
            Database.database().reference().child("availableDay-users").child(dayLabels[i].text!).observe(.value) { (snapshot) in
                if let snap = snapshot.value as? [String: AnyObject]{
                    if snap[(Auth.auth().currentUser?.uid)!] != nil{
                        self.daySwitches[i].isOn = true
                    }
                }
                
                
            }
        }
       
        self.hideKeyboard()
        
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
        if daysOpen.count > 0 || addedTagsCollection.tags.count>0{
            Database.database().reference().child("users").child((Auth.auth().currentUser?.uid)!).child("availableDays").setValue(daysOpenMap)
            
            //need to delete from "availableDay-users" node if not a key in days open map
            
            var daysInDatabase = [String]()
            for i in 0..<dayLabels.count{
                daysInDatabase.append(dayLabels[i].text!)
            }//Monday,Tuesday,Wednesday, Thursday, Friday, Saturday, Sunday
            
            //create array of days not added as free day
            var daysToDeleteUserFrom = [String]()
            for index in daysInDatabase.indices{
                if daysOpenMap[daysInDatabase[index]] == nil{
                    daysToDeleteUserFrom.append(daysInDatabase[index])
                }
            }
            
            //delete users from days they havent chosen
            for index in daysToDeleteUserFrom.indices{
                print("Delete \(daysToDeleteUserFrom[index])")
                Database.database().reference().child("availableDay-users").child(daysToDeleteUserFrom[index]).child((Auth.auth().currentUser?.uid)!).removeValue()
            }
            
            //add user id to chosen available days
            //key is the day of the week, value = 1
            for (key, value) in daysOpenMap{
                
                Database.database().reference().child("availableDay-users").child(key).updateChildValues([(Auth.auth().currentUser?.uid)! : 1])
            }
            
            var skillsMap = [String: Int]()
            for index in addedTagsCollection.tags.indices{
                skillsMap[addedTagsCollection.tags[index]] = 1
            }
            if skillsMap.count > 0{
                Database.database().reference().child("users").child((Auth.auth().currentUser?.uid)!).child("skills").updateChildValues(skillsMap)
                
                //key is the skill/tag
                for (key, value) in skillsMap{
                    
                    Database.database().reference().child("skill-users").child(key).updateChildValues([(Auth.auth().currentUser?.uid)! : 1])
                }
            }
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
