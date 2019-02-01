//
//  MeetingRequestViewController.swift
//  TuTour
//
//  Created by Josh Kardos on 1/31/19.
//  Copyright © 2019 JoshTaylorKardos. All rights reserved.
//

import Foundation
import UIKit

class MeetingRequestViewController: UIViewController{
	
	@IBOutlet weak var titleLabel: UILabel!
	
	@IBOutlet weak var denyButton: UIButton!
	@IBOutlet var meetingRequestLabels: [UILabel]!
	//Subject
	//Student username
	//Building
	//Day
	//Time
	
	var user: User?
	var meetingRequest: MeetingRequest?
	
	@IBAction func denyPressed(_ sender: UIButton) {
	}
	@IBAction func acceptPressed(_ sender: UIButton) {
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
		
		//username
		meetingRequestLabels[1].text = user!.username
		
		//building
		meetingRequestLabels[2].text = meetingRequest!.location
		
		//day
		let dateFormatter = DateFormatter()
		dateFormatter.dateFormat = "MM-dd-yyyy"
		meetingRequestLabels[3].text = dateFormatter.string(from: meetingRequest!.date!)
		//https://medium.com/@tjcarney89/using-dateformatter-to-format-dates-and-times-from-apis-57622ce11d04
		
		//time
		let dateFormatter2 = DateFormatter()
		dateFormatter2.dateFormat = "h:mm a"
		meetingRequestLabels[4].text = dateFormatter2.string(from: meetingRequest!.date!)
		
		
		
	}
	
	override func viewDidLoad() {
		super.viewDidLoad()
		for i in 0..<meetingRequestLabels.count{
			print(meetingRequestLabels[i].text!)
		}
		fillMeetingRequestLabels()
		
		for i in 0..<meetingRequestLabels.count{
			print(meetingRequestLabels[i].text!)
		}
		
	}
}
