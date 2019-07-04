//
//  ArtifactsTableViewController.swift
//  MuseumHunt
//
//  Created by Alperen Ünal on 1.07.2019.
//  Copyright © 2019 Alperen Ünal. All rights reserved.
//

import UIKit
import KRProgressHUD

class ArtifactsTableViewController: UITableViewController {
    
    var artifactVM = ArtifactViewModel()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let isFetched = UserDefaults.standard.bool(forKey: "isFetched")
        if launch == "FirstTime" {
            if !isFetched {
                fetchArtifactData()
                UserDefaults.standard.set(true, forKey: "isFetched")
            } else {
                artifactVM.loadCategories()
                tableView.reloadData()
            }
        } else {
            //Realm Read Data
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
                    self.artifactVM.loadCategories()
                    self.tableView.reloadData()
                }
            }
        }
    }
    
}

//Table-View Methods
extension ArtifactsTableViewController {
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 100
    }
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return artifactVM.artifactsCache?.count ?? 0
    }
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "artifactCell") as! ArtifactTableViewCell
        
        let artifact = artifactVM.artifactsCache?[indexPath.row]
        
        guard let artifactCache = artifact else { return UITableViewCell() }
        
        cell.setArtifactCache(artifact: artifactCache)
        
        return cell
    }
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        guard let artifact = artifactVM.artifactsCache?[indexPath.row] else { return }
        
        artifactVM.updateArtifact(artifact: artifact)
        
        tableView.reloadData()
        tableView.deselectRow(at: indexPath, animated: true)
    }
}
