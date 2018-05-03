//
//  FilterPageController.swift
//  WhatToEat
//
//  Created by Alan Jin on 5/3/18.
//  Copyright © 2018 CHEN CHEN. All rights reserved.
//

import UIKit

class FilterPageController:UIViewController {
    @IBOutlet weak var priceButtons: UIView!
    @IBOutlet weak var ratingButtons: UIView!
    @IBOutlet weak var distanceLabel: UILabel!
    
    let buttonSelectedColor = UIColor(red:1.00, green:0.82, blue:0.22, alpha:1.0)
    let buttonDeselectedColor = UIColor(red:0.67, green:0.67, blue:0.67, alpha:1.0)

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        for button in priceButtons.subviews{
            if let button = button as? UIButton{
                button.addTarget(self, action: #selector(self.buttonClicked(button:)), for: .touchUpInside)
            }
        }
        
        for button in ratingButtons.subviews{
            if let button = button as? UIButton{
                button.addTarget(self, action: #selector(self.buttonClicked(button:)), for: .touchUpInside)
            }
        }
        
    }
    
    @objc private func buttonClicked(button:UIButton){
        if (button.backgroundColor?.isEqual(buttonSelectedColor))!{
            button.backgroundColor = buttonDeselectedColor
        }
        else {button.backgroundColor = buttonSelectedColor}
    }
    
    @IBAction func sliderValueOnChange(_ sender: UISlider) {
        var currentValue =  sender.value
        if currentValue != 10{
            let currentValueString = String(format: "%.2f",sender.value)
            distanceLabel.text = "\(currentValueString) miles"
        }else {
            distanceLabel.text = "No Limit"
        }
    }
    
    func countSelectedButtons(buttons:UIView) -> [Bool]{
        var retArray:[Bool] = []
        for button in buttons.subviews{
            if let button = button as? UIButton{
                if (button.backgroundColor?.isEqual(buttonSelectedColor))!{
                    retArray.append(true)
                }else{
                    retArray.append(false)
                }
            }
        }
        return retArray
    }
   
}
