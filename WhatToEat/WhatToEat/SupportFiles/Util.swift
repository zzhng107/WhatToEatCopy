//
//  Util.swift
//  WhatToEat
//
//  Created by Alan Jin on 5/1/18.
//  Copyright © 2018 CHEN CHEN. All rights reserved.
//

import Foundation
import UIKit

class Util{
   
        static func displaySpinner(onView : UIView) -> UIView {
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
        
        static func removeSpinner(spinner :UIView) {
            DispatchQueue.main.async {
                spinner.removeFromSuperview()
            }
        }
    
}


