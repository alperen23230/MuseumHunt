//
//  ArtifactsTableViewController.swift
//  MuseumHunt
//
//  Created by Alperen Ünal on 1.07.2019.
//  Copyright © 2019 Alperen Ünal. All rights reserved.
//

import UIKit

class ArtifactsTableViewController: UITableViewController {
    
    var artifactVM = ArtifactViewModel()

    override func viewDidLoad() {
        super.viewDidLoad()
        if launch == "FirstTime"{
            fetchArtifactData()
        } else {
            //realm read code
            artifactVM.loadCategories()
            tableView.reloadData()
        }
    }
    
    func fetchArtifactData(){
        DispatchQueue.global(qos: .userInitiated).async { [weak self] in
            self?.fetchAndParseArtifacts()
        }
    }
    
    func fetchAndParseArtifacts(){
        APIClient.sharedInstance.fetchAllArtfiacts { (result) in
            switch result {
            case .failure(let error):
                print(error)
            case .success(let artifacts):
                for artifact in artifacts{
                    self.artifactVM.artifacts.append(artifact)
                    DispatchQueue.main.async {
                        let artifactCache = ArtifactCache()
                        artifactCache.name = artifact.name
                        artifactCache.floorName = artifact.floorName
                        artifactCache.roomName = artifact.roomName
                        artifactCache.buildingName = artifact.buildingName
                        artifactCache.imageURL = artifact.mainImageURL
                        self.artifactVM.saveArtifactCache(artifact: artifactCache)
                    }
                }
                DispatchQueue.main.async {
                    self.tableView.reloadData()
                }
            }
        }
    }
}


extension ArtifactsTableViewController {
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 100
    }
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if launch == "FirstTime"{
            return artifactVM.artifacts.count
        } else {
            return artifactVM.artifactsCache?.count ?? 0
        }
    }
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "artifactCell") as! ArtifactTableViewCell
        
        if launch == "FirstTime"{
            let artifact = artifactVM.artifacts[indexPath.row]

            cell.setArtifact(artifact: artifact)
        } else {
            let artifact = artifactVM.artifactsCache?[indexPath.row]
            
            guard let artifactCache = artifact else { return UITableViewCell() }
            
            cell.setArtifactCache(artifact: artifactCache)
        }
        
        return cell
    }
}
