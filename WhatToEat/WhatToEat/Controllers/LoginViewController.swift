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

class LoginViewController: UIViewController, GIDSignInDelegate, GIDSignInUIDelegate {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        GIDSignIn.sharedInstance().delegate = self
        GIDSignIn.sharedInstance().uiDelegate = self
        //        GIDSignIn.sharedInstance().signIn()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        self.navigationController?.setNavigationBarHidden(true, animated: animated)
        super.viewWillAppear(animated)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        self.navigationController?.setNavigationBarHidden(false, animated: animated)
        super.viewWillDisappear(animated)
    }
    
    @IBOutlet weak var emailTextField: UnderlinedTextField!
    @IBOutlet weak var passwordTextField: UnderlinedTextField!
    
    @IBAction func handleSignUp(_ sender: UIButton) {
        guard let email = emailTextField.text else {
            let title = "No Email provided"
            let message = "Provide your Email address to sign up"
            let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: NSLocalizedString("OK", comment: "Default action"), style: .default, handler: { _ in
                NSLog("The \"\(title)\" alert occured.")
            }))
            self.present(alert, animated: true, completion: nil)
            print("No email provided")
            return
        }
        guard let password = passwordTextField.text else {
            let title = "No Password provided"
            let message = "Provide your password to sign up"
            let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: NSLocalizedString("OK", comment: "Default action"), style: .default, handler: { _ in
                NSLog("The \"\(title)\" alert occured.")
            }))
            self.present(alert, animated: true, completion: nil)
            print("No password provided")
            return
        }
        Auth.auth().createUser(withEmail: email, password: password) { (user, error) in
            if error != nil {
                switch AuthErrorCode(rawValue: error!._code)! {
                case .missingEmail:
                    let title = "No Email provided"
                    let message = "Provide your Email address to sign up"
                    let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
                    alert.addAction(UIAlertAction(title: NSLocalizedString("OK", comment: "Default action"), style: .default, handler: { _ in
                        NSLog("The \"\(title)\" alert occured.")
                    }))
                    self.present(alert, animated: true, completion: nil)
                    print("No Email provided")
                case .invalidEmail:
                    let title = "Invalid Email address"
                    let message = "Your provided Email address is not valid."
                    let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
                    alert.addAction(UIAlertAction(title: NSLocalizedString("OK", comment: "Default action"), style: .default, handler: { _ in
                        NSLog("The \"\(title)\" alert occured.")
                    }))
                    self.present(alert, animated: true, completion: nil)
                    print("Invalid Email address")
                case .weakPassword:
                    let title = "Short Password"
                    let message = "Password must be at least 6 characters."
                    let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
                    alert.addAction(UIAlertAction(title: NSLocalizedString("OK", comment: "Default action"), style: .default, handler: { _ in
                        NSLog("The \"\(title)\" alert occured.")
                    }))
                    self.present(alert, animated: true, completion: nil)
                    print("Password must be at least 6 characters")
                case .emailAlreadyInUse:
                    let title = "Email already in use"
                    let message = "This Email address is already signed up."
                    let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
                    alert.addAction(UIAlertAction(title: NSLocalizedString("OK", comment: "Default action"), style: .default, handler: { _ in
                        NSLog("The \"\(title)\" alert occured.")
                    }))
                    self.present(alert, animated: true, completion: nil)
                    print("Email already in use")
                default:
                    let title = error!.localizedDescription
                    let message = error!.localizedDescription
                    let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
                    alert.addAction(UIAlertAction(title: NSLocalizedString("OK", comment: "Default action"), style: .default, handler: { _ in
                        NSLog("The \"\(title)\" alert occured.")
                    }))
                    self.present(alert, animated: true, completion: nil)
                    print(error!.localizedDescription)
                }
                return
            }
            
            print("Sign up successfully")
            
            let title = "Sign Up Successful"
            let message = "You have successfully signed up."
            let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: NSLocalizedString("Continue", comment: "Default action"), style: .default, handler: { _ in
                NSLog("The \"\(title)\" alert occured.")
                self.signInNavigate(user)
            }))
            self.present(alert, animated: true, completion: nil)
//            self.signInNavigate(user)
        }
    }
    
    @IBAction func handleSignIn(_ sender: UIButton) {
        guard let email = emailTextField.text else {
            let title = "No Email provided"
            let message = "Provide your Email address to sign in"
            let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: NSLocalizedString("OK", comment: "Default action"), style: .default, handler: { _ in
                NSLog("The \"\(title)\" alert occured.")
            }))
            self.present(alert, animated: true, completion: nil)
            print("No email provided")
            return
        }
        guard let password = passwordTextField.text else {
            let title = "No Password provided"
            let message = "Provide your password to sign in"
            let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: NSLocalizedString("OK", comment: "Default action"), style: .default, handler: { _ in
                NSLog("The \"\(title)\" alert occured.")
            }))
            self.present(alert, animated: true, completion: nil)
            print("No password provided")
            return
        }
        Auth.auth().signIn(withEmail: email, password: password) { (user, error) in
            if error != nil {
                switch AuthErrorCode(rawValue: error!._code)! {
                case .missingEmail:
                    let title = "No Email provided"
                    let message = "Provide your Email address to sign in"
                    let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
                    alert.addAction(UIAlertAction(title: NSLocalizedString("OK", comment: "Default action"), style: .default, handler: { _ in
                        NSLog("The \"\(title)\" alert occured.")
                    }))
                    self.present(alert, animated: true, completion: nil)
                    print("No Email provided")
                case .userNotFound:
                    let title = "No User found"
                    let message = "There is no account associate with this Email address."
                    let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
                    alert.addAction(UIAlertAction(title: NSLocalizedString("OK", comment: "Default action"), style: .default, handler: { _ in
                        NSLog("The \"\(title)\" alert occured.")
                    }))
                    self.present(alert, animated: true, completion: nil)
                    print("No User Found")
                case .invalidEmail:
                    let title = "Invalid Email address"
                    let message = "Your Email address is not valid."
                    let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
                    alert.addAction(UIAlertAction(title: NSLocalizedString("OK", comment: "Default action"), style: .default, handler: { _ in
                        NSLog("The \"\(title)\" alert occured.")
                    }))
                    self.present(alert, animated: true, completion: nil)
                    print("Invalid Email address")
                case .wrongPassword:
                    let title = "Wrong Password"
                    let message = "Your password is incorrect for this Email address"
                    let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
                    alert.addAction(UIAlertAction(title: NSLocalizedString("OK", comment: "Default action"), style: .default, handler: { _ in
                        NSLog("The \"\(title)\" alert occured.")
                    }))
                    self.present(alert, animated: true, completion: nil)
                    print("Wrong Password")
                default:
                    let title = error!.localizedDescription
                    let message = error!.localizedDescription
                    let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
                    alert.addAction(UIAlertAction(title: NSLocalizedString("OK", comment: "Default action"), style: .default, handler: { _ in
                        NSLog("The \"\(title)\" alert occured.")
                    }))
                    self.present(alert, animated: true, completion: nil)
                    print(error!.localizedDescription)
                }
                return
            }
            print("Sign in successfully")
            self.signInNavigate(user)
        }
    }
    
    func sign(_ signIn: GIDSignIn!, didSignInFor user: GIDGoogleUser!, withError error: Error!) {
        // ...
        if error != nil {
            let title = "Something Went Wrong"
            let message = error!.localizedDescription
            let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: NSLocalizedString("OK", comment: "Default action"), style: .default, handler: { _ in
                NSLog("The \"\(title)\" alert occured.")
            }))
            self.present(alert, animated: true, completion: nil)
            print(error!.localizedDescription)
            return
        }
        guard let authentication = user.authentication else { return }
        let credential = GoogleAuthProvider.credential(withIDToken: authentication.idToken,
                                                       accessToken: authentication.accessToken)
        Auth.auth().signIn(with: credential) { (user, error) in
            if let error = error {
                let title = "Something Went Wrong"
                let message = error.localizedDescription
                let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
                alert.addAction(UIAlertAction(title: NSLocalizedString("OK", comment: "Default action"), style: .default, handler: { _ in
                    NSLog("The \"\(title)\" alert occured.")
                }))
                self.present(alert, animated: true, completion: nil)
                print(error.localizedDescription)
                return
            }
            print("Successfully logged in view google")
            // User is signed in
            self.signInNavigate(user)
        }
        
    }
    
    func sign(_ signIn: GIDSignIn!, didDisconnectWith user: GIDGoogleUser!, withError error: Error!) {
        // Perform any operations when the user disconnects from app here.
        // ...
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
            case .success(let _, let _, let accessToken):
                print("Logged in!")
                print(accessToken.authenticationToken)
                let credential = FacebookAuthProvider.credential(withAccessToken: accessToken.authenticationToken)
                Auth.auth().signIn(with: credential) { (user, error) in
                    if let error = error {
                        let title = "Something Went Wrong"
                        let message = error.localizedDescription
                        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
                        alert.addAction(UIAlertAction(title: NSLocalizedString("OK", comment: "Default action"), style: .default, handler: { _ in
                            NSLog("The \"\(title)\" alert occured.")
                        }))
                        self.present(alert, animated: true, completion: nil)
                        print(error.localizedDescription)
                        return
                    }
                    // User is signed in
                    self.signInNavigate(user)
                }
            }
        }
        
        
    }
    
    @IBAction func handleForgetPassword(_ sender: UIButton) {
        
        guard let email = emailTextField.text else {
            print("No email provided")
            let title = "No Email provided"
            let message = "Provide your Email address to sign in"
            let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: NSLocalizedString("OK", comment: "Default action"), style: .default, handler: { _ in
                NSLog("The \"\(title)\" alert occured.")
            }))
            self.present(alert, animated: true, completion: nil)
            return
        }
        
        Auth.auth().sendPasswordReset(withEmail: email) { (error) in
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
            let title = "Reset Email Sent"
            let message = "An email with instructions to reset your password has been sent to your provided email address"
            let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: NSLocalizedString("OK", comment: "Default action"), style: .default, handler: { _ in
                NSLog("The \"\(title)\" alert occured.")
            }))
            self.present(alert, animated: true, completion: nil)
        }
    }
    
    func signInNavigate(_ user: User?) {
//        let user = user!
        guard (user != nil) else {
            print ("no user object.")
            return
        }
//        let user = user!
        self.performSegue(withIdentifier: "login", sender: self)
    }
    
//    @IBAction func handleTmpSignOut(_ sender: UIButton) {
//        let firebaseAuth = Auth.auth()
//        do {
//            try firebaseAuth.signOut()
//            print("Signed out")
//        } catch let signOutError as NSError {
//            print ("Error signing out: %@", signOutError)
//        }
//    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "login" {
            
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
