//
//  MainPageContentTableViewCell.swift
//  MuseumHunt
//
//  Created by Alperen Ünal on 5.07.2019.
//  Copyright © 2019 Alperen Ünal. All rights reserved.
//

import UIKit

class MainPageContentTableViewCell: UITableViewCell {

    
    @IBOutlet weak var contentMainImageView: UIImageView!
    @IBOutlet weak var contentTitleLabel: UILabel!
    @IBOutlet weak var contentDescriptionLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func layoutSubviews() {
        super.layoutSubviews()
        contentMainImageView.layer.cornerRadius = contentMainImageView.bounds.height / 2
        contentMainImageView.clipsToBounds = true
    }
    
}
