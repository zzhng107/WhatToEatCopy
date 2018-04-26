//
//  TempGoPageViewController.swift
//  WhatToEat
//
//  Created by Zhiwei Zhang on 4/26/18.
//  Copyright © 2018 CHEN CHEN. All rights reserved.
//

import UIKit

class TempDetailPageViewController: UIViewController {
    
    var dishNamePassed : String = ""
    @IBOutlet weak var dishName: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        dishName.text = dishNamePassed
    }

}
