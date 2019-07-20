//
//  ArtifactTableViewCell.swift
//  MuseumHunt
//
//  Created by Alperen Ünal on 4.07.2019.
//  Copyright © 2019 Alperen Ünal. All rights reserved.
//

import UIKit
import SDWebImage

class ArtifactTableViewCell: UITableViewCell {
    
    @IBOutlet weak var artifactImageView: UIImageView!
    
    @IBOutlet weak var artifactNameLabel: UILabel!
    
    @IBOutlet weak var artifactDetailLabel: UILabel!
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        artifactImageView.layer.cornerRadius = artifactImageView.bounds.height / 2
        artifactImageView.clipsToBounds = true
    }
    
    func setArtifactCache(artifact: ArtifactCache){
        guard let url = URL(string: urlBase + artifact.imageURL) else { return }
        artifactImageView.sd_setImage(with: url)
        artifactNameLabel.text = artifact.name
        artifactDetailLabel.text = "\(artifact.buildingName) \(artifact.floorName) \(artifact.roomName)"
        
        accessoryType = artifact.willTravel ? .checkmark : .none
    }
}
