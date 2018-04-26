//
//  DishListTableViewController.swift
//  WhatToEat
//
//  Created by Alan Jin on 4/17/18.
//  Copyright © 2018 CHEN CHEN. All rights reserved.
//

import UIKit
import os

class DishListTableViewController: UITableViewController{

    let cellSpacingHeight: CGFloat = 20
    let cardBackgroundColor = UIColor(red:0.88, green:0.88, blue:0.88, alpha:1.0)
    
    let ArchiveURL = Dish.DocumentsDirectory.appendingPathComponent("historyList")
    var userId = "4h2AcaIwckR2vzxMMuPENOq8KCg2"
    var dishes = [Dish]()
    
    private var rawDishesData:[AnyObject] = []

    override func viewDidLoad() {
        super.viewDidLoad()
        self.tableView.separatorStyle = .none

//        if let savedDishes = loadDishes(){
//            dishes += savedDishes
//        }else{
//            loadDefaultMeals()
//        }
        let urlString = "https://us-central1-whattoeat-9712f.cloudfunctions.net/gethist"
        loadDishesList(urlString: urlString , userId: userId){
            DispatchQueue.main.async{
                self.dishes = [Dish]()
                for dishData in self.rawDishesData{
                    if let dishGeneralInfo = dishData as? [String:AnyObject]{
                        let dishId = dishGeneralInfo["dishId"] as! String
                        let itemId = dishGeneralInfo["itemId"] as! String
                        let rating = dishGeneralInfo["rating"] as! Int
                        let date = dishGeneralInfo["date"] as! String
                        if let dishDetailInfo = dishGeneralInfo["info"] as? [String:AnyObject]{
                            let imgUrl = dishDetailInfo["imgUrl"] as! String
                            let url = URL(string: imgUrl)!
                            let data = try? Data(contentsOf: url)
                            var photo:UIImage? = nil
                            if let imageData = data{
                                photo = UIImage(data: imageData)
                            }
                            let name = dishDetailInfo["name"] as! String
                            let extra = ["itemId":itemId, "date":date]  as [String : AnyObject]
                            let restInfo = dishDetailInfo["restaurant"] as! [String : AnyObject]
                            let dish = Dish(name: name, photo: photo, rating: rating, dishId:dishId, restInfo:restInfo,extra:extra)
                            self.dishes.append(dish!)
                        }
                       
                    }
                }
                self.saveDishes()
                self.tableView.reloadData()
            }
        }
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return dishes.count
    }
    
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cellIdentifier = "DishTableViewCell"
        guard let cell = tableView.dequeueReusableCell(withIdentifier: cellIdentifier, for: indexPath) as? DishTableViewCell  else {
            fatalError("The dequeued cell is not an instance of DishTableViewCell.")
        }
        let dish = dishes[indexPath.row]
        cell.delegate = self
        cell.dishNameLabel.text = dish.name
        cell.itemId = dish.extra["itemId"] as? String
        cell.img.image = dish.photo
        cell.rateControl.rating = dish.rating
        cell.dateLabel.text = dish.extra["date"] as? String
        cell.dishId = dish.dishId
        cell.restInfo = dish.restInfo
        cell.subviews[0].subviews[0].backgroundColor = cardBackgroundColor
        cell.subviews[0].subviews[0].layer.cornerRadius = 10
        
        cell.selectionStyle = UITableViewCellSelectionStyle.none
        
        return cell
    }

   
}




extension DishListTableViewController:DishTableViewCellDelegate{
    func didTapDetailButton(restInfo: [String:AnyObject], dishImage:UIImage) {
        let storyBoard: UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
        let newViewController = storyBoard.instantiateViewController(withIdentifier: "dishDetailViewController") as! DishDetailViewController
        newViewController.restInfo = restInfo
        newViewController.dishImage = dishImage
        self.navigationController?.pushViewController(newViewController, animated: true)
       
    }
    
    func didTapRating(itemId: String, rating: Int) {
        callRateAPI(userId: userId,itemId: itemId, rating: rating)
    }
}




extension DishListTableViewController{
    private func loadDefaultMeals() {
        let image1 = UIImage(named: "miga_galbi_ribeye_steak")
        guard let dish1 = Dish(name: "No Dish", photo: image1, rating: 4, dishId:"", restInfo:[:]) else {
            fatalError("Unable to instantiate dish1")
        }
        dishes += [dish1]
    }
    
    
    
    
    private func loadDishesList(urlString:String,userId:String, withCompletion completion: @escaping ()->()){
        
        let url = URL(string: urlString)!
        var request = URLRequest(url: url)
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        request.httpMethod = "POST"
        let bodyData = [
            "userId": userId,
            ]
        do{
            request.httpBody = try JSONSerialization.data(withJSONObject: bodyData, options: .prettyPrinted)
        }catch{
            print("error in first catch")
        }
        
        let task = URLSession.shared.dataTask(with: request as URLRequest) { data, response, error in
            guard let data = data, error == nil else{
                print("error=\(error!)")
                return
            }
            
            do{
                if let output = try JSONSerialization.jsonObject(with: data, options: .mutableContainers) as? [String: AnyObject] {
                    for (itemId, val) in (output["dishes"] as? [String: AnyObject])!{
                        
                        let nsdate = NSDate(timeIntervalSince1970: (val["dateCreated"] as! Double)/1000) as Date
                        let dateFormatter = DateFormatter()
                        dateFormatter.dateFormat = "MM/dd/yyyy HH:mm"
                        let date = dateFormatter.string(from: nsdate)
                        
                        self.fetchDishInfo(dishId: val["dishId"] as! String, itemId:itemId, date:date, rating:val["rating"] as! Int){
                            completion()
                        }
                    }
                    
                }
            }catch{
                print("error in second catch")
            }
        }
        task.resume()
    }
    
    
    
    
    
    private func fetchDishInfo(dishId:String, itemId:String,date:String, rating:Int, withCompletion completion: @escaping ()->()){
        let url = URL(string: "https://us-central1-whattoeat-9712f.cloudfunctions.net/dish?key="+dishId)!
        var request = URLRequest(url: url)
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        request.httpMethod = "GET"
        
        let task = URLSession.shared.dataTask(with: request as URLRequest) { data, response, error in
            guard let data = data, error == nil else{
                print("error=\(error!)")
                return
            }
            
            do{
                if let output = try JSONSerialization.jsonObject(with: data, options: .mutableContainers) as? [String: AnyObject] {
                    if let dishInfo = output["dish"]{
                       
                        let dic = ["itemId":itemId, "dishId":dishId, "info":dishInfo,"date":date, "rating":rating] as [String : Any]
                        self.rawDishesData.append(dic as AnyObject)
                        completion()
                    }
                }
            }catch{
                print("error in second catch")
            }
        }
        task.resume()
    }
    
    
    
    private func callRateAPI(userId:String, itemId:String, rating: Int){
        let url = URL(string: "https://us-central1-whattoeat-9712f.cloudfunctions.net/ratedish")!
        var request = URLRequest(url: url)
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        request.httpMethod = "POST"
        let bodyData = [
            "userId": userId,
            "histId": itemId,
            "rating": rating
            ] as [String : Any]
        
        do{
            request.httpBody = try JSONSerialization.data(withJSONObject: bodyData, options: .prettyPrinted)
        }catch{
            print("error in first catch")
        }
        
        let task = URLSession.shared.dataTask(with: request as URLRequest) { data, response, error in
            guard let data = data, error == nil else{
                print("error=\(error!)")
                return
            }
            
            do{
               print("done")
            }
        }
        task.resume()
    }
    
    private func saveDishes() {
        let isSuccessfulSave = NSKeyedArchiver.archiveRootObject(dishes, toFile: ArchiveURL.path)
        if isSuccessfulSave {
            os_log("Meals successfully saved.", log: OSLog.default, type: .debug)
        } else {
            os_log("Failed to save meals...", log: OSLog.default, type: .error)
        }
    }
    
    private func loadDishes() -> [Dish]? {
        return NSKeyedUnarchiver.unarchiveObject(withFile: ArchiveURL.path) as? [Dish]
    }
}
