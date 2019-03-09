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
    
    var usersWithSameFreeDays = [String: Int]()
    var usersWithSameSkills = [String: Int]()
    var suggestedUsers = [String]()
    @IBOutlet weak var tableView: UITableView!
    override func viewDidLoad() {
        super.viewDidLoad()
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
    func fetchThreeSuggestedUsers()->[NSDictionary]{
        
        
        return [NSDictionary]()
    }
    func combineAndSortSuggestedUsers(){
        var topSimilarUsersMap = [Int: [String]]()
        
        for (similarUserByDay, frequencyOfSameDays) in usersWithSameFreeDays{
            for(similarUserBySkill,  frequencyOfSameSkills) in usersWithSameSkills{
                
                if(similarUserByDay == similarUserBySkill){
                    
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
            let dictionary = snapshot.value as! [String: Any]
            
            for (skill, _) in dictionary{
                
                
                Database.database().reference().child("skill-users").child(skill).observe(.value) { (snapshot) in
                    
                    let dictionary = snapshot.value as! [String: Any]
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
                        print(self.usersWithSameFreeDays)
                        print(self.usersWithSameSkills)
                        self.combineAndSortSuggestedUsers()
                        
                    }
                }
                
            }
            
            
        }//end of query
        
    }
    
    func compareByDays(){//->[NSDictionary: Int]{
        print("COMP")
        Database.database().reference().child("users").child((Auth.auth().currentUser?.uid)!).child("availableDays").observe(.value) { (snapshot) in
            let daysDictionary = snapshot.value as! [String: Any]
            
            var i = 0
            for (day, _) in daysDictionary{
                i += 1
                Database.database().reference().child("availableDay-users").child(day).observe(.value) { (snapshot) in
                    let dictionary = snapshot.value as! [String: Any]
                    
                    for (key, _) in dictionary{
                        
                        if key != (Auth.auth().currentUser?.uid)!{//not current user
                            
                            //if not added
                            if self.usersWithSameFreeDays[key] == nil{
                                self.usersWithSameFreeDays[key] = 1
                            } else {
                                self.usersWithSameFreeDays[key] = self.usersWithSameFreeDays[key]!+1
                            }
                        }
                    }
                    
                    
                    
                    DispatchQueue.main.async {
                        print("\(i) \(daysDictionary.count)")
                        //only call when day count has ended
                        if i == daysDictionary.count{
                        print("HERE")
                        self.compareBySkills()
                        
                        }
                        
                    }
                }
                
                
            }
            
        }//end of query
        
    }
    func updateCell(_ cell: SuggestedUserCell){
        
        cell.daysFreeLabel.text = "Days Free: \n"
        cell.skillsLabel.text = "nothing"
        
        
    }
    
}
