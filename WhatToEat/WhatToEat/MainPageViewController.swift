//
//  MainPageViewController.swift
//  WhatToEat
//
//  Created by Zhiwei Zhang on 4/11/18.
//  Copyright © 2018 CHEN CHEN. All rights reserved.
//

import Koloda

private var numberOfCards: Int = 8

class MyKolodaViewController: UIViewController {
    
    @IBOutlet weak var sideBar: UIStackView!
    @IBOutlet weak var kolodaView: KolodaView!
    
    @IBOutlet weak var go: UIButton!
    @IBOutlet weak var like: UIButton!
    @IBOutlet weak var dislike: UIButton!
    @IBAction func likeAction(_ sender: Any) {
        kolodaView?.swipe(.right)
    }
    @IBAction func dislikeAction(_ sender: Any) {
        kolodaView?.swipe(.left)
    }
    
    var sideBarShow = false
    @IBOutlet weak var sideBarLeading: NSLayoutConstraint!
    @IBAction func sideBarButton(_ sender: Any) {
        sideBarShow = !sideBarShow
        if sideBarShow {
            sideBarLeading.constant = 0
        }else{
            sideBarLeading.constant = -175
        }
        UIView.animate(withDuration: 0.2, delay: 0.0, options: .curveEaseIn, animations:{
            self.view.layoutIfNeeded()
        })
    }
    
    
    
    
    fileprivate var dataSource: [UIImage] = {
        var array: [UIImage] = []
        let urls = [URL(string: "https://i.ndtvimg.com/i/2016-06/chinese-625_625x350_81466064119.jpg"),
                    URL(string: "https://www.seriouseats.com/recipes/images/2017/06/20170617-bulgogi-burger-matt-clifton-1-1500x1125.jpg"),
                    URL(string: "https://cdn-images-1.medium.com/max/1600/1*xoMh1motSFtZ5yodvEeEYA.jpeg"),
                    URL(string: "https://cdn.vox-cdn.com/uploads/chorus_image/image/49266033/eatersea0416_mendozas_market_yelp_mendozas_m.0.0.jpg"),
                    URL(string: "https://i.ndtvimg.com/i/2016-06/chinese-625_625x350_81466064119.jpg"),
                    URL(string: "https://www.seriouseats.com/recipes/images/2017/06/20170617-bulgogi-burger-matt-clifton-1-1500x1125.jpg"),
                    URL(string: "https://cdn-images-1.medium.com/max/1600/1*xoMh1motSFtZ5yodvEeEYA.jpeg"),
                    URL(string: "https://cdn.vox-cdn.com/uploads/chorus_image/image/49266033/eatersea0416_mendozas_market_yelp_mendozas_m.0.0.jpg"),
                    URL(string: "http://i.imgur.com/w5rkSIj.jpg")]
        
        for index in 0..<numberOfCards {
            
            let url = urls[index]
            let data = try? Data(contentsOf: url!)
            
            if let imageData = data {
                let image = UIImage(data: imageData)
                array.append(image!)
            }
            
//            array.append(UIImage(named: "Card_like_\(index + 1)")!)
        }
        
        return array
    }()
    
    // MARK: Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        kolodaView.dataSource = self
        kolodaView.delegate = self
        
        self.modalTransitionStyle = UIModalTransitionStyle.flipHorizontal
        
//        self.user_avatar.layer.borderWidth = 1.0
//        user_avatar.layer.masksToBounds = false
//        self.user_avatar.layer.borderColor = UIColor.white.cgColor
//        self.user_avatar.layer.cornerRadius = self.user_avatar.frame.size.width / 2
//        self.user_avatar.clipsToBounds = true
        
//        user_avatar.layer.cornerRadius = 8.0
//        user_avatar.clipsToBounds = true
//        user_avatar.contentMode = .scaleAspectFit;
    }
    
}


extension MyKolodaViewController: KolodaViewDelegate {
    func kolodaDidRunOutOfCards(_ koloda: KolodaView) {
        koloda.reloadData()
    }
    
    func koloda(_ koloda: KolodaView, didSelectCardAt index: Int) {
        UIApplication.shared.openURL(URL(string: "https://google.com")!)
    }
}

extension MyKolodaViewController: KolodaViewDataSource {
    
    func kolodaNumberOfCards(_ koloda:KolodaView) -> Int {
        return dataSource.count
    }
    
    func kolodaSpeedThatCardShouldDrag(_ koloda: KolodaView) -> DragSpeed {
        return .default
    }
    
    func koloda(_ koloda: KolodaView, viewForCardAt index: Int) -> UIView {
        let out = UIImageView(image: dataSource[Int(index)])
        
        out.layer.cornerRadius = 8.0
        out.clipsToBounds = true
        out.contentMode = .scaleAspectFill;

        return out
    }
    
//    func koloda(_ koloda: KolodaView, viewForCardOverlayAt index: Int) -> OverlayView? {
//        return Bundle.main.loadNibNamed("OverlayView", owner: self, options: nil)?[0] as? OverlayView
//    }
}
