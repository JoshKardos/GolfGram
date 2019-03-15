//
//  addedTagsLabelViewInSignUp.swift
//  TuTour
//
//  Created by Josh Kardos on 2/26/19.
//  Copyright © 2019 JoshTaylorKardos. All rights reserved.
//

import Foundation
import UIKit

class AddedTagsLabelViewInSignUp: UIView{
    var signUpViewController: SelectAvailableDaysViewController?
    @IBOutlet weak var label: UILabel!
     @
    
    IBAction func deletePressed(_ sender: UIButton) {
        
        
        
        self.isHidden = true
        if let signupVC = signUpViewController{
            signupVC.tagsArray.remove(at: signupVC.tagsArray.firstIndex(of: label.text!)!)
            
            label.text = nil
            
            signupVC.updateTagsFromArray()
        }
        
    }


}
