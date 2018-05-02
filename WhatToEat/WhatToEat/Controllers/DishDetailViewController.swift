//
//  DishDetailViewController.swift
//  WhatToEat
//
//  Created by Alan Jin on 4/11/18.
//  Copyright © 2018 CHEN CHEN. All rights reserved.
//

import UIKit
import GoogleMaps
import Firebase
import FirebaseAuth

class DishDetailViewController: UIViewController {

   
    @IBOutlet weak var restaurantName: UILabel!
    @IBOutlet weak var openLabel: UILabel!
    @IBOutlet weak var restaurantImage: UIImageView!
    @IBOutlet weak var timeLabel: UILabel!
    @IBOutlet weak var priceRate: RatingControl!
    @IBOutlet weak var ratingRate: RatingControl!
    @IBOutlet weak var mapView: GMSMapView!
    @IBOutlet weak var goButton: UIButton!
    
    var userId = Auth.auth().currentUser!.uid
    var restInfo:[String:AnyObject] = [:]
    var dishImage:UIImage = UIImage()
    var dishId:String = ""
    
    @IBAction func goButtonOnClick(_ sender: Any) {
        let bodyData = [
            "userId": userId,
            "dishId": dishId
            ] as [String : AnyObject]
        let urlString = "https://us-central1-whattoeat-9712f.cloudfunctions.net/savehist"
        Util.request(httpMethod: "POST", urlString: urlString, body: bodyData){_ in}
    }
    
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func viewDidLoad() {
        
        super.viewDidLoad()
        
       
        goButton.layer.cornerRadius = 25
       
        
        
        //Set the detail page with the restInfo (infomation of the restaurant) if the restInfo has infos
        //Else just set the variable of the page with default values
        if let _ = restInfo["name"]{
            restaurantName.text = restInfo["name"] as! String
            priceRate.rating = Int(restInfo["price"] as! Float)
            ratingRate.rating = Int(restInfo["stars"] as! Float)
            restaurantImage.image = dishImage
            
            //TODO:Set the open label and map
            openLabel.text = "Open"
            openLabel.textColor = UIColor(red: 0, green: 1.0, blue: 0, alpha: 1)
            let camera = GMSCameraPosition.camera(withLatitude: 40.112617, longitude: -88.209419, zoom:12.0)
            mapView.camera = camera
            
            let marker = GMSMarker()
            marker.position = CLLocationCoordinate2D(latitude: 40.112617, longitude: -88.209419)
            marker.map = mapView
            
        }else{
            restaurantName.text = "name"
            openLabel.text = "Open"
            openLabel.textColor = UIColor(red: 0, green: 1.0, blue: 0, alpha: 1)
            priceRate.rating = 0
            ratingRate.rating = 0
            
            let camera = GMSCameraPosition.camera(withLatitude: 40.112617, longitude: -88.209419, zoom:12.0)
            mapView.camera = camera
            
            let marker = GMSMarker()
            marker.position = CLLocationCoordinate2D(latitude: 40.112617, longitude: -88.209419)
            marker.map = mapView
        }
        
    }

}
