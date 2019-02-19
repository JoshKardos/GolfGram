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
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    
    @IBAction func addDays(_ sender: UIButton) {
        
        var daysOpen = [String]()
        
        for i in 0..<daySwitches.count{
            
            if daySwitches[i].isOn == true{
                
                daysOpen.append(dayLabels[i].text!)
            }
        }
        
        Database.database().reference().child("users").child((Auth.auth().currentUser?.uid)!).child("availableDays").setValue(daysOpen)
        
    }
    
    @IBAction func addLater(_ sender: UIButton) {
        
        print("Doing Later")
        
    }
    
    
}
