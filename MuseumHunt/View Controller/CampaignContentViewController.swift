//
//  CampaignContentViewController.swift
//  MuseumHunt
//
//  Created by Alperen Ünal on 18.07.2019.
//  Copyright © 2019 Alperen Ünal. All rights reserved.
//

import UIKit
import ImageSlideshow

class CampaignContentViewController: UIViewController {
    
    
    @IBOutlet weak var campaignImageSlide: ImageSlideshow!
    
    
    @IBOutlet weak var campaignText: UITextView!
    
    var campaign: Campaign!
    
     let urlBase = "https://jwtapi20190719101048.blob.core.windows.net/beamityblob/"

    override func viewDidLoad() {
        super.viewDidLoad()
        setupView()
    }
    
    func setupView(){
        
        title = campaign.title
        
        campaignImageSlide.layer.cornerRadius = 15
        setupImageSlide(imageURL: urlBase + campaign.mainImageURL)
        
        campaignText.text = campaign.text
    }
    
    func setupImageSlide(imageURL: String){
        guard let url = URL(string: imageURL) else { return }
        let source = [SDWebImageSource(url: url)]
        campaignImageSlide.setImageInputs(source)
        
        campaignImageSlide.slideshowInterval = 5.0
        campaignImageSlide.pageIndicatorPosition = .init(horizontal: .center, vertical: .under)
        campaignImageSlide.contentScaleMode = UIView.ContentMode.scaleToFill
        
        let pageControl = UIPageControl()
        pageControl.currentPageIndicatorTintColor = UIColor.lightGray
        pageControl.pageIndicatorTintColor = UIColor.black
        campaignImageSlide.pageIndicator = pageControl
        
        let recognizer = UITapGestureRecognizer(target: self, action: #selector(didTap))
        campaignImageSlide.addGestureRecognizer(recognizer)
    }
    
    @objc func didTap() {
        let fullScreenController = campaignImageSlide.presentFullScreenController(from: self)
        // set the activity indicator for full screen controller (skipping the line will show no activity indicator)
        fullScreenController.slideshow.activityIndicator = DefaultActivityIndicator(style: .white, color: nil)
    }
}
