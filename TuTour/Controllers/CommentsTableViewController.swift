//
//  CommentsTableViewController.swift
//  TuTour
//
//  Created by Josh Kardos on 3/3/19.
//  Copyright © 2019 JoshTaylorKardos. All rights reserved.
//

import Foundation
import UIKit
import Firebase
class CommentsTableViewController: UIViewController, UITableViewDataSource{
    
    var tabBarHeight = CGFloat()
    @IBOutlet weak var bottomContainerView: UIView!
    
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var textField: UITextField!
    @IBOutlet weak var sendButton: UIButton!
    
    var post: Post!{
        didSet{
            print(post.caption)
        }
    }
    
    override func viewDidLoad() {
        
        loadComments()
        
        tableView.dataSource = self
        
        
        
        self.tabBarController?.tabBar.isHidden = true
        setupBottomComponents()
        
        
        
    }
    override func viewWillDisappear(_ animated: Bool) {
        self.tabBarController?.tabBar.isHidden = false
    }
    
    func loadComments(){
        
        Database.database().reference().child("PostComments").child(post.postId!).observe(.value) { (snapshot) in
            
            
            
            
        }
        
    }
    
    func setupBottomComponents(){
        
        textField.placeholder = "Enter comment..."
        textField.borderStyle = .none
        
    }
    @IBAction func sendPressed(_ sender: Any) {
        
        
        //update node
        
        
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 5
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "CommentCell", for: indexPath) as! CommentCell
        cell.commentsLabel.text = "Hello"
        cell.isUserInteractionEnabled = true
        
        return cell
    }
    
    //
    //    override func viewDidLoad() {
    //        print("Comments viewdidload")
    //        super.viewDidLoad()
    //        tableView.dataSource = self
    //        tableView.delegate = self
    //    }
    //
    //    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    //        return 5
    //    }
    //
    //    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    //        let cell = tableView.dequeueReusableCell(withIdentifier: "CommentCell", for: indexPath) as! CommentCell
    //        cell.commentsLabel.text = "Hello"
    //        cell.isUserInteractionEnabled = true
    //        return cell
    //    }
    
    
    
}
