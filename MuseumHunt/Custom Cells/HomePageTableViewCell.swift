//
//  HomePageTableViewCell.swift
//  MuseumHunt
//
//  Created by Alperen Ünal on 16.07.2019.
//  Copyright © 2019 Alperen Ünal. All rights reserved.
//

import UIKit

class HomePageTableViewCell: UITableViewCell {
    
    
    @IBOutlet weak var homePageContentImageView: UIImageView!
    
    @IBOutlet weak var homePageView: UIView!
    
    @IBOutlet weak var homePageTitleLabel: UILabel!
    
    @IBOutlet weak var homePageDescriptionLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    
    override func layoutSubviews() {
        super.layoutSubviews()
        homePageView.layer.cornerRadius = 20
        homePageView.backgroundColor = UIColor(white: 1, alpha: 0.3)
        homePageContentImageView.layer.cornerRadius = 20
        homePageContentImageView.clipsToBounds = true
    }

}
