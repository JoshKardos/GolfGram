//
//  SubjectsVCRegisterAsTutor.swift
//  GolfGram
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
		
		print(SubjectsViewController.subjectsArray[indexPath.row])
		
		let subjectTutorsRef = ref.child("subject-users").child(SubjectsViewController.subjectsArray[indexPath.row]).child("tutors")
		let uid = Auth.auth().currentUser?.uid
		
		subjectTutorsRef.updateChildValues([uid!:1])
		
		print("SUCCESS")
		
		//let 
		
		
//
//			for i in 0..<subjectsArray.count{
//					let newRef = ref.child("subject-users")
//					let subjectId = newRef.childByAutoId().key
//					let newSubjectRef = newRef.child(subjectsArray[i])
//
//					newSubjectRef.setValue(["subjectName": subjectsArray[i], "id": subjectId!])
//
//
//				}
		
	}
}
