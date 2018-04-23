//
//  ViewController.swift
//  WhatToEat
//
//  Created by CHEN CHEN on 4/10/18.
//  Copyright © 2018 CHEN CHEN. All rights reserved.
//

import UIKit
import Firebase
import GoogleSignIn
import FacebookCore
import FacebookLogin

class LoginViewController: UIViewController, GIDSignInUIDelegate {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        GIDSignIn.sharedInstance().uiDelegate = self
        //        GIDSignIn.sharedInstance().signIn()
    }
    
    @IBOutlet weak var emailTextField: UnderlinedTextField!
    @IBOutlet weak var passwordTextField: UnderlinedTextField!
    
    @IBAction func handleSignUp(_ sender: UIButton) {
        guard let email = emailTextField.text else {
            print("No email provided")
            return
        }
        guard let password = passwordTextField.text else {
            print("No password provided")
            return
        }
        Auth.auth().createUser(withEmail: email, password: password) { (user, error) in
            if error != nil {
                switch AuthErrorCode(rawValue: error!._code)! {
                case .missingEmail:
                    print("No Email provided")
                case .invalidEmail:
                    print("Invalid Email address")
                case .weakPassword:
                    print("Password must be at least 6 characters")
                case .emailAlreadyInUse:
                    print("Email already in use")
                default:
                    print(error!.localizedDescription)
                }
                return
            }
            print("Sign up successfully")
        }
    }
    
    @IBAction func handleSignIn(_ sender: UIButton) {
        guard let email = emailTextField.text else {
            print("No email provided")
            return
        }
        guard let password = passwordTextField.text else {
            print("No password provided")
            return
        }
        Auth.auth().signIn(withEmail: email, password: password) { (user, error) in
            if error != nil {
                switch AuthErrorCode(rawValue: error!._code)! {
                case .missingEmail:
                    print("No Email provided")
                case .userNotFound:
                    print("Email or Password is wrong")
                case .invalidEmail:
                    print("Invalid Email address")
                case .wrongPassword:
                    print("Wrong Password")
                default:
                    print(error!.localizedDescription)
                }
                return
            }
            print("Sign in successfully")
        }
    }
    
    @IBAction func handleGoogleSignIn(_ sender: UIButton) {
        GIDSignIn.sharedInstance().signIn()
    }
    
    @IBAction func handleFacebookSignIn(_ sender: UIButton) {
        let loginManager = LoginManager()
        loginManager.logIn(readPermissions: [ .publicProfile, .email ], viewController: self) { loginResult in
            switch loginResult {
            case .failed(let error):
                print(error)
            case .cancelled:
                print("User cancelled login.")
            case .success(let grantedPermissions, let declinedPermissions, let accessToken):
                print("Logged in!")
                print(accessToken.authenticationToken)
                let credential = FacebookAuthProvider.credential(withAccessToken: accessToken.authenticationToken)
                Auth.auth().signIn(with: credential) { (user, error) in
                    if let error = error {
                        // ...
                        return
                    }
                    // User is signed in
                    // ...
                }
            }
        }
        
        
    }
    
    @IBAction func handleForgetPassword(_ sender: UIButton) {
        
        guard let email = emailTextField.text else {
            print("No email provided")
            return
        }
        
        Auth.auth().sendPasswordReset(withEmail: email) { (error) in
            print(error!.localizedDescription)
        }
    }
    
    @IBAction func handleTmpSignOut(_ sender: UIButton) {
        let firebaseAuth = Auth.auth()
        do {
            try firebaseAuth.signOut()
            print("Signed out")
        } catch let signOutError as NSError {
            print ("Error signing out: %@", signOutError)
        }
    }
    
}

@IBDesignable extension UIButton {
    
    @IBInspectable var borderWidth: CGFloat {
        set {
            layer.borderWidth = newValue
        }
        get {
            return layer.borderWidth
        }
    }
    
    @IBInspectable var cornerRadius: CGFloat {
        set {
            layer.cornerRadius = newValue
        }
        get {
            return layer.cornerRadius
        }
    }
    
    @IBInspectable var borderColor: UIColor? {
        set {
            guard let uiColor = newValue else { return }
            layer.borderColor = uiColor.cgColor
        }
        get {
            guard let color = layer.borderColor else { return nil }
            return UIColor(cgColor: color)
        }
    }
}
