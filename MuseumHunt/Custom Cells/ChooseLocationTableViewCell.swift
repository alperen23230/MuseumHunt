//
//  ChooseLocationTableViewCell.swift
//  MuseumHunt
//
//  Created by Alperen Ünal on 12.07.2019.
//  Copyright © 2019 Alperen Ünal. All rights reserved.
//

import UIKit

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


}
