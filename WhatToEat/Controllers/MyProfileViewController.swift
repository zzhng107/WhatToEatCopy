//
//  MyProfileViewController.swift
//  WhatToEat
//
//  Created by CHEN CHEN on 4/24/18.
//  Copyright © 2018 CHEN CHEN. All rights reserved.
//

import UIKit
import Firebase
import FirebaseStorage

class MyProfileViewController: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    override func viewDidLoad() {
        super.viewDidLoad()
        //        TODO: title not shown
        self.navigationItem.title = "My Profile"
        nameField.isHidden = true
        handleUser()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(true)
        if self.flags["profileImg"]! || self.flags["username"]! || self.flags["tags"]! {
            handleUserInfoUpdateInDatabase()
            self.flags["profileImg"] = false
        }
    }
    
    let nickel = UIColor(red: 136/255, green: 135/255, blue: 135/255, alpha: 1.0)
    let salmon = UIColor(red: 255/255, green: 114/255, blue: 110/255, alpha: 1.0)
    let flora = UIColor(red: 5/255, green: 248/255, blue: 2/255, alpha: 1.0)
    var flags = ["profileImg": false, "tags": false, "username": false]
    
    @IBOutlet weak var userEmail: UILabel!
    @IBOutlet weak var userName: UILabel!
    
    @IBOutlet weak var nameField: UITextField!
    
    @IBOutlet var tags: [UIButton]!

    
    @IBOutlet weak var profileImg: UIImageView! {
        didSet {
            let updateProfileImg = UILongPressGestureRecognizer(target: self, action: #selector(handleSelectProfileImg))
            profileImg.addGestureRecognizer(updateProfileImg)
        }
    }
    
    @objc func handleSelectProfileImg() {
        let picker = UIImagePickerController()
        picker.delegate = self
        picker.allowsEditing = true
        present(picker, animated: true, completion: nil)

    }
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        dismiss(animated: true, completion: nil)
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        var selectedImageFromPicker: UIImage?
        
        if let editedImage = info[UIImagePickerControllerEditedImage] as? UIImage {
            selectedImageFromPicker = editedImage
        } else if let originalImage = info[UIImagePickerControllerOriginalImage] as? UIImage {
            selectedImageFromPicker = originalImage
        }
        if let image = selectedImageFromPicker {
            profileImg.image = image
            self.flags["profileImg"] = true
        }
        dismiss(animated: true, completion: nil)
    }
    
    func handleUserInfoUpdateInDatabase() {
        let user = Auth.auth().currentUser
        if user == nil {
            print("No User!")
            return
        }
        
        let changeRequest = user!.createProfileChangeRequest()
        
        if self.flags["username"]! {
            changeRequest.displayName = userName.text!
            commitChange(changeRequest: changeRequest)
        }
        if self.flags["profileImg"]! {
            let storageRef = Storage.storage().reference()
            let filename = user!.uid + ".png"
            let profileRef = storageRef.child(filename)
            let image = profileImg.image
            if image == nil {
                print ("No image found")
            } else {
                if let uploadData = UIImagePNGRepresentation(image!) {
                    profileRef.putData(uploadData, metadata: nil, completion: {(metadata, error) in
                        if error != nil {
                            print (error!)
                            return
                        }
                        profileRef.downloadURL(completion: {(url, error) in
                            if error != nil {
                                print (error!)
                                return
                            }
                            changeRequest.photoURL = url!
                            self.commitChange(changeRequest: changeRequest)
                        })
                    })
                }
            }
        }
        
        var ref: DatabaseReference!
        ref = Database.database().reference()
        
        if self.flags["tags"]! {
            ref.child("users/\(user!.uid)/tags").setValue(preferenceTags)
        }
    }
    
    func commitChange(changeRequest: UserProfileChangeRequest) {
        changeRequest.commitChanges { (error) in
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
            userName.text = inputName
            self.flags["username"] = true
        }
        userName.isHidden = !userName.isHidden
        nameField.isHidden = !nameField.isHidden
    }
    
    var preferenceTags = ["Chinese": 5, "American": 5, "Korean": 5, "Japanese": 5, "French": 5, "Italian": 5, "Indian": 5, "Mexican": 5, "Spicy": 5, "Beef": 5, "Pork": 5, "Chicken": 5, "Vegetarian": 5, "Vegan": 5]
    
    // TODO: see if can user a listener instead
    func handleUser() {
        var ref: DatabaseReference!
        ref = Database.database().reference()
        
        if let user = Auth.auth().currentUser {
            // User is signed in.
            let email = user.email
            let name = user.displayName
            let photoURL = user.photoURL
            if (photoURL != nil) {
                let data = try? Data(contentsOf: photoURL!)
                if data != nil {
                    profileImg.image = UIImage(data: data!)
                } else {
                    profileImg.image = UIImage(named: "user_avatar")
                }
            } else {
                profileImg.image = UIImage(named: "user_avatar")
            }
            profileImg.setRounded()
            userEmail.text = email
            userName.text = name
            print (ref.child("users").child(user.uid).child("tags"))
            ref.child("users").child(user.uid).observeSingleEvent(of: .value, with: { (snapshot) in
                // Get user value
                let value = snapshot.value as? NSDictionary
                let tags = value?["tags"]
                self.preferenceTags = tags! as! [String : Int]
                self.setTagBackgroundColors()
                print(self.preferenceTags)
            }) { (error) in
                print(error.localizedDescription)
            }
            print ("user found")
        } else {
            // No user is signed in.
            print ("no user")
        }
    }
    
    func setTagBackgroundColors() {
        for tag in tags! {
            let tagNameOriginal = tag.currentTitle!
            let tagName = tagNameOriginal.trimmingCharacters(in: .whitespacesAndNewlines)
            if self.preferenceTags[tagName] == 5 {
                tag.backgroundColor = nickel
            } else if self.preferenceTags[tagName] == 10 {
                tag.backgroundColor = flora
            } else if self.preferenceTags[tagName] == 0 {
                tag.backgroundColor = salmon
            }
        }
    }

    @IBAction func pickTags(_ sender: UIButton) {
        let tagNameOriginal = sender.currentTitle!
        let tagName = tagNameOriginal.trimmingCharacters(in: .whitespacesAndNewlines)
        if sender.backgroundColor == nickel {
            sender.backgroundColor = flora
            self.preferenceTags[tagName] = 10
        } else if sender.backgroundColor! == flora {
            sender.backgroundColor = salmon
            self.preferenceTags[tagName] = 0
        } else if sender.backgroundColor! == salmon {
            sender.backgroundColor = nickel
            self.preferenceTags[tagName] = 5
        }
        self.flags["tags"] = true
    }
    
}

// Referennce: https://stackoverflow.com/questions/24231680/loading-downloading-image-from-url-on-swift

extension UIImageView {
    func downloadedFrom(url: URL, contentMode mode: UIViewContentMode = .scaleAspectFit) {
        contentMode = mode
        URLSession.shared.dataTask(with: url) { data, response, error in
            guard
                let httpURLResponse = response as? HTTPURLResponse, httpURLResponse.statusCode == 200,
                let mimeType = response?.mimeType, mimeType.hasPrefix("image"),
                let data = data, error == nil,
                let image = UIImage(data: data)
                else { return }
            DispatchQueue.main.async() {
                self.image = image
            }
            }.resume()
    }
    func downloadedFrom(link: String, contentMode mode: UIViewContentMode = .scaleAspectFit) {
        guard let url = URL(string: link) else { return }
        downloadedFrom(url: url, contentMode: mode)
    }
    func setRounded() {
        let radius = self.bounds.size.width / 2
        self.layer.cornerRadius = radius
        self.layer.masksToBounds = true
    }
}
