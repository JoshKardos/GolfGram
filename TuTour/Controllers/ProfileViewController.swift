//
//  ProfileViewController.swift
//  TuTour
//
//  Created by Josh Kardos on 9/25/18.
//  Copyright © 2018 JoshTaylorKardos. All rights reserved.
//
import UIKit
import FirebaseAuth
import FirebaseDatabase
import ProgressHUD
class ProfileViewController: UIViewController {
    
    @IBOutlet weak var emailTextbox: UITextField!
    @IBOutlet weak var profileImage: UIImageView!
    @IBOutlet weak var fullnameLabel: UILabel!
    @IBOutlet weak var usernameLabel: UILabel!
    @IBOutlet weak var schoolLabel: UILabel!
    @IBOutlet weak var majorLabel: UILabel!
    @IBOutlet weak var yearLabel: UILabel!
    @IBOutlet weak var emailLabel: UILabel!
    @IBOutlet weak var ratingLabel: UILabel!
    @IBOutlet weak var descriptionLabel: UILabel!
    @IBOutlet weak var updateButton: UIButton!
    @IBOutlet weak var dmButton: UIBarButtonItem!
    @IBOutlet weak var registerAsTutorButton: UIButton!
    @IBOutlet weak var availAndSkillsButton: UIButton!
    
    
    var isOtherUser = false//must change to false if vc is pushed programatically!!
    
    var uid: String?
    
    var meeting: MeetingRequest?
    
    @IBAction func updateButton(_ sender: Any) {
        // Go to Profile Settings
        let storyboard: UIStoryboard = UIStoryboard(name: "Profile", bundle: nil)
        let profileSettingsVC = storyboard.instantiateViewController(withIdentifier: "Settings") as! ProfileSettingsController
        navigationController?.pushViewController(profileSettingsVC, animated: true)
    }
    
    @IBAction func daysAndSKillsPressed(_ sender: Any) {
    
            //view add days and skills vc
            let storyboard: UIStoryboard = UIStoryboard(name: "Start", bundle: nil)
            let view = storyboard.instantiateViewController(withIdentifier: "addSkills_addDaysView") as! SelectAvailableDaysViewController
        //    meeting?.setDate(date: date)
        //    locationPicker.meeting = meeting!
            navigationController?.pushViewController(view, animated: true)
    
    
    }
    @IBAction func tutorButton(_ sender: Any) {
        
        if isOtherUser == false{//is current users profile
            
            let storyboard: UIStoryboard = UIStoryboard(name: "Profile", bundle: nil)
            let subjectsVC = storyboard.instantiateViewController(withIdentifier: "Subjects") as! SubjectsViewController
            
            navigationController?.pushViewController(subjectsVC, animated: true)
            print("HERE" )
            
        } else{//is other users profile
            selectMeetingOptions()
            print("ELSE")
            
        }
    }
    
    func selectMeetingOptions(){
        
        let storyboard: UIStoryboard = UIStoryboard(name: "Profile", bundle: nil)
        let timeOptionsVC = storyboard.instantiateViewController(withIdentifier: "TimeOptions") as! DatePickerViewController
        
        timeOptionsVC.meeting = meeting
        navigationController?.pushViewController(timeOptionsVC, animated: true)
        
        
    }
    
    func disableComponents(){
        dmButton.isEnabled = false
        dmButton.image = nil
        dmButton.title = nil
    }
    
    func fillUserInfo(uid: String){
        
        
        Database.database().reference().child("users").child(uid).observeSingleEvent(of: .value, with: {(snapshot) in
            
            
            
            let username = (snapshot.value as! NSDictionary)["username"] as! String
            self.usernameLabel?.text = username
            
            
            let profileImageString = (snapshot.value as! NSDictionary)["profileImageUrl"] as! String
            let url = URL(string: profileImageString)
            let imageData = NSData.init(contentsOf: url as! URL)
            self.profileImage?.image = UIImage(data: imageData as! Data)
            
            let fullnameString = (snapshot.value as! NSDictionary)["fullname"] as! String
            self.fullnameLabel?.text = fullnameString
            
            let emailString = (snapshot.value as! NSDictionary)["email"] as! String
            self.emailLabel?.text = emailString
            
            let schoolString = (snapshot.value as! NSDictionary)["school"] as! String
            self.schoolLabel?.text = schoolString
            
            let majorString = (snapshot.value as! NSDictionary)["major"] as! String
            self.majorLabel?.text = majorString
            
            let yearString = (snapshot.value as! NSDictionary)["year"] as! String
            self.yearLabel.text = yearString
            
            //let descString = (snapshot.value as! NSDictionary)["description"] as! String
            //self.descriptionLabel.text = descString
            
            ProgressHUD.dismiss()
        })
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        if let otherUser_ID = self.uid {//other users pprofile
            
            self.isOtherUser = true
            fillUserInfo(uid: otherUser_ID)
            updateButton.isHidden = true
            availAndSkillsButton.isHidden = true
            registerAsTutorButton.backgroundColor = UIColor(red: 70.0/255.0, green: 163.0/255.0, blue: 181.0/255.0, alpha: 1.0)
            registerAsTutorButton.setTitleColor(#colorLiteral(red: 1, green: 1, blue: 1, alpha: 1), for: .normal)
            registerAsTutorButton.setTitle("Tutor Request", for: .normal)
            
        } else {//current users profile
            print(Auth.auth().currentUser?.uid)
            guard let userID = Auth.auth().currentUser?.uid else { fatalError() }
            fillUserInfo(uid: userID)
            isOtherUser = false
            registerAsTutorButton.reloadInputViews()
            availAndSkillsButton.isHidden = false
            updateButton.isHidden = false
            
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        super.loadView()
        ProgressHUD.show("Loading...")
        dmButton?.tintColor = AppDelegate.theme_Color
        
    }
}
