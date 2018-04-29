//
//  File.swift
//  WhatToEat
//
//  Created by Alan Jin on 4/17/18.
//  Copyright © 2018 CHEN CHEN. All rights reserved.
//

import Foundation
import UIKit
import os.log

class Dish:NSObject, NSCoding{
  
    
    
    var name: String
    var photo: UIImage?
    var rating: Int
    var dishId: String
    var restInfo:[String:AnyObject]
    var extra: [String:AnyObject]
    
   
    init?(name: String, photo: UIImage?, rating: Int, dishId: String, restInfo:[String:AnyObject], extra:[String:AnyObject] = [:]) {
        if rating < 0 || rating > 5 {
            return nil
        }
        
        self.name = name
        self.photo = photo
        self.rating = rating
        self.dishId = dishId
        self.restInfo = restInfo
        self.extra = extra
    }
    required convenience init?(coder aDecoder: NSCoder) {
        let name = aDecoder.decodeObject(forKey: "name") as! String
        let dishId = aDecoder.decodeObject(forKey: "dishId") as! String
        let photo = aDecoder.decodeObject(forKey: "photo") as? UIImage
        let rating = aDecoder.decodeInteger(forKey: "rating")
        let restInfo = aDecoder.decodeObject(forKey: "restInfo") as! [String:AnyObject]
        let extra = aDecoder.decodeObject(forKey: "extra") as! [String:AnyObject]
        
        self.init(name: name, photo: photo, rating: rating, dishId: dishId, restInfo:restInfo, extra: extra)
    }
    
    func encode(with aCoder: NSCoder) {
        aCoder.encode(name, forKey: "name")
        aCoder.encode(dishId, forKey: "dishId")
        aCoder.encode(photo, forKey: "photo")
        aCoder.encode(rating, forKey: "rating")
        aCoder.encode(restInfo, forKey: "restInfo")
        aCoder.encode(extra, forKey: "extra")
    }
    
    static let DocumentsDirectory = FileManager().urls(for: .documentDirectory, in: .userDomainMask).first!
}
