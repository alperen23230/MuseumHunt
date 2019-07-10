//
//  ContentViewController.swift
//  MuseumHunt
//
//  Created by Alperen Ünal on 8.07.2019.
//  Copyright © 2019 Alperen Ünal. All rights reserved.
//

import UIKit
import ImageSlideshow
import SDWebImage
import AVKit

class ContentViewController: UIViewController {

    var content: Content!
    
    
    @IBOutlet weak var slideImageView: ImageSlideshow!
    
    @IBOutlet weak var textView: UITextView!
    
    @IBOutlet weak var audioLabel: UILabel!
    
    @IBOutlet weak var audioPlayStopButton: CustomButton!
    
    @IBOutlet weak var audioRestartButton: CustomButton!
    
    @IBOutlet weak var textViewHeight: NSLayoutConstraint!
    
    @IBOutlet weak var videoPlayImage: UIImageView!
    
    @IBOutlet weak var videoThumbnailImage: UIImageView!
    
    @IBOutlet weak var slideImageHeight: NSLayoutConstraint!
    
    @IBOutlet weak var imageThumbnailHeight: NSLayoutConstraint!
    
    
    let urlBase = "https://testblobkayten.blob.core.windows.net/blobcontainer"
    
    var isPlayAudio = false
    
    var contentVM: ContentViewModel!
    
    var videoVC = AVPlayerViewController()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        contentVM = ContentViewModel()
        
        setupContent()
    }
    

    func setupContent(){
        guard let content = content else { return }
        navigationItem.title = content.title
        
        if let slideImageURL = content.slideImageURL {
            //setup images
            slideImageView.layer.cornerRadius = 15
            setupImageSlide(imageURL: urlBase + slideImageURL)
        } else {
            slideImageHeight.constant = 0
            slideImageView.layoutIfNeeded()
            slideImageView.isHidden = true
        }
        
        if let text = content.text {
            textView.text = text
        } else {
            textViewHeight.constant = 0
            textView.layoutIfNeeded()
            textView.text = ""
            textView.isHidden = true
        }
        
        if let audioURL = content.audioURL {
            //prepare audio
            contentVM.prepareAudio(with: urlBase + audioURL)
        } else {
            audioLabel.isHidden = true
            audioPlayStopButton.isHidden = true
            audioRestartButton.isHidden = true
        }
        
        if let videoURL = content.videoURL {
            //prepare video
            
            videoThumbnailImage.layer.cornerRadius = 20
            
            guard let url = URL(string: urlBase + content.mainImageURL!) else { return }
            
            videoThumbnailImage.sd_setImage(with: url)
            
            let videoPlayer = contentVM.prepareVideo(with: urlBase + videoURL)
            videoVC.player = videoPlayer
            
            let tap = UITapGestureRecognizer(target: self, action: #selector(openVideo))
            tap.numberOfTapsRequired = 1
            
            videoPlayImage.isUserInteractionEnabled = true
            
            videoPlayImage.addGestureRecognizer(tap)
            
        } else {
            imageThumbnailHeight.constant = 0
            videoPlayImage.layoutIfNeeded()
            videoPlayImage.isHidden = true
            videoThumbnailImage.isHidden = true
        }
    }
    
    @objc func openVideo(){
        present(videoVC,animated: true){
            self.contentVM.playVideo()
        }
    }
    
    @IBAction func audioPlayStopClicked(_ sender: Any) {
        if isPlayAudio{
            audioPlayStopButton.setTitle("Play", for: .normal)
             isPlayAudio = false
            //stop
            contentVM.pauseAudio()
        } else {
            audioPlayStopButton.setTitle("Pause", for: .normal)
             isPlayAudio = true
            //play
            contentVM.playAudio()
        }
    }
    
    @IBAction func audioRestartClicked(_ sender: Any) {
        if isPlayAudio{
            contentVM.restartAudio()
        }
    }
    
    func setupImageSlide(imageURL: String){
        guard let url = URL(string: imageURL) else { return }
        let source = [SDWebImageSource(url: url)]
        slideImageView.setImageInputs(source)
        
        slideImageView.slideshowInterval = 5.0
        slideImageView.pageIndicatorPosition = .init(horizontal: .center, vertical: .under)
        slideImageView.contentScaleMode = UIView.ContentMode.scaleToFill
        
        let pageControl = UIPageControl()
        pageControl.currentPageIndicatorTintColor = UIColor.lightGray
        pageControl.pageIndicatorTintColor = UIColor.black
        slideImageView.pageIndicator = pageControl
        
        let recognizer = UITapGestureRecognizer(target: self, action: #selector(didTap))
        slideImageView.addGestureRecognizer(recognizer)
    }
    
    @objc func didTap() {
        let fullScreenController = slideImageView.presentFullScreenController(from: self)
        // set the activity indicator for full screen controller (skipping the line will show no activity indicator)
        fullScreenController.slideshow.activityIndicator = DefaultActivityIndicator(style: .white, color: nil)
    }
    
}
