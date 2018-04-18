//
//  DishListTableViewController.swift
//  WhatToEat
//
//  Created by Alan Jin on 4/17/18.
//  Copyright © 2018 CHEN CHEN. All rights reserved.
//

import UIKit

class DishListTableViewController: UITableViewController {

    var dishes = [Dish]()
    let cellSpacingHeight: CGFloat = 20
    let cardBackgroundColor = UIColor(red:0.88, green:0.88, blue:0.88, alpha:1.0)
    private func loadSampleMeals() {
        let image1 = UIImage(named: "LaoSiChuan_chill_chicken")
        let image2 = UIImage(named: "miga_galbi_ribeye_steak")
        let image3 = UIImage(named: "miga_sushi")
       
        guard let dish1 = Dish(name: "Chill Chicken", photo: image1, rating: 4) else {
            fatalError("Unable to instantiate dish1")
        }
        
        guard let dish2 = Dish(name: "Ribeye Steak", photo: image2, rating: 5) else {
            fatalError("Unable to instantiate dish2")
        }
        
        guard let dish3 = Dish(name: "Miga Sushi", photo: image3, rating: 3) else {
            fatalError("Unable to instantiate dish3")
        }
        dishes += [dish1, dish2, dish3]
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.tableView.separatorStyle = .none

        loadSampleMeals()
        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem
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
        cell.dishNameLabel.text = dish.name
        cell.img.image = dish.photo
        cell.rateControl.rating = dish.rating
      
        cell.subviews[0].subviews[0].backgroundColor = cardBackgroundColor
        cell.subviews[0].subviews[0].layer.cornerRadius = 10
        
        cell.selectionStyle = UITableViewCellSelectionStyle.none
        
        return cell
    }

}
