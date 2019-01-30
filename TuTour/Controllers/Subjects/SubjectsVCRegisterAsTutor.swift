//
//  SubjectsVCRegisterAsTutor.swift
//  TuTour
//
//  Created by Josh Kardos on 12/28/18.
//  Copyright © 2018 JoshTaylorKardos. All rights reserved.
//

import UIKit
import FirebaseDatabase
import FirebaseAuth
import ProgressHUD
class SubjectVCRegisterAsTutor: SubjectsViewController{
	
	override func viewDidLoad() {
		super.viewDidLoad()
	}
	
	override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
		
		let ref = Database.database().reference()
		
		let subjectTutorsRef = ref.child("subject-tutors").child(SubjectsViewController.subjectsArray[indexPath.row]).child("tutors")
		let uid = Auth.auth().currentUser?.uid
		
		subjectTutorsRef.updateChildValues([uid!:1])
		
		
	}
}
