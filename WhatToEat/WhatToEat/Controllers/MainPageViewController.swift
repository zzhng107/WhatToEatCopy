//
//  MainPageViewController.swift
//  WhatToEat
//
//  Created by Zhiwei Zhang on 4/11/18.
//  Copyright © 2018 CHEN CHEN. All rights reserved.
//

import Koloda
import os
import Firebase

fileprivate var dataSource: Array<(key: String, value: AnyObject)> = []
fileprivate var imgSource: [UIImage] = []
private var numberOfCards: Int = 20

class MyKolodaViewController: UIViewController {
    
    var filterData:[String : Any] = [
        "price":[false, false, false, false],
        "rating":[false, false, false, false, false],
        "distance":10
        ]
    
    //    class Meal: NSObject, NSCoding {
    struct PropertyKey {
        static let name = "name"
        static let photo = "photo"
        static let rating = "rating"
    }
    //    }
    
    //    func encode(with aCoder: NSCoder) {
    //        aCoder.encode(name, forKey: PropertyKey.name)
    //        aCoder.encode(photo, forKey: PropertyKey.photo)
    //        aCoder.encode(rating, forKey: PropertyKey.rating)
    //    }
    
    
    static let DocumentsDirectory = FileManager().urls(for: .documentDirectory, in: .userDomainMask).first!
    static let ArchiveURL = DocumentsDirectory.appendingPathComponent("pendingDishes")
    
    @IBOutlet weak var sideBar: UIStackView!
    @IBOutlet weak var kolodaView: KolodaView!
    
    @IBOutlet weak var go: UIButton!
    @IBOutlet weak var like: UIButton!
    @IBOutlet weak var dislike: UIButton!
    
    @IBAction func likeAction(_ sender: Any) {
        //        if let dishId = dataSource[kolodaView.currentCardIndex] as? [String: AnyObject]{
        bookMark("5a2dbb53af64cc0021027198", dataSource[kolodaView.currentCardIndex].key)
        //        }else{
        //            print("error in likeAction")
        //        }
        kolodaView?.swipe(.right)
    }
    @IBAction func dislikeAction(_ sender: Any) {
        kolodaView?.swipe(.left)
    }
    @IBAction func goAction(_ sender: Any) {
        //        if let dishId = dataSource[kolodaView.currentCardIndex] as? [String: AnyObject]{
        go("5a2dbb53af64cc0021027198", dataSource[kolodaView.currentCardIndex].key)
        //        }else{
        //            print("error in likeAction")
        //        }
        kolodaView?.swipe(.left)
    }
    
    var sideBarShow = false
    @IBOutlet weak var sideBarLeading: NSLayoutConstraint!
    @IBAction func sideBarButton(_ sender: Any) {
        sideBarShow = !sideBarShow
        if sideBarShow {
            sideBarLeading.constant = 0
        }else{
            sideBarLeading.constant = -175
        }
        UIView.animate(withDuration: 0.2, delay: 0.0, options: .curveEaseIn, animations:{
            self.view.layoutIfNeeded()
        })
    }
    
    
    @IBAction func handleLogout(_ sender: UIButton) {
        let firebaseAuth = Auth.auth()
        do {
            try firebaseAuth.signOut()
            print("Signed out")
        } catch let signOutError as NSError {
            print ("Error signing out: %@", signOutError)
        }
    }
    
    
    func bookMark(_ userId: String, _ dishId: String){
        let url = URL(string: "https://us-central1-whattoeat-9712f.cloudfunctions.net/saveforlater")!
        var request = URLRequest(url: url)
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        request.httpMethod = "POST"
        let data = [
            "userId":userId,
            "dishId":dishId
        ]
        
        do{
            request.httpBody = try JSONSerialization.data(withJSONObject: data, options: .prettyPrinted)
        }catch{
            print("error in first catch")
            return
        }
        
        let task = URLSession.shared.dataTask(with: request as URLRequest){ data, response, error in
            guard error == nil else{
                print("error=\(String(describing: error))")
                return
            }
        }
        task.resume()
    }
    
    func go(_ userId: String, _ dishId: String){
        let url = URL(string: "https://us-central1-whattoeat-9712f.cloudfunctions.net/savehist")!
        var request = URLRequest(url: url)
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        request.httpMethod = "POST"
        let data = [
            "userId":userId,
            "dishId":dishId
        ]
        
        do{
            request.httpBody = try JSONSerialization.data(withJSONObject: data, options: .prettyPrinted)
        }catch{
            print("error in first catch")
            return
        }
        
        let task = URLSession.shared.dataTask(with: request as URLRequest){ data, response, error in
            guard error == nil else{
                print("error=\(String(describing: error))")
                return
            }
        }
        task.resume()
    }
    
    func json(from object:Any) -> String? {
        guard let data = try? JSONSerialization.data(withJSONObject: object, options: []) else {
            return nil
        }
        return String(data: data, encoding: String.Encoding.utf8)
    }
    
    
    func loadDishes(_ urlString: String, completion: @escaping ()->()){
        
        let dishes = NSKeyedUnarchiver.unarchiveObject(withFile: MyKolodaViewController.ArchiveURL.path) as? Array<(key: String, value: AnyObject)>
        
        if (dishes != nil) {
            dataSource = dishes!
            completion()
        }
        
        let url = URL(string: urlString)!
        var request = URLRequest(url: url)
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        request.httpMethod = "POST"
        let userId = [
            "userId": "5a2dbb53af64cc0021027198",
            ]
        do{
            request.httpBody = try JSONSerialization.data(withJSONObject: userId, options: .prettyPrinted)
        }catch{
            print("error in first catch")
            return
        }
        
        let task = URLSession.shared.dataTask(with: request as URLRequest) { data, response, error in
            guard let data = data, error == nil else{
                print("error=\(String(describing: error))")
                return
            }
            
            do{
                if let response = try JSONSerialization.jsonObject(with: data, options: .mutableContainers) as? [String: [String:AnyObject]] {
                    
                    var tempDataSource = Array(response["dishes"]!)
                    tempDataSource.sort(by: { $0.value["score"] as! Int > $1.value["score"] as! Int })
                    
                    //Store to local
                    //                    let isSuccessfulSave =  NSKeyedArchiver.archiveRootObject(tempDataSource, toFile: MyKolodaViewController.ArchiveURL.path)
                    //                    if isSuccessfulSave{
                    //                        os_log("Meals successfully saved.", log: OSLog.default, type: .debug)
                    //                    } else {
                    //                        os_log("Failed to save meals...", log: OSLog.default, type: .error)
                    //                    }
                    
                    dataSource = tempDataSource
                    
                    completion()
                }
            }catch{
                print("error in second catch")
                return
            }
        }
        task.resume()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
    }
    
    // MARK: Lifecycle
    override func viewDidLoad() {
        
        super.viewDidLoad()
        self.modalTransitionStyle = UIModalTransitionStyle.flipHorizontal
        let sv = UIViewController.displaySpinner(onView: self.view)
        self.loadDishes( "https://us-central1-whattoeat-9712f.cloudfunctions.net/dishes" ) { () in
            
            var array: [UIImage] = []
            //                let urls = dataSource.map({
            //                    (key: String, value: AnyObject) -> URL in
            //                    return URL(string: value["imgUrl"])!
            //                })
            
            //                let urls = dataSource.map({ (key: String, value: AnyObject) -> URL in
            //                    return URL(string: value["imgUrl"] as! String)!
            //                })
            
            let urls = dataSource.map({ (_, val) -> URL in
                return URL(string: val["imgUrl"] as! String)!
            })
            
            for index in 0..<numberOfCards {
                
                let url = urls[index]
                let data = try? Data(contentsOf: url)
                
                if let imageData = data {
                    let image = UIImage(data: imageData)
                    array.append(image!)
                }
            }
            
            imgSource = array
            
            DispatchQueue.main.async(){
                UIViewController.removeSpinner(spinner: sv)
                self.kolodaView.dataSource = self
                self.kolodaView.delegate = self
            }
            
            
        }
    }
}


extension MyKolodaViewController: KolodaViewDelegate {
    func kolodaDidRunOutOfCards(_ koloda: KolodaView) {
        koloda.reloadData()
    }
    
    func koloda(_ koloda: KolodaView, didSelectCardAt index: Int) {
        
//        let detail = storyboard?.instantiateViewController(withIdentifier: "detail") as! TempDetailPageViewController
//        detail.dishNamePassed = dataSource[kolodaView.currentCardIndex].value["name"] as! String
//        navigationController?.pushViewController(detail, animated: true)
//        
//        //        UIApplication.shared.openURL(URL(string: "https://google.com")!)
    }
}

extension MyKolodaViewController: KolodaViewDataSource {
    
    func kolodaNumberOfCards(_ koloda:KolodaView) -> Int {
        return dataSource.count
    }
    
    func kolodaSpeedThatCardShouldDrag(_ koloda: KolodaView) -> DragSpeed {
        return .default
    }
    
    func koloda(_ koloda: KolodaView, viewForCardAt index: Int) -> UIView {
        let out = UIImageView(image: imgSource[Int(index)])
        
        out.layer.cornerRadius = 8.0
        out.clipsToBounds = true
        out.contentMode = .scaleAspectFill;
        
        return out
    }
    
    //    func koloda(_ koloda: KolodaView, viewForCardOverlayAt index: Int) -> OverlayView? {
    //        return Bundle.main.loadNibNamed("OverlayView", owner: self, options: nil)?[0] as? OverlayView
    //    }
}


extension UIViewController {
    class func displaySpinner(onView : UIView) -> UIView {
        let spinnerView = UIView.init(frame: onView.bounds)
        spinnerView.backgroundColor = UIColor.init(red: 0.5, green: 0.5, blue: 0.5, alpha: 0.5)
        let ai = UIActivityIndicatorView.init(activityIndicatorStyle: .whiteLarge)
        ai.startAnimating()
        ai.center = spinnerView.center
        
        DispatchQueue.main.async {
            spinnerView.addSubview(ai)
            onView.addSubview(spinnerView)
        }
        
        return spinnerView
    }
    
    class func removeSpinner(spinner :UIView) {
        DispatchQueue.main.async {
            spinner.removeFromSuperview()
        }
    }
}
