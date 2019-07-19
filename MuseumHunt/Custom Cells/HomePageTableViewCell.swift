//
//  HomePageTableViewCell.swift
//  MuseumHunt
//
//  Created by Alperen Ünal on 16.07.2019.
//  Copyright © 2019 Alperen Ünal. All rights reserved.
//

import UIKit
import SDWebImage

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
        homePageView.backgroundColor = UIColor(hexString: "#000000", withAlpha: 0.5)
        
        
        homePageContentImageView.layer.cornerRadius = 20
        homePageContentImageView.clipsToBounds = true
    }
    
    func setHomePageContent(content: MainPageContentCache){
        let urlBase = "https://jwtapi20190719101048.blob.core.windows.net/beamityblob/"
        guard let url = URL(string: urlBase + content.mainImageURL) else { return }
        homePageContentImageView.sd_setImage(with: url)
        homePageTitleLabel.text = content.name
        homePageDescriptionLabel.text = content.descrpt
    }
}
