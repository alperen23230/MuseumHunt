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
        fetchArtifactData()
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
        return artifactVM.artifacts.count
    }
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let artifact = artifactVM.artifacts[indexPath.row]
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "artifactCell") as! ArtifactTableViewCell
        
        cell.setArtifact(artifact: artifact)
        
        return cell
    }
}
