//
//  UnderlinedTextField.swift
//  WhatToEat
//
//  Created by CHEN CHEN on 4/10/18.
//  Copyright © 2018 CHEN CHEN. All rights reserved.
//

import UIKit

class UnderlinedTextField: UITextField {
    
    override var tintColor: UIColor! {
        didSet {
            setNeedsDisplay()
        }
    }
    
    override func draw(_ rect: CGRect) {
        
        let startingPoint   = CGPoint(x: rect.minX, y: rect.maxY)
        let endingPoint     = CGPoint(x: rect.maxX, y: rect.maxY)
        
        let path = UIBezierPath()
        
        path.move(to: startingPoint)
        path.addLine(to: endingPoint)
        path.lineWidth = 1.0
        
        tintColor.setStroke()
        
        path.stroke()
    }
}
