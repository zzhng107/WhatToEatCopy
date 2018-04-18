//
//  File.swift
//  WhatToEat
//
//  Created by Alan Jin on 4/17/18.
//  Copyright © 2018 CHEN CHEN. All rights reserved.
//

import Foundation
import UIKit

class Dish {
    
    
    var name: String
    var photo: UIImage?
    var rating: Int
    
    init?(name: String, photo: UIImage?, rating: Int) {
        if name.isEmpty || rating < 0 || rating > 5 {
            return nil
        }
       
        self.name = name
        self.photo = photo
        self.rating = rating
    }
    
}
