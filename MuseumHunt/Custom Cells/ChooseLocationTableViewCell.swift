//
//  ChooseLocationTableViewCell.swift
//  MuseumHunt
//
//  Created by Alperen Ünal on 12.07.2019.
//  Copyright © 2019 Alperen Ünal. All rights reserved.
//

import UIKit
import SDWebImage

class ChooseLocationTableViewCell: UITableViewCell {

    
    @IBOutlet weak var locationImageView: UIImageView!
    
    @IBOutlet weak var locationNameLabel: UILabel!
    
    @IBOutlet weak var locationDistanceLabel: UILabel!
    
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        locationImageView.layer.cornerRadius = locationImageView.bounds.height / 2
        locationImageView.clipsToBounds = true
    }

    func setLocationCell(location: Location){
        let urlBase = "https://jwtapi20190719101048.blob.core.windows.net/beamityblob/"
        guard let url = URL(string: urlBase + location.photoURL) else { return }
        locationImageView.sd_setImage(with: url)
        locationNameLabel.text = location.name
        locationDistanceLabel.text = "Distance: \(location.distance.map(){ String($0) } ?? "Waiting for your location") Kilometer"
    }

}
