//
//  CameraViewController.swift
//  TuTour
//
//  Created by Josh Kardos on 9/25/18.
//  Copyright © 2018 JoshTaylorKardos. All rights reserved.
//

import UIKit
import ProgressHUD
import FirebaseDatabase
import FirebaseStorage
import FirebaseDatabase
import FirebaseAuth
import TaggerKit
class CameraViewController: UIViewController , UITextViewDelegate{
    
    static let captionPlaceholder = "Add caption..."
    static let imagePlaceholder = "Portrait_Placeholder"
    
    @IBOutlet weak var photo: UIImageView!
    @IBOutlet weak var captionTextView: UITextView!
    
    @IBOutlet weak var shareButton: UIButton!
    @IBOutlet weak var removeButton: UIBarButtonItem!
    
    @IBOutlet weak var textField: TKTextField!
    var selectedImage: UIImage?
    
    @IBOutlet weak var topTagsContainerView: UIView!
    @IBOutlet weak var addedTagsContainerView: UIView!
    
    
    var addedTagCollection = TKCollectionView()
    var allTagCollection = TKCollectionView()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(CameraViewController.handleSelectPhoto))
        
        captionTextView.delegate = self
        captionTextView.text = CameraViewController.captionPlaceholder
        captionTextView.textColor = UIColor.lightGray
        
        Database.database().reference().child("users").child((Auth.auth().currentUser?.uid)!).child("skills").observe(.value) { (snapshot) in
            
            if let dictionary = snapshot.value as? [String: AnyObject] {
                for (skill, _) in dictionary{
                    self.allTagCollection.tags.append(skill)
                }
            }

            
            
            self.addedTagCollection.tags = []
            
            //all tags
            self.add(self.allTagCollection, toView: self.topTagsContainerView)
            self.allTagCollection.action = .addTag
            self.allTagCollection.receiver = self.addedTagCollection
            
            //add tags
            self.add(self.addedTagCollection, toView: self.addedTagsContainerView)
            self.addedTagCollection.action = .removeTag
            
            
            
            self.textField.sender = self.allTagCollection
            self.textField.receiver = self.addedTagCollection
            
            
            
            
            self.addedTagCollection.delegate = self
            self.allTagCollection.delegate = self
            self.photo.isUserInteractionEnabled = true
            
            self.photo.addGestureRecognizer(tapGesture)
            
            // Do any additional setup after loading the view.
            
        }
        
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        handlePost()
    }
    override func tagIsBeingAdded(name: String?) {
        print("TAG ADDED")
    }
    override func tagIsBeingRemoved(name: String?) {
        print("TAG REMOVED")
    }
    func textViewDidBeginEditing(_ textView: UITextView) {
        
        if captionTextView.textColor == UIColor.lightGray {
            captionTextView.text = ""
            captionTextView.textColor = UIColor.black
        }
    }
    func textViewDidEndEditing(_ textView: UITextView) {
        
        if captionTextView.text == "" {
            
            captionTextView.text = CameraViewController.captionPlaceholder
            captionTextView.textColor = UIColor.lightGray
        }
    }
    func handlePost(){
        
        if selectedImage != nil {
            
            self.shareButton.isEnabled = true
            self.shareButton.backgroundColor = AppDelegate.theme_Color
            
            self.removeButton.isEnabled = true
            
            
            
        } else {
            
            self.shareButton.isEnabled = false
            self.shareButton.backgroundColor = #colorLiteral(red: 0.6015228426, green: 0.6015228426, blue: 0.6015228426, alpha: 1)
            
            removeButton.isEnabled = false
        }
    }
    
    func clean(){
        self.captionTextView.text = CameraViewController.captionPlaceholder
        self.photo.image = UIImage(named: CameraViewController.imagePlaceholder)
        self.selectedImage = nil
        handlePost()
        
    }
    
    
    @IBAction func removePressed(_ sender: Any) {
        
        clean()
    }
    
    
    //Selector called in viewDidLoad
    @objc func handleSelectPhoto(){
        let pickerController = UIImagePickerController()
        //access to extension
        pickerController.delegate = (self as UIImagePickerControllerDelegate & UINavigationControllerDelegate)
        present(pickerController, animated: true, completion: nil)
    }
    
    @IBAction func shareButtonPressed(_ sender: Any) {
        
        ProgressHUD.show("Waiting To Post...", interaction: false)
        //Must have selected an image, image turned to jpeg
        if let profileImg = self.selectedImage{
            if let imageData = profileImg.jpegData(compressionQuality: 0.1) {
                let photoId = NSUUID().uuidString
                let storageRef = Storage.storage().reference(forURL: "gs://golfgram-68599.appspot.com").child("posts").child(photoId)
                
                
                //insert jpeg data into database with the url
                storageRef.putData(imageData, metadata: nil, completion: { (metadata, error) in
                    if error != nil{
                        return
                    }
                    
                    storageRef.downloadURL { (url, error) in
                        if error != nil{
                            print("Error ")
                            return
                        }
                        //get url of image
                        guard let photoURL = url?.absoluteString else {return}
                        self.sendDataToDatabase(photoUrl: photoURL)
                    }
                })
                
                
                
            }
        } else {
        }
    }
    
    func sendDataToDatabase(photoUrl: String) {
        //Referenece to posts
        let postsRef = Database.database().reference().child("posts")
        
        
        //OLD
        //Generate new post id
        //let newPostId = postsRef.childByAutoId().key
        //Reference to new post
        //let newPostRef = postsRef.child(newPostId!)
        //////////////////////////////////////////////
        
        let newPostRef = postsRef.childByAutoId()
        let newPostId = newPostRef.key!
        
        //set current user id
        let userId = Auth.auth().currentUser!.uid
        
        var skillsMap = [String: Int]()
        for skill in addedTagCollection.tags{
            skillsMap[skill] = 1
        }
        
        
        //set the value of the new post reference
        newPostRef.setValue(["photoUrl": photoUrl, "caption": captionTextView.text!, "postId": newPostId, "senderId":userId, "skillsRequired": skillsMap]) { (error, ref) in
            if error != nil {
                ProgressHUD.showError(error!.localizedDescription)
                return
            }
            ProgressHUD.showSuccess("Success")
            self.clean()
            self.tabBarController?.selectedIndex = 0
        }
    }
    
    
}


extension CameraViewController: UIImagePickerControllerDelegate, UINavigationControllerDelegate{
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        
        
        
        if let image = info[UIImagePickerController.InfoKey.originalImage] as? UIImage{
            self.selectedImage = image
            photo.image  = image
            
        }
        //print("** \(info) **")
        //profileImage.image = infoPhoto
        dismiss(animated: true, completion: nil)
    }
    
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        view.endEditing(true)
    }
    
}
