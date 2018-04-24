//
//  MyProfileViewController.swift
//  WhatToEat
//
//  Created by CHEN CHEN on 4/24/18.
//  Copyright © 2018 CHEN CHEN. All rights reserved.
//

import UIKit
import Firebase

class MyProfileViewController: UIViewController {
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationItem.title = "My Profile"
        nameField.isHidden = true
        handleUser()
    }
    
    @IBOutlet weak var userEmail: UILabel!
    @IBOutlet weak var userName: UILabel!
    
    @IBOutlet weak var nameField: UITextField!
    

    @IBAction func SettingName(_ sender: UIButton) {
        if nameField.isHidden == false {
            guard let inputName = nameField.text else{
                print("Your name can't be empty")
                let title = "Empty Name"
                let message = "Your name can't be empty"
                let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
                alert.addAction(UIAlertAction(title: NSLocalizedString("OK", comment: "Default action"), style: .default, handler: { _ in
                    NSLog("The \"\(title)\" alert occured.")
                }))
                self.present(alert, animated: true, completion: nil)
                return
            }
            userName.text = nameField.text
            let changeRequest = Auth.auth().currentUser?.createProfileChangeRequest()
            changeRequest?.displayName = userName.text!
            changeRequest?.commitChanges { (error) in
                if error != nil {
                    print(error!.localizedDescription)
                    let title = error!.localizedDescription
                    let message = error!.localizedDescription
                    let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
                    alert.addAction(UIAlertAction(title: NSLocalizedString("OK", comment: "Default action"), style: .default, handler: { _ in
                        NSLog("The \"\(title)\" alert occured.")
                    }))
                    self.present(alert, animated: true, completion: nil)
                }
            }
        }
        userName.isHidden = !userName.isHidden
        nameField.isHidden = !nameField.isHidden
        print("hello")
    }
    // see if can user a listener instead
    func handleUser() {
        print ("hhhh")
        if let user = Auth.auth().currentUser {
            // User is signed in.
//            let user = Auth.auth().currentUser
            let email = user.email
            let name = user.displayName
            userEmail.text = email
            userName.text = name
            print ("user found")
            print (email)
        } else {
            // No user is signed in.
            // ...
            print ("no user")
        }
    }
    
}
