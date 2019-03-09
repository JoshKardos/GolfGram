//
//  SuggestedUsersViewController.swift
//  TuTour
//
//  Created by Josh Kardos on 3/8/19.
//  Copyright © 2019 JoshTaylorKardos. All rights reserved.
//

import Foundation
import UIKit
import FirebaseDatabase
import FirebaseStorage
class SuggestedUsersViewController: UIViewController, UITableViewDataSource{

    
    @IBOutlet weak var tableView: UITableView!
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.dataSource = self
        
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 3
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "SuggestedUserCell", for: indexPath) as! SuggestedUserCell
        
        let users = fetchThreeSuggestedUsers()
        
        updateCell(cell)
        


        return cell
    }
    func fetchThreeSuggestedUsers()->[NSDictionary]{
        
        var users = [NSDictionary]()
        
        //compare by available days
        
        
        //compare by skills
        
        return [NSDictionary]()
    }
    func updateCell(_ cell: SuggestedUserCell){
        
        cell.daysFreeLabel.text = "Days Free: \n"
        cell.skillsLabel.text = "nothing"
        
        
    }
    
}
