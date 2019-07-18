//
//  CampaignTableViewController.swift
//  MuseumHunt
//
//  Created by Alperen Ünal on 17.07.2019.
//  Copyright © 2019 Alperen Ünal. All rights reserved.
//

import UIKit
import KRProgressHUD
import DGElasticPullToRefresh

class CampaignTableViewController: UITableViewController {

    var campaignVM: CampaignViewModel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        campaignVM = CampaignViewModel()
        
        setupPullToRefresh()
    }
    
    func setupPullToRefresh(){
        navigationController?.navigationBar.isTranslucent = false
        
        let loadingView = DGElasticPullToRefreshLoadingViewCircle()
        loadingView.tintColor = UIColor.flatYellow()
        tableView.dg_addPullToRefreshWithActionHandler({ [weak self] () -> Void in
            // Add your logic here
            // Do not forget to call dg_stopLoading() at the end
            self?.campaignVM.campaigns.removeAll()
            let locationID = UserDefaults.standard.string(forKey: "CurrentLocation")
            self?.fetchCampaigns(locationID: locationID!)
            self?.tableView.dg_stopLoading()
            }, loadingView: loadingView)
        tableView.dg_setPullToRefreshFillColor(UIColor.flatMagenta())
        tableView.dg_setPullToRefreshBackgroundColor(tableView.backgroundColor!)
    }
    
    override func viewDidAppear(_ animated: Bool) {
        campaignVM.campaigns.removeAll()
        let locationID = UserDefaults.standard.string(forKey: "CurrentLocation")
        fetchCampaigns(locationID: locationID!)
    }

    func fetchCampaigns(locationID: String){
        DispatchQueue.main.async {
            KRProgressHUD.show(withMessage: "Please wait for fetching campaigns")
        }
        let locationJSONModel = LocationJSONModel(id: locationID)
        APIClient.sharedInstance.getCampaigns(location: locationJSONModel) { (result) in
            switch result {
            case .failure(let error):
                print(error.localizedDescription)
            case .success(let campaigns):
                DispatchQueue.main.async {
                    self.campaignVM.campaigns.append(contentsOf: campaigns)
                    self.tableView.reloadData()
                    KRProgressHUD.dismiss()
                }
            }
        }
    }

}

extension CampaignTableViewController {
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 250
    }
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return campaignVM.campaigns.count
    }
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let campaign = campaignVM.campaigns[indexPath.row]
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "campaignCell") as! CampaignTableViewCell
        
        cell.setCampaign(campaign: campaign)
        
        return cell
    }
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        performSegue(withIdentifier: "goToCampaignContent", sender: nil)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "goToCampaignContent" {
            if let destinationVC = segue.destination as? CampaignContentViewController {
                if let indexPath = tableView.indexPathForSelectedRow{
                    let campaignContent = campaignVM.campaigns[indexPath.row]
                    
                    destinationVC.campaign = campaignContent
                }
            }
        }
    }
}
