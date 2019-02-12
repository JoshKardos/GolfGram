//
//  LocationPickerViewController.swift
//  TuTour
//
//  Created by Josh Kardos on 1/20/19.
//  Copyright © 2019 JoshTaylorKardos. All rights reserved.
//

import Foundation
import UIKit
import FirebaseDatabase
import FirebaseAuth
import ProgressHUD

class LocationPickerViewController: UIViewController, UIPickerViewDelegate, UIPickerViewDataSource{
	//map of sjsu url: http://www.sjsu.edu/map/

	@IBOutlet weak var sjsuMap: UIImageView!
	@IBOutlet weak var locationPicker: UIPickerView!
	@IBOutlet weak var submitButton: UIButton!

	var meeting: MeetingRequest?
	var location: String?
	
	static let locations = [
		"(ADM)Administration","(ART)Art Building","(ASH)Associated Students House","(BBC)Boccardo Business Complex","(BT)Business Tower","(CC)Computer Center","(CCB)Central Classroom Building","(CL)Clark Hall","(DMH)Dudley Moorhead Hall","(DH)Duncan Hall","(DBH)Dwight Bentel Hall","(ENG)Engineering Building","(FOB)Faculty Offices","(HB)Health Building","(HGH)Hugh Gillis Hall","(IS)Industrial Studies","(IRC)Instructional Resource Center","(KING)Dr. Martin Luther King, Jr. Library","(MH)MacQuarrie Hall","(MUS)Music Building","(SCI)Science Building","(SPXC)Spartan Complex Central","(SPXE)Spartan Complex East","(SPM)Spartan Memorial","(SRAC)Student Recreation and Aquatic Center","(SWC)Student Wellness Center","(SSC)Student Services Center","(SU)Diaz Compean Student Union","(SH)Sweeney Hall","(TH)Tower Hall","(WSQ)Washington Square Hall","(YUH)Yoshihiro Uchida Hall"


	]
	
	override func viewDidLoad() {
		super.viewDidLoad()
		locationPicker.dataSource = self
		locationPicker.delegate = self
	}
	
	override func viewDidAppear(_ animated: Bool) {
		viewDidLoad()
	}
	
	@IBAction func submitPressed(_ sender: Any) {
		
		createMeetingRequest()
		
		navigationController?.popToRootViewController(animated: true)
		
	}
	
	func createMeetingRequest(){//just a request, send to other user, tutor or tutoree
		
		
		
		if let meetingLocation = location{
            
			meeting?.setLocation(location: meetingLocation)
			print(meetingLocation)
			
			let ref = Database.database().reference()
			
			let meetingRequestRef = ref.child("MeetingRequests")
			let newMeetingRequestId = meetingRequestRef.childByAutoId().key!
			
			
			let tutorToMeetingRequestRef = ref.child("tutor-meetingRequest")
			//let tutoreeToMeetingRequestRef =
			
			let tutorUid = meeting?.tutorUid!
			let tutoreeUid = meeting?.tutoreeUid!
			
            
            meeting?.setLastPersonToSendId(uid: (Auth.auth().currentUser?.uid)!)
			meetingRequestRef.child(newMeetingRequestId).setValue(["date": meeting?.date!.timeIntervalSince1970, "location": meeting?.location!, "tutorUid": tutorUid, "tutoreeUid": tutoreeUid, "subject": meeting?.subject!, "meetingId": newMeetingRequestId, "lastPersonToSendUid": meeting?.lastUserToSendId]){ (error, ref) in
				if error != nil {
					ProgressHUD.showError(error!.localizedDescription)
					return
				}
				
				
				let userToMeetingRequestRef = Database.database().reference().child("user-meetingRequests")
				
				let tutorRef = userToMeetingRequestRef.child(tutorUid!)
				let tutoreeRef = userToMeetingRequestRef.child(tutoreeUid!)
				
				
				tutorRef.updateChildValues([newMeetingRequestId: 1])
				tutoreeRef.updateChildValues([newMeetingRequestId:1])
				
				ProgressHUD.showSuccess("Success, Meeting Request sent")

			}
			
	
//
//			let tutorRequestsRef = Database.database().reference().child("tutor-request")
//			let tutoreeRequestsRef = Database.database().reference().child("tutoree-request")
//
//			tutorRequestsRef.child((meeting?.tutorUid)!).setValue([newMeetingRequestId: "1"])
//			tutoreeRequestsRef.child((meeting?.tutoreeUid)!).setValue([newMeetingRequestId: "1"])
			
			
		}else{
			ProgressHUD.showError("ERROR, most likely the location was not set.")
		}
		
		//HERE
		//send request to tutor
		
		
		
	}
	
	func numberOfComponents(in pickerView: UIPickerView) -> Int {
		return 1
		
	}
	
	func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
		print(LocationPickerViewController.locations.count)
		return LocationPickerViewController.locations.count

	}
	
	func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
		return LocationPickerViewController.locations[row]
	}
	func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
		location = LocationPickerViewController.locations[row]
	}
	
}
