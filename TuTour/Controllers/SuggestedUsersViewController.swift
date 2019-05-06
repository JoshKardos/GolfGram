//
//  SuggestedUsersViewController.swift
//  TuTour
//
//  Created by Josh Kardos on 3/8/19.
//  Copyright © 2019 JoshTaylorKardos. All rights reserved.
//

import Foundation
import UIKit
import FirebaseDatabase
import FirebaseStorage
import FirebaseAuth
class SuggestedUsersViewController: UIViewController, UITableViewDataSource{
    
    @IBOutlet weak var lookForATutor: UIButton!
    var usersWithSameFreeDays = [String: Int]()
    var usersWithSameSkills = [String: Int]()
    var suggestedUsers = [String]()
    @IBOutlet weak var tableView: UITableView!
    
    @IBOutlet weak var blurredView: UIView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        lookForATutor.backgroundColor = AppDelegate.theme_Color
        
        let blurEffect = UIBlurEffect(style: UIBlurEffect.Style.dark)
        let blurEffectView = UIVisualEffectView(effect: blurEffect)
        blurEffectView.frame = blurredView.bounds
        blurEffectView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
       blurredView.addSubview(blurEffectView)
        
        
        
        let title = UILabel()
        title.text = "Suggested Users Coming Soon..."
        title.numberOfLines = 0
        
        title.textAlignment = .center
        title.sizeToFit()
//        title.backgroundColor = UIColor.redColor()
        title.center = blurredView.center
        
        title.backgroundColor = #colorLiteral(red: 0.501960814, green: 0.501960814, blue: 0.501960814, alpha: 1)
        title.layer.cornerRadius = 16
        title.textColor = #colorLiteral(red: 1.0, green: 1.0, blue: 1.0, alpha: 1.0)
//        title.widthAnchor.constraint(equalTo: view.widthAnchor).isActive = true
        
        blurredView.addSubview(title)
        title.centerXAnchor.constraint(equalTo: blurEffectView.centerXAnchor).isActive = true
        title.centerYAnchor.constraint(equalTo: blurEffectView.centerYAnchor).isActive = true
        
        tableView.dataSource = self
        self.compareByDays()
    }
    
    
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 3
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "SuggestedUserCell", for: indexPath) as! SuggestedUserCell
        
        let users = fetchThreeSuggestedUsers()
        
        updateCell(cell)
        
        
        
        return cell
    }
    func updateCell(_ cell: SuggestedUserCell){
        
        cell.daysFreeLabel.text = "Days Free: \n"
        cell.skillsLabel.text = "nothing"
        
        
    }
    func fetchThreeSuggestedUsers()->[NSDictionary]{
        
        var users = [NSDictionary]()
        
        //compare by available days
        return [NSDictionary]()
    }
    
    func combineAndSortSuggestedUsers(){
        var topSimilarUsersMap = [Int: [String]]()
        
        for (similarUserByDay, frequencyOfSameDays) in usersWithSameFreeDays{
            for(similarUserBySkill,  frequencyOfSameSkills) in usersWithSameSkills{
                
                if similarUserByDay == similarUserBySkill {
                    
                    if topSimilarUsersMap[frequencyOfSameDays+frequencyOfSameSkills] == nil{
                        
                        topSimilarUsersMap[frequencyOfSameDays+frequencyOfSameSkills] = [similarUserBySkill]
                        
                    } else {
                        topSimilarUsersMap[frequencyOfSameDays+frequencyOfSameSkills]?.append(similarUserBySkill)
                    }
                }
            }
        }
    }
    //gets called after free days
    func compareBySkills(){
        //skill-users
        //skills
        //gather current users available days
        
        Database.database().reference().child("users").child((Auth.auth().currentUser?.uid)!).child("skills").observe(.value) { (snapshot) in
            
            print("CALL")
            if let dictionary = snapshot.value as? [String: Any] {
                
                for (skill, _) in dictionary{
                    
                    
                    Database.database().reference().child("skill-users").child(skill).observe(.value) { (snapshot) in
                        
                        if let dictionary = snapshot.value as? [String: Any]{
                            for (key, _) in dictionary{
                                
                                if key != (Auth.auth().currentUser?.uid)!{//not current user
                                    
                                    //if not added
                                    if self.usersWithSameSkills[key] == nil{
                                        
                                        self.usersWithSameSkills[key] = 1
                                        
                                    } else {
                                        
                                        self.usersWithSameSkills[key] = self.usersWithSameSkills[key]!+1
                                        
                                    }
                                }
                                
                            }
                            DispatchQueue.main.async {
                                
                                print("IN THIS THREAD")
                                print(self.usersWithSameFreeDays)
                                print(self.usersWithSameSkills)
                                self.combineAndSortSuggestedUsers()
                                
                            }
                        }
                    }
                    
                }
            }
            
        }//end of query
        
    }
    func compareByDays(){//->[NSDictionary: Int]{
        print("COMP")
        Database.database().reference().child("users").child((Auth.auth().currentUser?.uid)!).child("availableDays").observe(.value) { (snapshot) in
            if let daysDictionary = snapshot.value as? [String: Any] {
                print(daysDictionary)
                for (day, _) in daysDictionary{
                    
                    Database.database().reference().child("availableDay-users").child(day).observe(.value) { (snapshot) in
                        if let dictionary = snapshot.value as? [String: Any]{
                        print(dictionary)
                        for (key, _) in dictionary{
                            
                            if key != (Auth.auth().currentUser?.uid)!{//not current user
                                print(key)
                                //if not added
                                if self.usersWithSameFreeDays[key] == nil{
                                    self.usersWithSameFreeDays[key] = 1
                                } else {
                                    self.usersWithSameFreeDays[key] = self.usersWithSameFreeDays[key]!+1
                                }
                            }
                        }
                    }
                        
                        
                        DispatchQueue.main.async {
                            
                            print(self.usersWithSameFreeDays)
                            self.compareBySkills()
                        }
                    }
                    
                    
                }
            }
        }//end of query
        
    }
    
}
