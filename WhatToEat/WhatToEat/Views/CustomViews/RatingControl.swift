//
//  RatingControl.swift
//  WhatToEat
//
//  Created by Alan Jin on 4/11/18.
//  Copyright © 2018 CHEN CHEN. All rights reserved.
//

import UIKit

protocol RatingControlDelegate{
    func didTapRating(rating:Int)
}

@IBDesignable class RatingControl: UIStackView {

    var delegate: RatingControlDelegate?
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupButtons()
    }
    
    required init(coder: NSCoder) {
        super.init(coder: coder)
        setupButtons()
    }
    
    
    private var ratingButtons = [UIButton]()
    
    var rating = 0 {
        didSet {
            updateButtonSelectionStates()
        }
    }
    
    @IBInspectable var itemSize: CGSize = CGSize(width: 44.0, height: 44.0) {
        didSet {
            setupButtons()
        }
    }
    
    @IBInspectable var itemCount: Int = 5 {
        didSet {
            setupButtons()
        }
    }
    
    @IBInspectable var emptyImageName: String = "star0" {
        didSet {
            setupButtons()
        }
    }
    
    @IBInspectable var fillImageName: String = "star1" {
        didSet {
            setupButtons()
        }
    }
   
    private func updateButtonSelectionStates() {
        for (index, button) in ratingButtons.enumerated() {
            // If the index of a button is less than the rating, that button should be selected.
            button.isSelected = index < rating
        }
    }
    
    private func setupButtons() {
        // clear any existing buttons
        for button in ratingButtons {
            removeArrangedSubview(button)
            button.removeFromSuperview()
        }
        ratingButtons.removeAll()
        
        
        // Load Button Images
        let bundle = Bundle(for: type(of: self))
        let emptyImage = UIImage(named:emptyImageName, in: bundle, compatibleWith: self.traitCollection)
        let filledImage = UIImage(named: fillImageName, in: bundle, compatibleWith: self.traitCollection)
        
        
        
        for _ in 0..<itemCount {
            // Create the button
            let button = UIButton()
            button.setImage(emptyImage, for: .normal)
            button.setImage(filledImage, for: .selected)
            
            // Add constraints
            button.translatesAutoresizingMaskIntoConstraints = false
            button.heightAnchor.constraint(equalToConstant: itemSize.height).isActive = true
            button.widthAnchor.constraint(equalToConstant: itemSize.width).isActive = true
            
            // Setup the button action
            button.addTarget(self, action: #selector(RatingControl.ratingButtonTapped(button:)), for: .touchUpInside)
            
            // Add the button to the stack
            addArrangedSubview(button)
            
            // Add the new button to the rating button array
            ratingButtons.append(button)
        }
        
        updateButtonSelectionStates()
    }
    
    @objc func ratingButtonTapped(button: UIButton) {
        guard let index = ratingButtons.index(of: button) else {
            fatalError("The button, \(button), is not in the ratingButtons array: \(ratingButtons)")
        }
        
        // Calculate the rating of the selected button
        let selectedRating = index + 1
        
        if selectedRating == rating {
            // If the selected star represents the current rating, reset the rating to 0.
            rating = 0
        } else {
            // Otherwise set the rating to the selected star
            rating = selectedRating
        }
       
        delegate?.didTapRating(rating: self.rating)
    }
}
