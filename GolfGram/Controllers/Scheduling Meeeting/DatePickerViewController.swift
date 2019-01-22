//
//  DatePickerViewController.swift
//  GolfGram
//
//  Created by Josh Kardos on 1/19/19.
//  Copyright © 2019 JoshTaylorKardos. All rights reserved.
//

import Foundation
import UIKit

class DatePickerViewController: UIViewController {
	
	
	@IBOutlet weak var datePicker: UIDatePicker!
	@IBOutlet weak var submitButton: UIButton!
	
	var meeting: MeetingRequest?
	
	@IBAction func submitPressed(_ sender: Any) {
		
		let date = datePicker.date
		print(date.description)
		
		//move to location picker
		
		let storyboard: UIStoryboard = UIStoryboard(name: "Profile", bundle: nil)
		let locationPicker = storyboard.instantiateViewController(withIdentifier: "LocationPicker") as! LocationPickerViewController
		meeting?.setDate(date: date)
		locationPicker.meeting = meeting!
		navigationController?.pushViewController(locationPicker, animated: true)
		
		
	}
}

