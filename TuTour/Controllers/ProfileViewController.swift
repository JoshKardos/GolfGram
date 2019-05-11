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
import TaggerKit
class ProfileViewController: UIViewController {
    
    
    @IBOutlet weak var logoutButton: UIBarButtonItem!
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
    @IBOutlet weak var containerView: UIView!
    @IBOutlet weak var monLabel: UILabel!
    @IBOutlet weak var tueLabel: UILabel!
    @IBOutlet weak var wedLabel: UILabel!
    @IBOutlet weak var thuLabel: UILabel!
    @IBOutlet weak var friLabel: UILabel!
    @IBOutlet weak var satLabel: UILabel!
    @IBOutlet weak var sunLabel: UILabel!
    @IBOutlet var stackView: UIStackView!
    @IBOutlet weak var scrollView: UIScrollView!
    
    var tagCollection = TKCollectionView()
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
            selectMeetingOptions(meeting: meeting!)
            print("ELSE")
            
        }
    }
    
    func selectMeetingOptions(meeting: MeetingRequest){
        
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
            
            if let skillsMap = (snapshot.value as! NSDictionary)["skills"] as? [String: AnyObject] {
                for (skill, _) in skillsMap {
                    self.tagCollection.tags.append(skill)
                }
            } else {
                self.tagCollection.tags.append("No Skills")
            }
            

            print("HI2")
//            print(self.tagCollection.tags)
            
            self.add(self.tagCollection, toView: self.containerView)
            if let availDays = (snapshot.value as! NSDictionary)["availableDays"] as? [String: AnyObject] {
                for (days, _) in availDays {
                    print(days)
                    
                    if days == "Monday" {
                        self.setUILabelColor(label: self.monLabel)
                    }
                    else if days == "Tuesday" {
                        self.setUILabelColor(label: self.tueLabel)
                    }
                    else if days == "Wednesday" {
                        self.setUILabelColor(label: self.wedLabel)
                    }
                    else if days == "Thursday" {
                        self.setUILabelColor(label: self.thuLabel)
                    }
                    else if days == "Friday" {
                        self.setUILabelColor(label: self.friLabel)
                    }
                    else if days == "Saturday" {
                        self.setUILabelColor(label: self.satLabel)
                    }
                    else if days == "Sunday" {
                        self.setUILabelColor(label: self.sunLabel)
                    }
                }
            }
            

            
            //let descString = (snapshot.value as! NSDictionary)["description"] as! String
            //self.descriptionLabel.text = descString
            
            ProgressHUD.dismiss()
        })
        
    }
    
    func setDayLabelStyle(label: UILabel) {
        label.layer.borderColor = UIColor.black.cgColor
        label.layer.borderWidth = 0.5
    }
    
    func setUILabelColor(label: UILabel) {
        label.backgroundColor = UIColor(red: 211.0/255, green: 211.0/255, blue: 211.0/255, alpha: 1.0)
    }
    
    func roundButtons(button: UIButton) {
        button.layer.cornerRadius = 5
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
        super.loadView()
        super.viewDidLoad()
        
        
        availAndSkillsButton.backgroundColor = AppDelegate.theme_Color
        updateButton.backgroundColor = AppDelegate.theme_Color
        registerAsTutorButton.backgroundColor = AppDelegate.theme_Color
        
        ProgressHUD.show("Loading...")
        dmButton?.tintColor = AppDelegate.theme_Color
        
        
        profileImage.layer.borderWidth = 1
        profileImage.layer.masksToBounds = true
        profileImage.layer.borderColor = UIColor.white.cgColor
        profileImage.layer.cornerRadius = profileImage.frame.size.height / 2
        profileImage.clipsToBounds = true
        
        setDayLabelStyle(label: monLabel)
        setDayLabelStyle(label: tueLabel)
        setDayLabelStyle(label: wedLabel)
        setDayLabelStyle(label: thuLabel)
        setDayLabelStyle(label: friLabel)
        setDayLabelStyle(label: satLabel)
        setDayLabelStyle(label: sunLabel)
        
        roundButtons(button: registerAsTutorButton)
        roundButtons(button: updateButton)
        roundButtons(button: availAndSkillsButton)
        
        self.scrollView.addSubview(stackView)
        self.stackView.translatesAutoresizingMaskIntoConstraints = false
        
        self.stackView.leadingAnchor.constraint(equalTo: self.scrollView.leadingAnchor).isActive = true
        self.stackView.trailingAnchor.constraint(equalTo: self.scrollView.trailingAnchor).isActive = true
        self.stackView.topAnchor.constraint(equalTo: self.scrollView.topAnchor).isActive = true
        self.stackView.bottomAnchor.constraint(equalTo: self.scrollView.bottomAnchor).isActive = true
        
        self.stackView.widthAnchor.constraint(equalTo: self.view.widthAnchor).isActive = true
        
        logoutButton.tintColor = AppDelegate.theme_Color
        
    }
    
    
    @IBAction func logoutPressed(_ sender: Any) {
        let alert = UIAlertController(title: "Confirm", message: "Are you sure you want to logout?", preferredStyle: .alert)
        
        alert.addAction(UIAlertAction(title: NSLocalizedString("Yes", comment: "Default action"), style: .default, handler: { _ in
            self.logout()}))
        alert.addAction(UIAlertAction(title: NSLocalizedString("No", comment: "Default action"), style: .default, handler: { _ in
            alert.remove()}))
        
        self.present(alert, animated: true, completion: nil)
        logout()
    }
    func logout(){
        
        
        
        
        
        
        do {
            try Auth.auth().signOut()
            
            let storyboard = UIStoryboard(name: "Start", bundle: nil)
            
            let signInVC = storyboard.instantiateViewController(withIdentifier: "SignInViewController")
            
            present(signInVC, animated: true, completion: nil)
            
        } catch let logoutError{
            
            print(logoutError)
            
        }
    }
}
