//
//  DishListTableViewController.swift
//  WhatToEat
//
//  Created by Alan Jin on 4/17/18.
//  Copyright © 2018 CHEN CHEN. All rights reserved.
//

import UIKit
import os
import Firebase
import FirebaseAuth

class DishListSaveTableViewController: UITableViewController{
    
    let cellSpacingHeight: CGFloat = 20
    let cardBackgroundColor = UIColor(red:0.88, green:0.88, blue:0.88, alpha:1.0)
    let ArchiveURL = Dish.DocumentsDirectory.appendingPathComponent("saveList")
    var userId = Auth.auth().currentUser!.uid
    var dishes = [Dish]()
    private var rawDishesData:[AnyObject] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.tableView.separatorStyle = .none
        
        
        
        if let savedDishes = loadDishes(){
            dishes += savedDishes
        }else{
            loadDefaultMeals()
        }
        let urlString = "https://us-central1-whattoeat-9712f.cloudfunctions.net/getsaveforlater"
        let spinner = Util.displaySpinner(onView: self.view)
        loadDishesList(urlString: urlString , userId: userId){
            DispatchQueue.main.async{
                self.updateDishFromRawDishesData()
                Util.removeSpinner(spinner: spinner)
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
        cell.img.image = dish.photo ?? UIImage(named:"noImage")
        cell.dateLabel.text = dish.extra["date"] as? String
        cell.dishId = dish.dishId
        cell.restInfo = dish.restInfo
        cell.subviews[0].subviews[0].backgroundColor = cardBackgroundColor
        cell.subviews[0].subviews[0].layer.cornerRadius = 10
        
        cell.selectionStyle = UITableViewCellSelectionStyle.none
        
        return cell
    }
    
    
}




extension DishListSaveTableViewController:DishTableViewCellDelegate{
    func didTapDeleteButton(itemId: String) {
        let spinner = Util.displaySpinner(onView: self.view)
        callDeleteAPI(userId: userId, itemId: itemId){
            let urlString = "https://us-central1-whattoeat-9712f.cloudfunctions.net/getsaveforlater"
            
            self.loadDishesList(urlString: urlString , userId: self.userId){
                DispatchQueue.main.async{
                    self.updateDishFromRawDishesData()
                    Util.removeSpinner(spinner: spinner)
                }
            }
        }
    }
    
    func didTapDetailButton(restInfo: [String:AnyObject], dishImage:UIImage, dishId:String) {
        let storyBoard: UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
        let newViewController = storyBoard.instantiateViewController(withIdentifier: "dishDetailViewController") as! DishDetailViewController
        newViewController.restInfo = restInfo
        newViewController.dishImage = dishImage
        newViewController.dishId = dishId
        self.navigationController?.pushViewController(newViewController, animated: true)
        
    }
    
    func didTapRating(itemId: String, rating: Int) {
        print("Do nothing")
    }
}




extension DishListSaveTableViewController{
    
    private func sortRawDishesData(){
        self.rawDishesData = self.rawDishesData.sorted(by: {$0["date"] as! Double > $1["date"] as! Double})
    }
    
    private func loadDefaultMeals() {
        let image1 = UIImage(named: "miga_galbi_ribeye_steak")
        guard let dish1 = Dish(name: "No Dish", photo: image1, rating: 4, dishId:"", restInfo:[:]) else {
            fatalError("Unable to instantiate dish1")
        }
        dishes += [dish1]
    }
    
    private func updateDishFromRawDishesData(){
        self.dishes = [Dish]()
        self.sortRawDishesData()
        for dishData in self.rawDishesData{
            if let dishGeneralInfo = dishData as? [String:AnyObject]{
                let dishId = dishGeneralInfo["dishId"] as! String
                let itemId = dishGeneralInfo["itemId"] as! String
                let date = Util.convertDateToHumanReadable(rawTime: dishGeneralInfo["date"] as! Double)
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
                    let dish = Dish(name: name, photo: photo, rating: 0, dishId:dishId, restInfo:restInfo,extra:extra)
                    self.dishes.append(dish!)
                }
                
            }
        }
        self.saveDishes()
        print(self.dishes.count)
        self.tableView.reloadData()
    }
    
    
    private func loadDishesList(urlString:String,userId:String, withCompletion completion: @escaping ()->()){
        
        let bodyData = ["userId": userId]
        Util.request(httpMethod: "Post", urlString: urlString, body: bodyData as [String : AnyObject]){ returnData in
            
            self.rawDishesData = []
            if let returnList = returnData["dishes"] as? [String: AnyObject] {
                for (itemId, val) in returnList{
                    
                    
                    self.fetchDishInfo(dishId: val["dishId"] as! String, itemId:itemId, date:val["dateCreated"] as! Double){
                        completion()
                    }
                }
            }else{
                completion()
            }
        }
        
    }
    
    
    private func fetchDishInfo(dishId:String, itemId:String,date:Double,  withCompletion completion: @escaping ()->()){
        let urlString =  "https://us-central1-whattoeat-9712f.cloudfunctions.net/dish?key="+dishId
        Util.request(httpMethod: "GET", urlString: urlString, body:[:]){returnData in
            if let dishInfo = returnData["dish"]{
                let dic = ["itemId":itemId, "dishId":dishId, "info":dishInfo,"date":date] as [String : Any]
                self.rawDishesData.append(dic as AnyObject)
                completion()
            }
        }
        
    }
    
    
    private func callDeleteAPI(userId:String, itemId:String, withCompletion completion: @escaping ()->()){
        let urlString = "https://us-central1-whattoeat-9712f.cloudfunctions.net/deleteSave"
        
        let bodyData = [
            "userId": userId,
            "saveId": itemId
            ] as [String : Any]
        
        Util.request(httpMethod: "POST", urlString: urlString, body: bodyData as [String : AnyObject]){_ in
            completion()
        }
        
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
