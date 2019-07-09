//
//  MainPageTableViewController.swift
//  MuseumHunt
//
//  Created by Alperen Ünal on 28.06.2019.
//  Copyright © 2019 Alperen Ünal. All rights reserved.
//

import UIKit
import KRProgressHUD

class MainPageTableViewController: UITableViewController {
    
    var mainPageContentVM: MainPageContentViewModel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        mainPageContentVM = MainPageContentViewModel()
        
    }
    
    override func viewDidAppear(_ animated: Bool) {
        //This user default for
        let isFetched = UserDefaults.standard.bool(forKey: "isFetchedMainPage")
        if launch == "FirstTime" {
            if !isFetched {
                fetchMainPageContent()
                UserDefaults.standard.set(true, forKey: "isFetchedMainPage")
            } else {
                mainPageContentVM.loadMainPageContents()
                tableView.reloadData()
            }
        } else {
            //Realm Read Data
            mainPageContentVM.loadMainPageContents()
            tableView.reloadData()
        }
    }
    
    func fetchMainPageContent(){
        DispatchQueue.main.async {
            KRProgressHUD.show()
        }
        APIClient.sharedInstance.getMainPageContent { (result) in
            switch result {
            case .failure(let error):
                print(error)
            case .success(let mainPageContents):
                    DispatchQueue.main.async {
                        _ = mainPageContents.map({
                            let mainPageContent = MainPageContentCache()
                            mainPageContent.name = $0.name
                            mainPageContent.title = $0.title
                            mainPageContent.descrpt = $0.description
                            mainPageContent.mainImageURL = $0.mainImageURL
                            mainPageContent.slideImageURL = $0.slideImageURL
                            mainPageContent.videoURL = $0.videoURL
                            mainPageContent.audioURL = $0.audioURL
                            mainPageContent.text = $0.text
                            self.mainPageContentVM.saveMainPageContentCache(content: mainPageContent)
                        })
                        self.mainPageContentVM.loadMainPageContents()
                        self.tableView.reloadData()
                        KRProgressHUD.dismiss()
                    }
            }
        }
    }
}

extension MainPageTableViewController {
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 100
    }
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return mainPageContentVM.mainPageContentsCache?.count ?? 0
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "mainPageContentCell") as! MainPageContentTableViewCell
        
        let mainPageContent = mainPageContentVM.mainPageContentsCache?[indexPath.row]
        
        guard let content = mainPageContent else { return UITableViewCell() }
        
        cell.setMainPageContent(content: content)
        
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        performSegue(withIdentifier: "goToContent", sender: nil)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let destinationVC = segue.destination as? ContentViewController{
            if let indexPath = tableView.indexPathForSelectedRow{
                let mainPageContent = mainPageContentVM.mainPageContentsCache?[indexPath.row]
                
                guard let content = mainPageContent else { return }
                
                destinationVC.content = Content(mainImageURL: content.mainImageURL, title: content.title, videoURL: content.videoURL, slideImageURL: content.slideImageURL, audioURL: content.audioURL, text: content.text)
            }
        }
    }
}
