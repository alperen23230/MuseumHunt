//
//  HomePageTableViewController.swift
//  MuseumHunt
//
//  Created by Alperen Ünal on 17.07.2019.
//  Copyright © 2019 Alperen Ünal. All rights reserved.
//

import UIKit
import KRProgressHUD

class HomePageTableViewController: UITableViewController {

    var mainPageVM: MainPageContentViewModel!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        mainPageVM = MainPageContentViewModel()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        //This user default for is fetched main page contents at least once
        let isFetched = UserDefaults.standard.bool(forKey: "isFetchedMainPage")
        if launch == "FirstTime" {
            if !isFetched {
                let locationID = UserDefaults.standard.string(forKey: "CurrentLocation")
                getHomePageContents(locationID: locationID!)
                UserDefaults.standard.set(true, forKey: "isFetchedMainPage")
            } else {
                mainPageVM.loadMainPageContents()
                tableView.reloadData()
            }
        } else {
            let changeState = UserDefaults.standard.bool(forKey: "isChange")
            if changeState {
                mainPageVM.clearMainPageContentCache()
                let locationID = UserDefaults.standard.string(forKey: "CurrentLocation")
                getHomePageContents(locationID: locationID!)
                UserDefaults.standard.set(false, forKey: "isChange")
            } else {
                //Realm Read Data
                mainPageVM.loadMainPageContents()
                tableView.reloadData()
            }
        }
        
    }
    
    func getHomePageContents(locationID: String){
        DispatchQueue.main.async {
            KRProgressHUD.show(withMessage: "Please wait getting your contents")
        }
        let locationJSONModel = LocationJSONModel(id: locationID)
        APIClient.sharedInstance.getMainPageContent(location: locationJSONModel) { (result) in
            switch result {
            case .failure(let error):
                print(error.localizedDescription)
            case .success(let contents):
                DispatchQueue.main.async {
                    _ = contents.map({
                        let mainPageContent = MainPageContentCache()
                        mainPageContent.name = $0.name
                        mainPageContent.title = $0.title
                        mainPageContent.descrpt = $0.description
                        mainPageContent.mainImageURL = $0.mainImageURL
                        mainPageContent.slideImageURL = $0.slideImageURL
                        mainPageContent.videoURL = $0.videoURL
                        mainPageContent.audioURL = $0.audioURL
                        mainPageContent.text = $0.text
                        self.mainPageVM.saveMainPageContentCache(content: mainPageContent)
                    })
                    self.mainPageVM.loadMainPageContents()
                    self.tableView.reloadData()
                    KRProgressHUD.dismiss()
                }
            }
        }
    }

}

extension HomePageTableViewController {
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 250
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return mainPageVM.mainPageContentsCache?.count ?? 0
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "homePageCell") as! HomePageTableViewCell
        
        let mainPageContent = mainPageVM.mainPageContentsCache?[indexPath.row]
        
        guard let content = mainPageContent else { return UITableViewCell() }
        
        cell.setHomePageContent(content: content)
        
        return cell
        
    }
    
}
