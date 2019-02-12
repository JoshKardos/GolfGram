//
//  ScheduledMeetingsViewController.swift
//  TuTour
//
//  Created by Josh Kardos on 2/6/19.
//  Copyright © 2019 JoshTaylorKardos. All rights reserved.
//

import Foundation
import FirebaseDatabase
import FirebaseAuth
import UIKit
class ScheduledMeetingsTableViewController: UITableViewController{
    var scheduledMeetings = [ScheduledMeeting]()
    var scheduledMeetingUsers = [User]()//meeting partners
    var ref = Database.database().reference()
    
    var rowIndexSelected: IndexPath?
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
        loadUserMeetingRequests()
        print("SCHEDULED MEETINGS")
        
    }
    
    //TODO: LOAD USER SCHEDULEDMEETINGS
    func loadUserMeetingRequests(){
        guard let uid = Auth.auth().currentUser?.uid else{
            return
        }
        
        print("HERE")
        let currentUserRef = Database.database().reference().child("users-scheduledMeetings").child(uid)
        currentUserRef.observe(.childAdded) { (snapshot) in
            
            print("SNAP __ \(snapshot)")
            
            var meetingRequestId = snapshot.key
            let meetingRequestRef = Database.database().reference().child("ScheduledMeetings").child(meetingRequestId)
            meetingRequestRef.observeSingleEvent(of: .value, with: { (snapshot) in
                
                if let dictionary = snapshot.value as? [String: Any]{
                    let scheduledMeeeting = ScheduledMeeting(tutor: dictionary["tutorUid"] as! String, tutoree: dictionary["tutoreeUid"] as! String, subject: dictionary["subject"] as! String, meetingId: dictionary["meetingId"] as! String)
                    scheduledMeeeting.setDate(date: Date(timeIntervalSince1970: dictionary["date"] as! TimeInterval))
                    scheduledMeeeting.setLocation(location: dictionary["location"] as! String)
                    if let otherUserId = scheduledMeeeting.meetingPartnerId(){
                        
                        Database.database().reference().child("users").child(otherUserId).observe(.value) { (snapshot) in
                            let user = snapshot.value as? [String: Any]
                            let newUser = User(emailString: user!["email"] as! String, profileImageUrlString: user!["profileImageUrl"] as! String, uidString: user!["uid"] as! String, usernameString: user!["username"] as! String)
                            
                            self.scheduledMeetingUsers.append(newUser)
                            self.scheduledMeetings.append(scheduledMeeeting)
                        }
                    }
                    self.timer?.invalidate()
                    self.timer = Timer.scheduledTimer(timeInterval: 0.1, target: self, selector: #selector(self.handleReloadTable), userInfo: nil, repeats: false)
                }
            })
        }
        //        // Listen for deleted meetings in the Firebase database
        currentUserRef.observe(.childRemoved, with: { (snapshot) -> Void in
            self.scheduledMeetingUsers.remove(at: self.rowIndexSelected!.row)
            self.scheduledMeetings.remove(at: self.rowIndexSelected!.row)
            self.tableView.deleteRows(at: [self.rowIndexSelected!], with: UITableView.RowAnimation.automatic)
        })
    }
    var timer: Timer?
    @objc func handleReloadTable(){
        DispatchQueue.main.async {
            self.tableView.reloadData()
        }
    }
    
    //MARK: Collection View
    
    //TODO: row selected
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
//        //present display that shows detail of meeting and give the tutor options
//
//        let storyboard: UIStoryboard = UIStoryboard(name: "Activity", bundle: nil)
//        let meetingRequestVC = storyboard.instantiateViewController(withIdentifier: "MeetingRequestVC") as! MeetingRequestViewController
//
//        meetingRequestVC.setUser(user: meetingRequestsUsers[indexPath.row])
//        meetingRequestVC.setMeetingRequest(meetingRequest: meetingRequests[indexPath.row])
//        rowIndexSelected = indexPath
//        navigationController?.pushViewController(meetingRequestVC, animated: true)
    }
    
    //    //text in cell
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "meetingRequestCell") as! MeetingRequestCell
        let otherUser = scheduledMeetingUsers[indexPath.row]
        let meetingRequest = scheduledMeetings[indexPath.row]
        cell.otherUser = otherUser
        cell.meetingRequest = meetingRequest
        Database.database().reference().child("users").child(meetingRequest.meetingPartnerId()!).observeSingleEvent(of: .value, with: {(snapshot) in
            
            let url = URL(string: ((snapshot.value as! NSDictionary)["profileImageUrl"] as? String)!)//NSURL.init(fileURLWithPath: posts[indexPath.row].photoUrl)
            let imageData = NSData.init(contentsOf: url as! URL)
            cell.profileImageView.image = UIImage(data: imageData as! Data)
            ///////////////////////
        })
        return cell
    }
    
    //number of rows
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.scheduledMeetings.count
    }
}
