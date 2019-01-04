//
//  SubjectsViewController.swift
//  GolfGram
//
//  Created by Josh Kardos on 12/27/18.
//  Copyright © 2018 JoshTaylorKardos. All rights reserved.
//


import UIKit
import FirebaseDatabase
import FirebaseAuth
import ProgressHUD
class SubjectsViewController: UITableViewController, UISearchResultsUpdating {
	
	let searchController = UISearchController(searchResultsController: nil)
	@IBOutlet weak var searchBar: UISearchBar!
	
	static var subjectsArray = ["AMERICAN STUDIES","ANIMATION AND ILLUSTRATION","ANTHROPOLOGY","APPLIED SCIENCES & ARTS","ART","ART EDUCATION","ART HISTORY","ASIAN AMERICAN STUDIES","ASIAN STUDIES", "ASTRONOMY","AVIATION","BIOLOGY","BIOMEDICAL ENGINEERING","BOTANY","BUSINESS GRADUATE PROGRAMS","BUSINESS:  ACCOUNTING & FINANCE","BUSINESS:  MANAGEMENT INFORMATION SYSTEMS","BUSINESS:  MARKETING","BUSINESS:  SCHOOL OF MANAGEMENT","BUSINESS: GLOBAL INNOVATION AND LEADERSHIP","CHEMICAL ENGINEERING","CHEMISTRY","CHICANA AND CHICANO STUDIES","CHILD & ADOLESCENT DEVELOPMENT","CHINESE","CIVIL & ENVIRONMENTAL ENGINEERING","COMMUNICATION STUDIES","COMPUTER ENGINEERING","COMPUTER SCIENCE","COUNSELOR EDUCATION","CREATIVE ARTS","DANCE","DESIGN","ECONOMICS","EDD LEADERSHIP PROGRAM","EDUCATION","EDUCATIONAL ADMINISTRATION","ELECTRICAL ENGINEERING","ENGLISH","ENGLISH EDUCATION","ENTOMOLOGY","ENVIRONMENTAL STUDIES","FOREIGN LANGUAGE EDUCATION","FOREIGN LANGUAGES","FORENSIC SCIENCE","FRENCH","GENERAL ENGINEERING","GEOGRAPHY","GEOLOGY","GERMAN","GERONTOLOGY","GLOBAL STUDIES","GRAPHIC DESIGN","HEALTH PROFESSIONS","HEALTH SCIENCE","HEBREW","HISTORY","HOSPITALITY MANAGEMENT","HUMANITIES","HUMANITIES & THE ARTS","INDUSTRIAL & SYSTEMS ENGINEERING","INDUSTRIAL DESIGN","INTERCOLLEGIATE ATHLETICS","INTERIOR DESIGN","ITALIAN","JAPANESE","JEWISH STUDIES","JOURNALISM","JUSTICE STUDIES","KINESIOLOGY","KINESIOLOGY EDUCATION","LINGUISTICS","LINGUISTICS & LANGUAGE DEVELOPMENT","MARINE SCIENCE","MASS COMMUNICATION","MATERIALS ENGINEERING","MATH EDUCATION","MATHEMATICS","MECHANICAL ENGINEERING","METEOROLOGY AND CLIMATE SCIENCE","MEXICAN AMERICAN STUDIES","MICROBIOLOGY","MIDDLE EAST STUDIES","MILITARY SCIENCE","MUSIC","MUSIC EDUCATION","NUCLEAR SCIENCE","NURSING","NUTRITION,  FOOD SCIENCE & PACKAGING","OCCUPATIONAL THERAPY","ORGANIZATIONAL STUDIES","PACKAGING","PHILOSOPHY","PHOTOGRAPHY","PHYSICS","POLITICAL SCIENCE","PORTUGUESE","PSYCHOLOGY","PUBLIC ADMINISTRATION","PUBLIC RELATIONS","RADIO - TELEVISION - FILM","RECREATION & LEISURE STUDIES","RELIGIOUS STUDIES","SCHOOL OF INFORMATION","SCIENCE","SCIENCE EDUCATION","SOCIAL SCIENCE","SOCIAL SCIENCE ALL COLLEGE","SOCIAL SCIENCE EDUCATION","SOCIAL WORK","SOCIOLOGY","SOFTWARE ENGINEERING","SPANISH","SPECIAL EDUCATION","SPEECH EDUCATION","STATISTICS","TEACHER EDUCATION","TECHNOLOGY","THEATRE ARTS","UNIVERSITY STUDIES","URBAN & REGIONAL PLANNING","VIETNAMESE","WOMEN'S STUDIES","ZOOLOGY"]
	
	
	
	var filteredSubjects = [String?]()
	
	var databaseRef = Database.database().reference()
	
	
	override func viewDidLoad() {
		super.viewDidLoad()
		
		searchController.searchResultsUpdater = self
		searchController.dimsBackgroundDuringPresentation = false
		searchController.searchBar.tintColor = UIColor.flatGreenDark
		definesPresentationContext = true
		tableView.tableHeaderView = searchController.searchBar
	}
	
	//MARK: - Tableview Methods
	
	//rows in table
	override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
		if searchController.isActive && searchController.searchBar.text != ""{
			return filteredSubjects.count
		}
		
		return SubjectsViewController.subjectsArray.count
	}
	
	//text to put in cell
	override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
		
		let cell = tableView.dequeueReusableCell(withIdentifier: "subjectCell", for: indexPath) as! SubjectCell
		
		
		let subject : String?
		
		if searchController.isActive && searchController.searchBar.text != ""{
			subject = filteredSubjects[indexPath.row]
		} else {
			subject = SubjectsViewController.subjectsArray[indexPath.row]
		}
		
		cell.cellLabel.text = subject
		
		return cell
	}
}

//MARK: - Search Bar Methods
extension SubjectsViewController: UISearchBarDelegate{
	
	
	func updateSearchResults(for searchController: UISearchController){
		filterContent(searchText: self.searchController.searchBar.text!)
	}
	
	func filterContent(searchText: String){
		
		self.filteredSubjects = SubjectsViewController.subjectsArray.filter{ user in
			
			let subject = user as? String
			
			return(subject?.lowercased().contains(searchText.lowercased()))!
			
		}
		
		tableView.reloadData()
		
	}
	
	func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
		//todoItems = todoItems?.filter("title CONTAINS[cd] %@",searchBar.text!).sorted(byKeyPath: "dateCreated", ascending: true)
		tableView.reloadData()
		
	}
	
	//search bar text changed
	func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
		if searchBar.text?.count == 0 {
			//loadItems()
			
			//Disaptch Queue object assigns projects to different thread
			DispatchQueue.main.async {
				searchBar.resignFirstResponder()
			}
			
			
			
		}
	}
	
}
