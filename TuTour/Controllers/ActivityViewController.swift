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
	var meetingRequestsDictionary = [String: MeetingRequest]()
	
	var meetingRequestCell = "meetingRequestCell"
	
    override func viewDidLoad() {
		
        super.viewDidLoad()
	
        // Do any additional setup after loading the view.
		
		tableView.dataSource = self
		
		tableView.register(MeetingRequestCell.self, forCellReuseIdentifier: meetingRequestCell)
		
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
					print(meetingRequest.date?.description)
					
					
					
					
					if let tutorId = meetingRequest.meetingPartnerId(){
						self.meetingRequestsDictionary[tutorId] = meetingRequest
						self.meetingRequests = Array(self.meetingRequestsDictionary.values)
						self.meetingRequests.sort(by: { (m1, m2) -> Bool in
							return (m1.date! > m2.date!)
						})
						
						
					}
					
					self.timer?.invalidate()
					self.timer = Timer.scheduledTimer(timeInterval: 0.1, target: self, selector: #selector(self.handleReloadTable), userInfo: nil, repeats: false)
				}
			})
			
		}
	}
	
	var timer: Timer?
	@objc func handleReloadTable(){
		DispatchQueue.main.async {
			print("RELOAD")
			self.tableView.reloadData()
		}
	}
    
	//row selected
	override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
		
		//present display that shows detail of meeting and give the tutor options
		
	}
	
//	//text in cell
	override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
		
		let cell = tableView.dequeueReusableCell(withIdentifier: meetingRequestCell) as! MeetingRequestCell
		
		
		let meetingRequest = meetingRequests[indexPath.row]
		
	
		
		cell.meetingRequest = meetingRequest
		
		return cell
		
	}
	
	//number of rows
	override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
		print("HERE \(self.meetingRequestsDictionary.count)")
		return self.meetingRequestsDictionary.count
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
