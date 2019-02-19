//
//  SubjectVCFindTutor.swift
//  TuTour
//
//  Created by Josh Kardos on 12/28/18.
//  Copyright © 2018 JoshTaylorKardos. All rights reserved.
//

import UIKit
import Firebase
import ProgressHUD
class SubjectVCFindTutor: SubjectsViewController{
	
	
	static var subjectToTutorCount = [[Any]]()
	let ref = Database.database().reference()
	
    

	override func viewDidLoad() {
        
        
		super.viewDidLoad()
		tableView.dataSource = self
		SubjectVCFindTutor.subjectToTutorCount.removeAll()
        
        
        
		ref.child("subject-tutors").observe(.childAdded) { (snapshot) in
			ProgressHUD.show("Loading..")
			//store in hashmap(K,V) --> subject, children Count
			let value: Int = Int(snapshot.childSnapshot(forPath: "tutors").childrenCount)
			SubjectVCFindTutor.subjectToTutorCount.append([snapshot.key, value])//subject, children count
		
			print("\(snapshot.key)   \(value)")
			print("\(SubjectVCFindTutor.subjectToTutorCount.count)")
			
			self.timer?.invalidate()
			self.timer = Timer.scheduledTimer(timeInterval: 0.1, target: self, selector: #selector(self.handleReloadCollection), userInfo: nil, repeats: false)
	
        }
	}
	
	var timer: Timer?
	@objc func handleReloadCollection(){
		DispatchQueue.main.async {
			print("RELOAD")
			self.tableView.reloadData()//.collectionView!.reloadData()
            ProgressHUD.dismiss()
		}
	}
	
	//Mark: - Cell is selected
	
	//cell selected
	override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
		
		if searchController.isActive && searchController.searchBar.text != ""{
	
			clickedCellHelper(subject: filteredSubjects[indexPath.row]!)
		
		} else {
			
			clickedCellHelper(subject: SubjectsViewController.subjectsArray[indexPath.row])
			
		}
				
	}
	func clickedCellHelper(subject: String){
		
		var tutorInSubject = false
		
		for i in 0..<SubjectVCFindTutor.subjectToTutorCount.count{
			if SubjectVCFindTutor.subjectToTutorCount[i][0] as! String == subject && SubjectVCFindTutor.subjectToTutorCount[i][1] as! Int > 0{
				
				//TUTORS in this subject
		
				tutorInSubject = true
				break
			}
			
		}
		if tutorInSubject == true{//TUTORS in this subject
			let tutorListVC = DiscoverViewController()
			
			tutorListVC.subject = subject
			navigationController?.pushViewController(tutorListVC, animated: true)
			
		}
		else{
			//no tutors in this subject
		}
	}
	
	//Mark: - Text To put in cell
	
	
	//text to put in cell
	override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
		
		let cell = tableView.dequeueReusableCell(withIdentifier: "subjectCell", for: indexPath) as! SubjectCellWithNumTutors
		

		let subject : String?
		
		if searchController.isActive && searchController.searchBar.text != ""{
			subject = filteredSubjects[indexPath.row]
		} else {
			subject = SubjectsViewController.subjectsArray[indexPath.row]
		}
		
		
		
		cell.cellLabel.text = subject
		cell.numbTutorsLabel.text = "0"
		
		handleTextToPutInCell(cell: cell, subject: subject!)
		
		return cell
	}
	
	func textToPutInCellHelper(cell: SubjectCellWithNumTutors, subject: String){
		
		for i in 0..<SubjectVCFindTutor.subjectToTutorCount.count{
			
			if SubjectVCFindTutor.subjectToTutorCount[i][0] as! String == subject {
				cell.numbTutorsLabel.text = String(SubjectVCFindTutor.subjectToTutorCount[i][1] as! Int)
				
			}
		}
	}
	
	func handleTextToPutInCell(cell: SubjectCellWithNumTutors, subject: String){
		
		if searchController.isActive && searchController.searchBar.text != ""{

			textToPutInCellHelper(cell: cell, subject: subject)

		} else {
			
			textToPutInCellHelper(cell: cell, subject: subject)
			
		}
	}
}
