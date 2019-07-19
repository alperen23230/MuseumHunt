//
//  BeaconContentTableViewCell.swift
//  MuseumHunt
//
//  Created by Alperen Ünal on 18.07.2019.
//  Copyright © 2019 Alperen Ünal. All rights reserved.
//

import UIKit
import SDWebImage

class BeaconContentTableViewCell: UITableViewCell {
    
    @IBOutlet weak var beaconContentImageView: UIImageView!
    
    @IBOutlet weak var beaconContentNameLabel: UILabel!
    
    @IBOutlet weak var beaconContentDescrpt: UILabel!
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        beaconContentImageView.layer.cornerRadius = beaconContentImageView.bounds.height / 2
        beaconContentImageView.clipsToBounds = true
    }
    
    func setBeaconContent(content: RelationBeacon){
        let urlBase = "https://testblobkayten.blob.core.windows.net/blobcontainer/"
        guard let imageURL = content.mainImageURL else { return }
        guard let url = URL(string: urlBase + imageURL) else { return }
        beaconContentImageView.sd_setImage(with: url)
        beaconContentNameLabel.text = content.contentName
        if content.isCampaign {
            beaconContentDescrpt.font = UIFont(name: "SFProDisplay-Medium", size: 17)
            backgroundColor = UIColor(hexString: "#F1CEFF")
        }
        if content.description == nil {
            beaconContentDescrpt.text = "Advertisement"
        } else {
            beaconContentDescrpt.text = content.description
        }
    }

}
