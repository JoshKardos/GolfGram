//
//  MeetingRequestViewController.swift
//  TuTour
//
//  Created by Josh Kardos on 1/31/19.
//  Copyright © 2019 JoshTaylorKardos. All rights reserved.
//

import Foundation
import UIKit
import FirebaseDatabase
import FirebaseAuth
import ProgressHUD
import EventKit
import UserNotifications

class MeetingRequestViewController: UIViewController{
	
	@IBOutlet weak var titleLabel: UILabel!
	
    @IBOutlet weak var acceptButton: UIButton!
    @IBOutlet weak var denyButton: UIButton!
	@IBOutlet var meetingRequestLabels: [UILabel]!
	//Subject
	//Student username
	//Building
	//Day
	//Time
	var labelsText = [String?]()//for eventkit
	var user: User?
	var meetingRequest: MeetingRequest?
    override func viewDidLoad() {
        super.viewDidLoad()
        
        fillMeetingRequestLabels()
        //if last senderToSendId = nil then it is a shceduled meeting
        if meetingRequest?.lastUserToSendId == nil || (meetingRequest?.lastUserToSendId)! == (Auth.auth().currentUser?.uid)!{
            denyButton.isEnabled = false
            acceptButton.isEnabled = false
            denyButton.isHidden = true
            acceptButton.isHidden = true
        }
        
    }
	@IBAction func denyPressed(_ sender: UIButton) {
        
        //ask to edit or kindly decline meeting
        let alert = UIAlertController(title: "Confirm", message: "Would you like to edit this request or deny and end talks?", preferredStyle: .alert)
        
        alert.addAction(UIAlertAction(title: NSLocalizedString("Edit", comment: "Default action"), style: .default, handler: { _ in
            self.editMeetingRequest()}))
        alert.addAction(UIAlertAction(title: NSLocalizedString("Deny", comment: "Default action"), style: .default, handler: { _ in
            self.deleteMeetingRequest()}))
        
        self.present(alert, animated: true, completion: nil)
        
        
	}
    
    func editMeetingRequest(){
        //present edit meeting request view
        
    }
    func deleteMeetingRequest(){
        
        let alert = UIAlertController(title: "Are you sure?", message: "Confirm to deny this meeting?", preferredStyle: .alert)
        
        alert.addAction(UIAlertAction(title: NSLocalizedString("Yes", comment: "Default action"), style: .default, handler: { _ in
            //delete all nodes
           print("HER")
            Database.database().reference().child("MeetingRequests").child((self.meetingRequest?.meetingId)!).removeValue()
            Database.database().reference().child("user-meetingRequests").child((Auth.auth().currentUser?.uid)!).child((self.meetingRequest?.meetingId)!).removeValue()
            Database.database().reference().child("user-meetingRequests").child((self.meetingRequest?.meetingPartnerId())!).child((self.meetingRequest?.meetingId)!).removeValue()
            self.navigationController?.popToRootViewController(animated: true)
        }))
        alert.addAction(UIAlertAction(title: NSLocalizedString("No", comment: "Default action"), style: .default, handler: { _ in
            NSLog("The \"OK\" alert occured.")
            self.navigationController?.popToRootViewController(animated: true)
            
        }))
        
        self.present(alert, animated: true, completion: nil)
        
        
        
        
        //pop to root view controller
        
    }
	@IBAction func acceptPressed(_ sender: UIButton) {
        
        //Add to users' array of scheduled meetings
        //store id
        print(meetingRequest!.meetingId)
        let alert = UIAlertController(title: "Confirm", message: "Would you like to confirm to plan this meeting?", preferredStyle: .alert)
        
        alert.addAction(UIAlertAction(title: NSLocalizedString("Yes", comment: "Default action"), style: .default, handler: { _ in
            self.acceptMeeting()}))
        alert.addAction(UIAlertAction(title: NSLocalizedString("No", comment: "Default action"), style: .default, handler: { _ in
            NSLog("The \"OK\" alert occured.")}))
        
        self.present(alert, animated: true, completion: nil)
        //delete meeting requests
        
        
	}
    func acceptMeeting(){
        
        let uid = (Auth.auth().currentUser?.uid)!
        let otherUid = (meetingRequest?.meetingPartnerId())!
        
        //add to scheduledMeeting nodes
        
        Database.database().reference().child("ScheduledMeetings").child((meetingRequest?.meetingId!)!).setValue(["date": meetingRequest?.date!.timeIntervalSince1970, "location": meetingRequest?.location!, "tutorUid": meetingRequest?.tutorUid, "tutoreeUid": meetingRequest?.tutoreeUid, "subject": meetingRequest?.subject!, "meetingId": meetingRequest?.meetingId!]){ (error, ref) in
            if error != nil {
                ProgressHUD.showError(error!.localizedDescription)
                return
            }
        
            //use eventKit to save to user's phone
            
            let eventStore = EKEventStore()
            eventStore.requestAccess(to: .event, completion: { (granted, error) in
                if (granted) && (error == nil) {
                    let event = EKEvent(eventStore: eventStore)
                    print("GRANTDE")
                    event.title = "Scheduled Meeting via TuTour\n Location: \((self.meetingRequest?.location)!)"
                    let timeInterval = self.meetingRequest?.date?.timeIntervalSince1970
                    event.startDate = Date(timeIntervalSince1970: timeInterval!)
                    event.endDate = Date(timeIntervalSince1970: timeInterval!)
                    let notes = "Subject: \(self.labelsText[0]!) \n Student: \(self.labelsText[1]!) \n Building: \(self.labelsText[2]!) \n Day: \(self.labelsText[3]!) \n Time: \(self.labelsText[4]!) \n"
                    event.notes = notes
                    event.calendar = eventStore.defaultCalendarForNewEvents
                    //set reminders
                    
                    do {
                        print("SAVING EVENT")
                        try eventStore.save(event, span: .thisEvent)
                        //push notification that meeting was added to your calendar
                        let content = UNMutableNotificationContent()
                        content.title = "Meeting saved in your calendar"
                        content.subtitle = event.title
                        content.badge = 1
                        let trigger = UNTimeIntervalNotificationTrigger(timeInterval: 5, repeats: false)
                        let request = UNNotificationRequest(identifier: "meetingAdded", content: content, trigger: trigger)
                        UNUserNotificationCenter.current().add(request, withCompletionHandler: nil)
                        
                        //send notificiation to other user
                        
                    } catch let error as NSError {
                        print("ERROR : \(error)")

                    }
                    
                } else {
                    print("ERROR : \(error)")
                }
                
            })
        }
        
        //add to user-shceduledMeeting nodes
        Database.database().reference().child("users-scheduledMeetings/\(uid)").child((meetingRequest?.meetingId!)!).setValue(1)
        Database.database().reference().child("users-scheduledMeetings/\(otherUid)").child((meetingRequest?.meetingId!)!).setValue(1)
        
        //delete from MeetingRequests
        Database.database().reference().child("MeetingRequests").child((meetingRequest?.meetingId!)!).removeValue()
        
        //delete from user-meetingrequests
        
        Database.database().reference().child("user-meetingRequests").child(uid).child((meetingRequest?.meetingId)!).removeValue()
        Database.database().reference().child("user-meetingRequests").child(otherUid).child((meetingRequest?.meetingId)!).removeValue()
        
        navigationController?.popToRootViewController(animated: true)
        
        
    }
	func setUser(user: User){
		self.user = user
	}
	func setMeetingRequest(meetingRequest: MeetingRequest){
		self.meetingRequest = meetingRequest
	}
	
	
	
	//look under meetingRequestLabels declaration to get order of labels
	func fillMeetingRequestLabels(){
		
	
		
		//subject
		meetingRequestLabels[0].text = meetingRequest!.subject
		labelsText.append(meetingRequest!.subject)
        
        Database.database().reference().child("users").child((meetingRequest?.tutorUid!)!).observe(.value) { (snapshot) in
            let user = snapshot.value as! [String: AnyObject]
            print("HERE \(user["username"])")
            
            //username
            self.meetingRequestLabels[1].text = user["username"] as! String
            self.labelsText.append(user["username"] as? String)
        }
		
		
		//building
		meetingRequestLabels[2].text = meetingRequest!.location
		labelsText.append(meetingRequest!.location)
		//day
		let dateFormatter = DateFormatter()
		dateFormatter.dateFormat = "MM-dd-yyyy"
		meetingRequestLabels[3].text = dateFormatter.string(from: meetingRequest!.date!)
		//https://medium.com/@tjcarney89/using-dateformatter-to-format-dates-and-times-from-apis-57622ce11d04
        labelsText.append(dateFormatter.string(from: meetingRequest!.date!))
		
		//time
		let dateFormatter2 = DateFormatter()
		dateFormatter2.dateFormat = "h:mm a"
		meetingRequestLabels[4].text = dateFormatter2.string(from: meetingRequest!.date!)
		labelsText.append(dateFormatter2.string(from: meetingRequest!.date!))
		
		
	}
	
	
}
