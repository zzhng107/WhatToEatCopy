//
//  File.swift
//  WhatToEat
//
//  Created by Alan Jin on 4/18/18.
//  Copyright © 2018 CHEN CHEN. All rights reserved.
//

import Foundation
import FirebaseDatabase

class FirebaseUtil{
    
    var ref:DatabaseReference? = Database.database().reference()
    
    static func postRequest() -> [String:String] {
        // do a post request and return post data
        return ["someData" : "someData"]
    }
}
