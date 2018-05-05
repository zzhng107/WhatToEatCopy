//
//  DishTableViewCell.swift
//  WhatToEat
//
//  Created by Alan Jin on 4/17/18.
//  Copyright © 2018 CHEN CHEN. All rights reserved.
//

import UIKit

protocol DishTableViewCellDelegate{
    func didTapRating(itemId: String,rating: Int)
    func didTapDetailButton(restInfo:[String:AnyObject], dishImage:UIImage,dishId:String)
    func didTapDeleteButton(itemId: String)
}

class DishTableViewCell: UITableViewCell,RatingControlDelegate {

    @IBOutlet weak var dateLabel: UILabel!
    @IBOutlet weak var rateControl: RatingControl!
    @IBOutlet weak var img: UIImageView!
        
    @IBOutlet weak var dishNameLabel: UILabel!
    
    var itemId:String?
    var dishId:String?
    var restInfo:[String:AnyObject]?
    
    var delegate:DishTableViewCellDelegate?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        if let rateControl = rateControl{
            rateControl.delegate = self
        }
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    @IBAction func deleteButtonOnClick(_ sender: Any) {
        if let itemId = itemId{
            delegate?.didTapDeleteButton(itemId: itemId)
        }
    }
    
    @IBAction func detailButtonOnClick(_ sender: Any) {
        if let restInfo = restInfo{
            delegate?.didTapDetailButton(restInfo: restInfo, dishImage:img.image ?? UIImage(named:"noImage")!, dishId: dishId!)
        }
    }
    
    
    func didTapRating(rating: Int) {
        if let itemId = itemId {
            delegate?.didTapRating(itemId: itemId, rating: rating)
        }
    }
}


