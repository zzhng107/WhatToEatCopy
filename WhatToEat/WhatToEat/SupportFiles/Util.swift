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
   
    
    static func convertDateToHumanReadable(rawTime:Double) -> String{
        let nsdate = NSDate(timeIntervalSince1970: rawTime/1000) as Date
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "MM/dd/yyyy HH:mm"
        return dateFormatter.string(from: nsdate)
    }
    
    
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

    
    static func request(httpMethod:String, urlString:String, body:[String:AnyObject], withCompletion completion: @escaping (_ returnData:[String: AnyObject])->()){
        
        let url = URL(string: urlString)!
        var request = URLRequest(url: url)
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        request.httpMethod = httpMethod
        if httpMethod != "GET"{
            do{
                request.httpBody = try JSONSerialization.data(withJSONObject: body, options: .prettyPrinted)
            }catch{
                print("Failed to serialize the body")
            }
        }
        
        let task = URLSession.shared.dataTask(with: request as URLRequest) { data, response, error in
            
            guard let data = data, error == nil else{
                print("error=\(error!)")
                return
            }
            
            do{
                if let output = try JSONSerialization.jsonObject(with: data, options: .mutableContainers) as? [String: AnyObject] {
                    completion(output)
                }
            }catch{
                print("error in second catch")
            }
        }
        task.resume()
    }
    
}


