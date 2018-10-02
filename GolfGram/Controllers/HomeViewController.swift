//
//  HomeViewController.swift
//  GolfGram
//
//  Created by Josh Kardos on 9/25/18.
//  Copyright © 2018 JoshTaylorKardos. All rights reserved.
//

import UIKit
import FirebaseAuth

class HomeViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    
	
	@IBAction func logoutPressed(_ sender: Any) {
		
		print(Auth.auth().currentUser)
		
		do {
			try Auth.auth().signOut()
		} catch let logoutError{
			print(logoutError)
		}
		
		let storyboard = UIStoryboard(name: "Start", bundle: nil)
		
		let signInVC = storyboard.instantiateViewController(withIdentifier: "SignInViewController")
		
		self.present(signInVC, animated: true, completion: nil)
		
		
	
	}
	

}
