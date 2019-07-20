//
//  CampaignTableViewCell.swift
//  MuseumHunt
//
//  Created by Alperen Ünal on 17.07.2019.
//  Copyright © 2019 Alperen Ünal. All rights reserved.
//

import UIKit
import SDWebImage

class CampaignTableViewCell: UITableViewCell {

    
    @IBOutlet weak var campaignImageView: UIImageView!
    
    
    @IBOutlet weak var campaignView: UIView!
    
    
    @IBOutlet weak var campaignNameLabel: UILabel!
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        campaignView.layer.cornerRadius = 20
        campaignView.backgroundColor = UIColor(hexString: "#000000", withAlpha: 0.5)
        
        campaignImageView.layer.cornerRadius = 20
        campaignImageView.clipsToBounds = true
    }
    
    func setCampaign(campaign: Campaign){
        guard let url = URL(string: urlBase + campaign.mainImageURL) else { return }
        campaignImageView.sd_setImage(with: url)
        campaignNameLabel.text = campaign.name
    }

}
