//
//  ActivityViewController.swift
//  GolfGram
//
//  Created by Josh Kardos on 9/25/18.
//  Copyright © 2018 JoshTaylorKardos. All rights reserved.
//

import UIKit
import FirebaseAuth
import FirebaseDatabase

class ActivityViewController: UITableViewController {

	var tutorsClasses: Bool?
	var meetingRequests = [MeetingRequest]()
	
	
    override func viewDidLoad() {
		
        super.viewDidLoad()
	
        // Do any additional setup after loading the view.
		
		tableView.dataSource = self
		
		loadUserMeetingRequests()
    }
	
	func loadUserMeetingRequests(){
		guard let uid = Auth.auth().currentUser?.uid else{
			return
		}
		
		let currentUserRef = Database.database().reference().child("user-meetingRequests").child(uid)
		
		currentUserRef.observe(.childAdded) { (snapshot) in
			
			print(snapshot.key)
			let meetingRequestId = snapshot.key
			let meetingRequestRef = Database.database().reference().child("MeetingRequests").child(meetingRequestId)
			
			meetingRequestRef.observe(.value, with: { (snapshot) in
	
				if let dictionary = snapshot.value as? [String: Any]{
					print(dictionary)
					
					let meetingRequest = MeetingRequest(tutor: dictionary["tutorUid"] as! String, tutoree: dictionary["tutoreeUid"] as! String, subject: dictionary["subject"] as! String)
					
					meetingRequest.setDate(date: Date(timeIntervalSince1970: dictionary["date"] as! TimeInterval))
					meetingRequest.setLocation(location: dictionary["location"] as! String)
				}
			})
			
		}
	}
    
	//row selected
	override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
		
		//present display that shows detail of meeting and give the tutor options
		
	}
	
//	//text in cell
//	override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
//		
//	}
	
	//number of rows
	override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
		return 0
	}
	
	
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
