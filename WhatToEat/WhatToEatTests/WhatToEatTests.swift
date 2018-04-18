//
//  WhatToEatTests.swift
//  WhatToEatTests
//
//  Created by CHEN CHEN on 4/10/18.
//  Copyright © 2018 CHEN CHEN. All rights reserved.
//

import XCTest
@testable import WhatToEat

class WhatToEatTests: XCTestCase {
    
    func testDishInitialization() {
        
        //Initialize succeeds
        let dish0 = Dish.init(name: "Dish0", photo: nil, rating: 0)
        XCTAssertNotNil(dish0)
        
        let dish1 = Dish.init(name: "Dish1", photo: nil, rating: 1)
        XCTAssertNotNil(dish1)
        
        //Initialize fails
        let dishNil0 = Dish.init(name: "Nil", photo: nil, rating: -1)
        XCTAssertNil(dishNil0)
        
        let dishNil1 = Dish.init(name: "Nil", photo: nil, rating: 6)
        XCTAssertNil(dishNil1)
        
        let dishNil2 = Dish.init(name: "", photo: nil, rating: 1)
        XCTAssertNil(dishNil2)
    }
    
}
