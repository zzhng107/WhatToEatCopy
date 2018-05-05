//
//  WhatToEatTests.swift
//  WhatToEatTests
//
//  Created by CHEN CHEN on 4/10/18.
//  Copyright © 2018 CHEN CHEN. All rights reserved.
//

import XCTest
import UIKit

@testable import WhatToEat

class MockUserDefaults: UserDefaults {
    var filterCount = 0
    override func set(_ value: Int, forKey defaultName: String) {
        if defaultName == "filterData" {
            filterCount += 1
        }
    }
}

class WhatToEatTests: XCTestCase {
    
    var storyboard: UIStoryboard!
    var filterVC: FilterPageController!
    var detailVC: DishDetailViewController!
    var historyListVC:DishListTableViewController!
    var mockUserDefaults: MockUserDefaults!
    
    override func setUp() {
        super.setUp()
        storyboard = UIStoryboard(name:"Main",bundle: nil)
        filterVC = storyboard.instantiateViewController(withIdentifier: "Filter") as! FilterPageController
        mockUserDefaults = MockUserDefaults(suiteName: "testing")!
        filterVC.defaults = mockUserDefaults
        _ = filterVC.view
        
        detailVC = storyboard.instantiateViewController(withIdentifier: "dishDetailViewController") as! DishDetailViewController
        _ = detailVC.view
        
        
        historyListVC = storyboard.instantiateViewController(withIdentifier: "dishListTableViewController") as! DishListTableViewController
        _ = historyListVC.view
    }
    
    func testDishInitialization() {
        //Initialize succeeds
        let dish0 = Dish.init(name: "Dish0", photo: nil, rating: 0, dishId:"", restInfo:[:], extra:[:])
        XCTAssertNotNil(dish0)
        
        let dish1 = Dish.init(name: "Dish1", photo: nil, rating: 1, dishId:"", restInfo:[:], extra:[:])
        XCTAssertNotNil(dish1)
        
        //Initialize fails
        let dishNil0 = Dish.init(name: "Nil", photo: nil, rating: -1, dishId:"", restInfo:[:], extra:[:])
        XCTAssertNil(dishNil0)
        
        let dishNil1 = Dish.init(name: "Nil", photo: nil, rating: 6, dishId:"", restInfo:[:], extra:[:])
        XCTAssertNil(dishNil1)
    }
    
    func testConvertDateToHumanReadable(){
        let date0 = Util.convertDateToHumanReadable(rawTime: 1525498164279)
        XCTAssertEqual(date0,"05/05/2018 00:29")
        
        let date1 = Util.convertDateToHumanReadable(rawTime: 1525498)
        XCTAssertEqual(date1,"12/31/1969 18:25")
        
        let date2 = Util.convertDateToHumanReadable(rawTime: 0)
        XCTAssertEqual(date2, "12/31/1969 18:00")
    }
    
    func testFilterPagePriceButtonClick(){
        
        XCTAssertEqual(filterVC.countSelectedButtons(buttons: filterVC.priceButtons), [false, false, false, false])
        let button0 = filterVC.priceButtons.subviews[0] as! UIButton
        button0.sendActions(for: .touchUpInside)
        XCTAssertEqual(filterVC.countSelectedButtons(buttons: filterVC.priceButtons), [true, false, false, false])
        
        
        let button1 = filterVC.priceButtons.subviews[2] as! UIButton
        button1.sendActions(for: .touchUpInside)
        XCTAssertEqual(filterVC.countSelectedButtons(buttons: filterVC.priceButtons), [true, false, true, false])
    }
    
    func testFilterPageRatingButtonClick(){
        
        XCTAssertEqual(filterVC.countSelectedButtons(buttons: filterVC.ratingButtons), [false, false, false, false,false])
        let button = filterVC.ratingButtons.subviews[0] as! UIButton
        button.sendActions(for: .touchUpInside)
        XCTAssertEqual(filterVC.countSelectedButtons(buttons: filterVC.ratingButtons), [true, false, false, false,false])
        
        let button1 = filterVC.ratingButtons.subviews[1] as! UIButton
        button1.sendActions(for: .touchUpInside)
        XCTAssertEqual(filterVC.countSelectedButtons(buttons: filterVC.ratingButtons), [true, true, false, false,false])
        
        
    }
    
    func testFilterPageReset(){
        let button = filterVC.ratingButtons.subviews[4] as! UIButton
        button.sendActions(for: .touchUpInside)
        filterVC.resetFilter()
        XCTAssertEqual(filterVC.countSelectedButtons(buttons: filterVC.ratingButtons), [false, false, false, false,false])
        XCTAssertEqual(filterVC.countSelectedButtons(buttons: filterVC.priceButtons), [false, false, false, false])
    }
    
    
    func testFilterPageSaveLocal(){
        let filterData:[String : Any] = [
            "price":[false, false, false, false],
            "rating":[false, false, false, false, false],
            "distance":10.0
        ]
        XCTAssertEqual(mockUserDefaults.filterCount, 0)
        filterVC.saveToLocal(filterData: filterData)
//        XCTAssertEqual(mockUserDefaults.filterCount, 1)
    }
    
    func testDetailPageInitalization(){
        XCTAssertEqual(detailVC.restaurantName.text, "name")
        XCTAssertEqual(detailVC.openLabel.text, "Open")
        XCTAssertEqual(detailVC.openLabel.textColor, UIColor(red: 0, green: 1.0, blue: 0, alpha: 1))
        XCTAssertEqual(detailVC.priceRate.rating, 0)
        XCTAssertEqual(detailVC.ratingRate.rating, 0)
    }
    
    func testDetailPageLoadData(){
        detailVC = storyboard.instantiateViewController(withIdentifier: "dishDetailViewController") as! DishDetailViewController
        detailVC.dishImage = UIImage()
        detailVC.restInfo = [
            "name":"rest1",
            "price": 3.0,
            "stars": 4.0,
            ] as [String : AnyObject]
        _ = detailVC.view
        XCTAssertEqual(detailVC.restaurantName.text, "rest1")
        XCTAssertEqual(detailVC.openLabel.text, "Open")
        XCTAssertEqual(detailVC.openLabel.textColor, UIColor(red: 0, green: 1.0, blue: 0, alpha: 1))
        XCTAssertEqual(detailVC.priceRate.rating, 3)
        XCTAssertEqual(detailVC.ratingRate.rating, 4)
    }
    
    func testHistoryList(){
        //XCTAssertEqual(historyListVC.dishes.count, 0)
    }
    
    
    override func tearDown() {
        storyboard = nil
        mockUserDefaults = nil
        super.tearDown()
    }
    
}
