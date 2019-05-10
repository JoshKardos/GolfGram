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
class CommentsTableViewController: UIViewController, UITableViewDataSource, UITextFieldDelegate{
    
    @IBOutlet weak var bottomContainerView: UIView!
    
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var textField: UITextField!
    @IBOutlet weak var sendButton: UIButton!
    let toolbar = UIToolbar()
    var comments = [Comment]()
    
    
    var post: Post!{
        didSet{
            loadComments()
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        tableView.dataSource = self
        tableView.separatorStyle = .none
        
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow), name: UIResponder.keyboardWillShowNotification, object: nil)
        
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide), name: UIResponder.keyboardWillHideNotification, object: nil)
        
        
        self.tabBarController?.tabBar.isHidden = true
        setupBottomComponents()
        
        
    }
    @objc func doneClicked(){
        view.endEditing(true)
    }
    @objc func keyboardWillShow(_ notification: Notification) {
        if let keyboardFrame: NSValue = notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue {
            let keyboardRectangle = keyboardFrame.cgRectValue
            let keyboardHeight = keyboardRectangle.height
            print("KEYBOARD IS UP \(keyboardHeight)")
          
            self.view.frame.origin.y -= keyboardHeight 
            
        }
        
    }
    @objc func keyboardWillHide(_ notification: Notification) {
        
        self.view.frame.origin.y = 0
    }
    override func viewWillDisappear(_ animated: Bool) {
        self.tabBarController?.tabBar.isHidden = false
    }
    
    
    
    func loadComments(){
        
        guard let uid = Auth.auth().currentUser?.uid else { return }
        let postCommentsRef = Database.database().reference().child("post-comments").child(post.postId!)
        
        
        postCommentsRef.observe(.childAdded, with: { (snapshot) in
            
            let commentId = snapshot.key
            
            let commentsRef = Database.database().reference().child("comments").child(commentId)
            
            commentsRef.observeSingleEvent(of: .value, with: { (snapshot) in
                
                
                guard let dictionary = snapshot.value as? [String: AnyObject] else { return }
                
                let comment = Comment(dictionary: dictionary)
                
                self.comments.append(comment)
                
                if let tableView = self.tableView{
                    tableView.reloadData()
                }
            })
            
        })
        
        
        
        
        
        
    }
    
    func setupBottomComponents(){
        
        textField.placeholder = "Enter comment..."
        textField.borderStyle = .none
        
        sendButton.setTitleColor(AppDelegate.theme_Color, for: .normal)
        
        
        
        toolbar.sizeToFit()
        
        let flexibleSpace = UIBarButtonItem(barButtonSystemItem: UIBarButtonItem.SystemItem.flexibleSpace, target: nil, action: nil)
        
        let doneButton = UIBarButtonItem(barButtonSystemItem: UIBarButtonItem.SystemItem.cancel, target: self, action: #selector(self.doneClicked))
        
        toolbar.setItems([flexibleSpace, doneButton], animated: false)
        textField.inputAccessoryView = toolbar
    }
    @IBAction func sendPressed(_ sender: Any) {
        
        
        
        //update node
        if let commentText = textField.text{
            
            
            let postToCommentsRef = Database.database().reference().child("post-comments").child(post.postId!).childByAutoId()
            postToCommentsRef.setValue(1)
            let userRef = Database.database().reference().child("users").child((Auth.auth().currentUser?.uid)!).child("profileImageUrl").observe(.value) { (snapshot) in
                
                let senderProfileImageUrl = snapshot.value as! String
                
                
                let ref = Database.database().reference().child("comments").child(postToCommentsRef.key!)
                
                ref.updateChildValues(["text": commentText, "senderId": (Auth.auth().currentUser?.uid)!,"senderProfileImageUrl": senderProfileImageUrl, "commentId": postToCommentsRef.key! , "timestamp": NSDate().timeIntervalSince1970, "postId": self.post.postId!])
                
            }
            
        }
        
        self.textField.text = nil
        
        
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return comments.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "CommentCell", for: indexPath) as! CommentCell
        
        //set profile image to sender profile image
        cell.commentsLabel.text = comments[indexPath.row].commentText
        Database.database().reference().child("users").child((Auth.auth().currentUser?.uid)!).observeSingleEvent(of: .value) { (snapshot) in
            if let dictionary = snapshot.value as? [String: AnyObject]{
                if let profileImageUrl = dictionary["profileImageUrl"]{
                    
                    DispatchQueue.global(qos: .userInteractive).async {
                        
                        
                        let url = URL(string: profileImageUrl as! String)
                        let imageData = NSData.init(contentsOf: url as! URL)
                        let image = UIImage(data: imageData as! Data)
                        
                        
                        DispatchQueue.main.async {
                            cell.senderProfileImage.image = image
                        }
                    }
                    
                }
                
                
            }
            
        }
        
        cell.isUserInteractionEnabled = true
        
        return cell
        
        
    }
    
    
    
    
    
}

extension UITextField{
    
}
