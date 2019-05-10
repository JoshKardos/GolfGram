//
//  HomeViewController.swift
//  TuTour
//
//  Created by Josh Kardos on 9/25/18.
//  Copyright © 2018 JoshTaylorKardos. All rights reserved.
//

import UIKit
import FirebaseAuth
import FirebaseDatabase
import ChameleonFramework
import UserNotifications
class HomeViewController: UITableViewController, UNUserNotificationCenterDelegate{
    
    var renderredCells = [PostCell]()
    
    override func viewDidLoad() {
        
        super.viewDidLoad()
        tableView.dataSource = self
        tableView.delegate = self
        
        // Do any additional setup after loading the view.
        loadPosts() { [weak self] (success, error) in
            guard let strongSelf = self else { return }
            if !success {
                DispatchQueue.main.async {
                    let title = "Error"
                    if let error = error {
                        print("HERE ! \(error)")
                        //                        strongSelf.showError(title, message: error.localizedDescription)
                    } else {
                        print("HERE !!!! \(error)")
                        //                        strongSelf.showError(title, message: NSLocalizedString("Can't retrieve contacts.", comment: "The message displayed when contacts can’t be retrieved."))
                    }
                }
            } else {
                DispatchQueue.main.async {
                    strongSelf.tableView.reloadData()
                }
            }
        }
        UNUserNotificationCenter.current().delegate = self
        UNUserNotificationCenter.current().requestAuthorization(options: [.alert, .sound, .badge]) { [weak self] (didAllow, error) in
            
            guard didAllow else { return }
            self?.getNotificationSettings()
            
        }
        
    }
    
    func getNotificationSettings() {
        UNUserNotificationCenter.current().getNotificationSettings { settings in
            print("Notification settings: \(settings)")
            guard settings.authorizationStatus == .authorized else { return }
            DispatchQueue.main.async {
                UIApplication.shared.registerForRemoteNotifications()
            }
        }
    }
    func userNotificationCenter(_ center: UNUserNotificationCenter, willPresent notification: UNNotification, withCompletionHandler completionHandler: @escaping (UNNotificationPresentationOptions) -> Void) {
        completionHandler([.alert, .sound])
    }
    var posts = [Post]()
    
    
    
    func loadPosts(_ completionBlock: @escaping (_ success: Bool, _ error: NSError?) -> ()){
        
        print("IN LOAD POSTS")
        let ref = Database.database().reference()
        
        
        
        //access posts
        ref.child("posts").queryOrderedByKey().observe(.value, with: { (snap) in//get all posts
            self.posts = []
            print("FIRST")
            if let postsSnap = snap.value as? [String: [String: AnyObject]]{
                
                for(_, post) in postsSnap {
                    
                    let postId = post["postId"] as! String
                    ref.child("post-likes").child(postId).observeSingleEvent(of: .value, with: { (snapshot) in
                        print("SECOND")
                        
                        let numberOfLikes = Int(snapshot.childrenCount)
                        
                        ref.child("post-comments").child(postId).observeSingleEvent(of: .value, with: { (snapshot) in
                            print("THIRD")
                            let numberOfComments = Int(snapshot.childrenCount)
                            
                            ref.child("users").child(post["senderId"] as! String).observeSingleEvent(of: .value, with: { (snapshot) in
                                
                                print("FOURTH")
                                let dictionary = snapshot.value as! [String: AnyObject]
                                let username = (dictionary["username"] as! String)
                                
                                let profileImageString = (snapshot.value as! NSDictionary)["profileImageUrl"] as! String
                                
                                let post = Post(dictionary: post, numComments: numberOfComments, numLikes: numberOfLikes, username: username, profileImageUrl: profileImageString)
                                
                                self.posts.append(post)
                                DispatchQueue.main.async {
                                    self.tableView.reloadData()
                                }
                            })
                            
                            
                            
                            
                        })
                    })
                    
                }
                
                completionBlock(true, nil)
            } else {
                completionBlock(false, nil)
            }
            
        })
        
        
    }
    
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return posts.count
    }
    
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        var cell = tableView.dequeueReusableCell(withIdentifier: "PostCell", for: indexPath) as! PostCell
        if indexPath.row < renderredCells.count{
            
            cell = renderredCells[indexPath.row]
            
        } else {
            cell.configure(posts[indexPath.row])
            renderredCells.append(cell)
        }
        cell.delegate = self
        
        return cell
    }
    
    //MARK: - Fix (post)
    func cellCommentPressed(post: Post){
        let storyboard = UIStoryboard(name: "Home", bundle: nil)
        var commentVC = storyboard.instantiateViewController(withIdentifier: "CommentsViewController") as! CommentsTableViewController
        
        commentVC.post = post
        navigationController?.pushViewController(commentVC, animated: true)
    }
    
    func requestPressed(post: Post){
        print("request pressed")
        //start meeting request
        
        let meeting = MeetingRequest(tutor: (Auth.auth().currentUser?.uid)!, tutoree: post.senderId!, subject: "Response To Post")
        let storyboard: UIStoryboard = UIStoryboard(name: "Profile", bundle: nil)
        
        let timeOptionsVC = storyboard.instantiateViewController(withIdentifier: "TimeOptions") as! DatePickerViewController
        
        timeOptionsVC.meeting = meeting
        
        navigationController?.pushViewController(timeOptionsVC, animated: true)
    }
}


//MARK: - SenderUsername
class Post{
    var caption: String?
    var postId: String?
    var photoUrl: String?
    var senderId: String?
    var numberOfLikes: Int?
    var numberOfComments: Int?
    var senderUsername: String?
    var profileImageUrl: String?
    var skillsRequired = [String]()
    init(dictionary: [String: AnyObject], numComments: Int, numLikes: Int, username: String, profileImageUrl: String){
        
        
        caption = (dictionary["caption"] as! String)
        postId = (dictionary["postId"] as! String)
        photoUrl = (dictionary["photoUrl"] as! String)
        senderId = (dictionary["senderId"] as! String)
        
        //get statistics
        numberOfLikes = numLikes
        numberOfComments = numComments
        senderUsername = username
        self.profileImageUrl = profileImageUrl
        
        if let skillsMap = dictionary["skillsRequired"] as? [String: AnyObject] {
            
            for (skill, _) in skillsMap{
                print(skill)
                skillsRequired.append(skill)
            }
        } else {
            print("No skills required for post \(postId!)")
        }
        //get sender info
    }
    
}
