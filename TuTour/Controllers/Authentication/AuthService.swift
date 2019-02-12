//
//  AuthService.swift
//  TuTour
//
//  Created by Josh Kardos on 10/1/18.
//  Copyright © 2018 JoshTaylorKardos. All rights reserved.
//

import Foundation
import FirebaseAuth
import FirebaseStorage
import FirebaseDatabase

class AuthService {
    
    
    static func signIn(email: String, password: String, onSuccess: @escaping() -> Void, onError: @escaping(_ errorMessage: String?) -> Void){
        Auth.auth().signIn(withEmail: email, password: password) { (user, error) in
            if error != nil {
                onError(error!.localizedDescription)
                return
            }
            
            onSuccess()
            
        }
    }
    
    
    static func signUp(fullname: String, username: String, email: String, password: String, school: String, major: String, year: String,  imageData: Data, onSuccess: @escaping() -> Void, onError: @escaping(_ errorMessage: String?) -> Void){
        
        
        /////////////////////
        ////Create User//////
        /////////////////////
        Auth.auth().createUser(withEmail: email, password: password) { (user, error) in
            if error != nil {
                print("Eror creating user: \(error!.localizedDescription)")
                return
            }
            
            //Get reference to the profile images//
            ///////////////////////////////////////
            let storageRef = Storage.storage().reference(forURL: "gs://golfgram-68599.appspot.com").child("profile_image").child((user?.user.uid)!)
            
            
            
            //insert jpeg data into database with the url
            storageRef.putData(imageData, metadata: nil, completion: { (metadata, error) in
                if error != nil{
                    onError(error?.localizedDescription)
                    return
                }
                
                storageRef.downloadURL { (url, error) in
                    if error != nil{
                        print("Error \(error?.localizedDescription)")
                        return
                    }
                    //get url of image
                    guard let profileImageUrl = url?.absoluteString else {return}
                    let uid = Auth.auth().currentUser!.uid

                    self.signUpUser(profileImageUrl: profileImageUrl, fullname: fullname, username: username, email: email, uid: uid, school: school, major: major, year: year, onSuccess: onSuccess)
                }
            })
        }
        
    }
    static func signUpUser(profileImageUrl: String,fullname: String, username: String, email: String, uid: String,  school: String, major: String, year: String , onSuccess: @escaping () -> Void){
        
        //get referenece to users in the database
        let usersRef = Database.database().reference().child("users")
        
        //save user(username, email, major, school profileImage)
        usersRef.child(uid).setValue(["fullname": fullname, "username": username, "email" : email, "major": major, "school": school, "year": year, "profileImageUrl": profileImageUrl, "uid": uid])
        print("new user: \( usersRef.child(uid))")
        
        onSuccess()
    }
}
