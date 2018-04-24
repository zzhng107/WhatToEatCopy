//
//  MainPageViewController.swift
//  WhatToEat
//
//  Created by Zhiwei Zhang on 4/11/18.
//  Copyright © 2018 CHEN CHEN. All rights reserved.
//

import Koloda

fileprivate var dataSource: [UIImage] = []
private var numberOfCards: Int = 20

private var imgList: [String] = []

class MyKolodaViewController: UIViewController {
    
    @IBOutlet weak var sideBar: UIStackView!
    @IBOutlet weak var kolodaView: KolodaView!
    
    @IBOutlet weak var go: UIButton!
    @IBOutlet weak var like: UIButton!
    @IBOutlet weak var dislike: UIButton!
    @IBAction func likeAction(_ sender: Any) {
        kolodaView?.swipe(.right)
    }
    @IBAction func dislikeAction(_ sender: Any) {
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
    
    
    
    
    
    
    func loadDishes(_ urlString: String, withCompletion completion: @escaping ()->()) {
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
        }
        
        let task = URLSession.shared.dataTask(with: request as URLRequest) { data, response, error in
            guard let data = data, error == nil else{
                print("error=\(error)")
                return
            }
            
            do{
                if let output = try JSONSerialization.jsonObject(with: data, options: .mutableContainers) as? [String: AnyObject] {
                    for (_, val) in (output["dishes"] as? [String: AnyObject])!{
                        imgList.append(val["imgUrl"] as! String)
                    }
                    completion()
                }
            }catch{
                print("error in second catch")
            }
        }
        task.resume()
        
    }
    
    // MARK: Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        self.modalTransitionStyle = UIModalTransitionStyle.flipHorizontal
        
        
        DispatchQueue.global(qos: .background).async {
            
            
            DispatchQueue.main.async {
                // Run UI Updates or call completion block
            }
        }
        
        loadDishes("https://us-central1-whattoeat-9712f.cloudfunctions.net/dishes"){()->() in
            var array: [UIImage] = []
            
            let urls = imgList.map({
                (url: String) -> URL in
                return URL(string: url)!
            })
            
            for index in 0..<numberOfCards {
                
                let url = urls[index]
                let data = try? Data(contentsOf: url)
                
                if let imageData = data {
                    let image = UIImage(data: imageData)
                    array.append(image!)
                }
            }
            dataSource = array
            print(dataSource)
            
            self.kolodaView.dataSource = self
            self.kolodaView.delegate = self
        }
        
        
        
        
    }
    
    
    
    
    
}


extension MyKolodaViewController: KolodaViewDelegate {
    func kolodaDidRunOutOfCards(_ koloda: KolodaView) {
        koloda.reloadData()
    }
    
    func koloda(_ koloda: KolodaView, didSelectCardAt index: Int) {
        UIApplication.shared.openURL(URL(string: "https://google.com")!)
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
        let out = UIImageView(image: dataSource[Int(index)])
        
        out.layer.cornerRadius = 8.0
        out.clipsToBounds = true
        out.contentMode = .scaleAspectFill;
        
        print("img loaded")
        
        return out
    }
    
    //    func koloda(_ koloda: KolodaView, viewForCardOverlayAt index: Int) -> OverlayView? {
    //        return Bundle.main.loadNibNamed("OverlayView", owner: self, options: nil)?[0] as? OverlayView
    //    }
}
