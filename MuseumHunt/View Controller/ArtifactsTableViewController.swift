//
//  ArtifactsTableViewController.swift
//  MuseumHunt
//
//  Created by Alperen Ünal on 1.07.2019.
//  Copyright © 2019 Alperen Ünal. All rights reserved.
//

import UIKit
import KRProgressHUD
import DGElasticPullToRefresh

class ArtifactsTableViewController: UITableViewController {
    
    var launchArtifact = ""
    
    var artifactVM: ArtifactViewModel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        checkFirstTimeArtifact()
        
        if launchArtifact == "FirstTime" {
            MyAlert.show(title: "Artifacts", description: "You can visit this page by selecting the artifacts, you can do interactive tours.", buttonTxt: "OK")
        }
        
        //We create instance of Artifact View Model
        artifactVM = ArtifactViewModel()
        
        setupPullToRefresh()
    }
    
    func checkFirstTimeArtifact(){
        let isFirstTimeArtifact = UserDefaults.standard.bool(forKey: "isFirstTimeArtifact")
        
        if isFirstTimeArtifact {
            launchArtifact = "BeforeLaunch"
        } else {
            launchArtifact = "FirstTime"
            UserDefaults.standard.set(true, forKey: "isFirstTimeArtifact")
        }
    }
    
    
    func setupPullToRefresh(){
        navigationController?.navigationBar.isTranslucent = false
        
        let loadingView = DGElasticPullToRefreshLoadingViewCircle()
        loadingView.tintColor = UIColor.flatYellow()
        tableView.dg_addPullToRefreshWithActionHandler({ [weak self] () -> Void in
            // Add your logic here
            // Do not forget to call dg_stopLoading() at the end
            self?.artifactVM.clearArtifactCache()
            let locationID = UserDefaults.standard.string(forKey: "CurrentLocation")
            self?.fetchAndParseArtifacts(locationID: locationID!)
            self?.tableView.dg_stopLoading()
            }, loadingView: loadingView)
        tableView.dg_setPullToRefreshFillColor(UIColor.flatMagenta())
        tableView.dg_setPullToRefreshBackgroundColor(tableView.backgroundColor!)
    }
    
    
    
    override func viewDidAppear(_ animated: Bool) {
        checkPageState()
    }
    
    func checkPageState(){
        //This user default for is fetched main page contents at least once
        let isFetched = UserDefaults.standard.bool(forKey: "isFetchedArtifact")
        if launch == "FirstTime" {
            if !isFetched {
                artifactVM.clearArtifactCache()
                let locationID = UserDefaults.standard.string(forKey: "CurrentLocation")
                fetchAndParseArtifacts(locationID: locationID!)
                UserDefaults.standard.set(true, forKey: "isFetchedMainPage")
            } else {
                artifactVM.loadArtifacts()
                tableView.reloadData()
            }
        } else {
            let changeState = UserDefaults.standard.bool(forKey: "isChangeLocationForArtifact")
            if changeState {
                artifactVM.clearArtifactCache()
                let locationID = UserDefaults.standard.string(forKey: "CurrentLocation")
                fetchAndParseArtifacts(locationID: locationID!)
                UserDefaults.standard.set(false, forKey: "isChangeLocationForArtifact")
            } else {
                //Realm Read Data
                artifactVM.loadArtifacts()
                tableView.reloadData()
            }
        }
    }
    
    func fetchAndParseArtifacts(locationID: String){
        DispatchQueue.main.async {
            KRProgressHUD.show(withMessage: "Please wait for fetching artifacts")
        }
        let locationJSONModel = LocationJSONModel(id: locationID)
        APIClient.sharedInstance.fetchAllArtfiacts(location: locationJSONModel) { (result) in
            switch result {
            case .failure(let error):
                print(error)
                DispatchQueue.main.async {
                    KRProgressHUD.dismiss()
                    KRProgressHUD.showError()
                }
            case .success(let artifacts):
                DispatchQueue.main.async {
                    for artifact in artifacts{
                        let artifactCache = ArtifactCache()
                        artifactCache.name = artifact.name
                        artifactCache.floorName = artifact.floorName
                        artifactCache.roomName = artifact.roomName
                        artifactCache.buildingName = artifact.buildingName
                        artifactCache.imageURL = artifact.mainImageURL
                        self.artifactVM.saveArtifactCache(artifact: artifactCache)
                    }
                    self.artifactVM.loadArtifacts()
                    self.tableView.reloadData()
                    KRProgressHUD.dismiss()
                }
            }
        }
    }
    
    deinit {
        tableView.dg_removePullToRefresh()
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
