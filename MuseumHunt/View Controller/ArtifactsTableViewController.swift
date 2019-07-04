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
        if launch == "FirstTime" {
            fetchArtifactData()
        } else {
            //Realm Read Data
            artifactVM.loadCategories()
            tableView.reloadData()
        }
    }
    
    func fetchArtifactData(){
        DispatchQueue.global(qos: .userInitiated).async { [weak self] in
            self?.artifactVM.fetchAndParseArtifacts()
            DispatchQueue.main.async {
                self?.artifactVM.loadCategories()
                self?.tableView.reloadData()
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
