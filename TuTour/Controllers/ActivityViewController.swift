//
//  ActivityViewController.swift
//  TuTour
//
//  Created by Josh Kardos on 9/25/18.
//  Copyright © 2018 JoshTaylorKardos. All rights reserved.
//

import UIKit
import FirebaseAuth
import FirebaseDatabase
import ProgressHUD

class ActivityViewController: UITableViewController {

	var tutorsClasses: Bool?
	var meetingRequests = [MeetingRequest]()
	var meetingRequestsUsers = [User]()//meeting partners
	var ref = Database.database().reference()

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
			
		
			let meetingRequestId = snapshot.key
			let meetingRequestRef = Database.database().reference().child("MeetingRequests").child(meetingRequestId)
			
			meetingRequestRef.observe(.value, with: { (snapshot) in
				
				if let dictionary = snapshot.value as? [String: Any]{
					
				
                    
                    
// MARK: - Meeting Request created
					let meetingRequest = MeetingRequest(tutor: dictionary["tutorUid"] as! String, tutoree: dictionary["tutoreeUid"] as! String, subject: dictionary["subject"] as! String, meetingId: dictionary["meetingId"] as! String)
					
					meetingRequest.setDate(date: Date(timeIntervalSince1970: dictionary["date"] as! TimeInterval))
					meetingRequest.setLocation(location: dictionary["location"] as! String)
					
					
					if let otherUserId = meetingRequest.meetingPartnerId(){
						
						Database.database().reference().child("users").child(otherUserId).observe(.value) { (snapshot) in
							
							let user = snapshot.value as? [String: Any]
							let newUser = User(emailString: user!["email"] as! String, profileImageUrlString: user!["profileImageUrl"] as! String, uidString: user!["uid"] as! String, usernameString: user!["username"] as! String)
						
							self.meetingRequestsUsers.append(newUser)
							self.meetingRequests.append(meetingRequest)

							
						}
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
			self.tableView.reloadData()
		}
	}
    
	//row selected
	override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
		
		//present display that shows detail of meeting and give the tutor options
		
		let storyboard: UIStoryboard = UIStoryboard(name: "Activity", bundle: nil)
		let meetingRequestVC = storyboard.instantiateViewController(withIdentifier: "MeetingRequestVC") as! MeetingRequestViewController
		
		meetingRequestVC.setUser(user: meetingRequestsUsers[indexPath.row])
		
		meetingRequestVC.setMeetingRequest(meetingRequest: meetingRequests[indexPath.row])
		
		navigationController?.pushViewController(meetingRequestVC, animated: true)
		
	}
	
//	//text in cell
	override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
		
		let cell = tableView.dequeueReusableCell(withIdentifier: "meetingRequestCell") as! MeetingRequestCell
		
		let otherUser = meetingRequestsUsers[indexPath.row]
		let meetingRequest = meetingRequests[indexPath.row]
		
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
		return self.meetingRequests.count
	}

}
