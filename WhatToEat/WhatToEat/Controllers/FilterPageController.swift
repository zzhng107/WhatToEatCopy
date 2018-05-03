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
    @IBOutlet weak var slider: UISlider!
    
    let buttonSelectedColor = UIColor(red:1.00, green:0.82, blue:0.22, alpha:1.0)
    let buttonDeselectedColor = UIColor(red:0.67, green:0.67, blue:0.67, alpha:1.0)
    
    let defaults = UserDefaults.standard
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationController?.delegate = self
        
        loadFromLocal()
        
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
        setDistanceLabel(value:sender.value)
    }
    
    private func countSelectedButtons(buttons:UIView) -> [Bool]{
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
    
    private func getDistance() -> Float{
        if distanceLabel.text == "No Limit"{
            return 10
        }else{
            return Float(distanceLabel.text!.replacingOccurrences(of: " miles", with: ""))!
        }
    }
    
    private func getFilterData() -> [String:Any]{
        let filterData:[String:Any] = [
            "price": self.countSelectedButtons(buttons: priceButtons),
            "rating":self.countSelectedButtons(buttons: ratingButtons),
            "distance": self.getDistance()
        ]
        return filterData
    }
    
    private func setDistanceLabel(value:Float){
        if value != 10{
            let currentValueString = String(format: "%.2f",value)
            distanceLabel.text = "\(currentValueString) miles"
        }else {
            distanceLabel.text = "No Limit"
        }
    }
    
    private func setFromData(filterData:[String:Any]){
        let priceData = filterData["price"] as! [Bool]
        let ratingData = filterData["rating"] as! [Bool]
        let distanceData = filterData["distance"] as! Float
        for (index,button) in priceButtons.subviews.enumerated(){
            if let button = button as? UIButton{
                if(priceData[index]){
                    button.backgroundColor = buttonSelectedColor
                }else{
                    button.backgroundColor = buttonDeselectedColor
                }
            }
        }
        for (index,button) in ratingButtons.subviews.enumerated(){
            if let button = button as? UIButton{
                if(ratingData[index]){
                    button.backgroundColor = buttonSelectedColor
                }else{
                    button.backgroundColor = buttonDeselectedColor
                }
            }
        }
        setDistanceLabel(value: distanceData)
        slider.setValue(distanceData, animated: false)
    }
    
    private func saveToLocal(filterData:[String:Any]){
        defaults.set(filterData, forKey: "filterData")
    }
    
    private func loadFromLocal(){
        let filterData = defaults.object(forKey: "filterData") as? [String : Any]
        if let filterData = filterData{
            setFromData(filterData: filterData)
        }
    }
    
    
}

extension FilterPageController: UINavigationControllerDelegate {
    func navigationController(_ navigationController: UINavigationController, willShow viewController: UIViewController, animated: Bool) {
        let filterData = self.getFilterData()
        saveToLocal(filterData: filterData)
        (viewController as? MyKolodaViewController)?.filterData = filterData
    }
}
