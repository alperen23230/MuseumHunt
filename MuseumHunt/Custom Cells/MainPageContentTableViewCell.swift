//
//  MainPageContentTableViewCell.swift
//  MuseumHunt
//
//  Created by Alperen Ünal on 5.07.2019.
//  Copyright © 2019 Alperen Ünal. All rights reserved.
//

import UIKit
import SDWebImage

class MainPageContentTableViewCell: UITableViewCell {

    
    @IBOutlet weak var contentMainImageView: UIImageView!
    
    @IBOutlet weak var contentNameLabel: UILabel!
    
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
    
    func setMainPageContent(content: MainPageContentCache){
        let urlBase = "https://testblobkayten.blob.core.windows.net/blobcontainer"
        guard let url = URL(string: urlBase + content.mainImageURL) else { return }
        contentMainImageView.sd_setImage(with: url)
        contentNameLabel.text = content.name
        contentDescriptionLabel.text = content.descrpt
    }
    
}
