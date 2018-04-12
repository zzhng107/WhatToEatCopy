//
//  DishDetailViewController.swift
//  WhatToEat
//
//  Created by Alan Jin on 4/11/18.
//  Copyright © 2018 CHEN CHEN. All rights reserved.
//

import UIKit
import GoogleMaps

class DishDetailViewController: UIViewController {

   
    @IBOutlet weak var restaurantName: UILabel!
    @IBOutlet weak var openLabel: UILabel!
    @IBOutlet weak var restaurantImage: UIImageView!
    @IBOutlet weak var timeLabel: UILabel!
    @IBOutlet weak var priceRate: RatingControl!
    @IBOutlet weak var ratingRate: RatingControl!
    @IBOutlet weak var mapView: GMSMapView!
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func viewDidLoad() {
        
        super.viewDidLoad()
        
        restaurantName.text = "Siam Terrace"
        openLabel.text = "Open"
        openLabel.textColor = UIColor(red: 0, green: 1.0, blue: 0, alpha: 1)
        priceRate.rating = 2
        ratingRate.rating = 4
        
        let camera = GMSCameraPosition.camera(withLatitude: 40.112617, longitude: -88.209419, zoom:12.0)
        mapView.camera = camera
        
        let marker = GMSMarker()
        marker.position = CLLocationCoordinate2D(latitude: 40.112617, longitude: -88.209419)
        marker.map = mapView
       
       
        
    }

}
