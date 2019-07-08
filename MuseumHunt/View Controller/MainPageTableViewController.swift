//
//  MainPageTableViewController.swift
//  MuseumHunt
//
//  Created by Alperen Ünal on 28.06.2019.
//  Copyright © 2019 Alperen Ünal. All rights reserved.
//

import UIKit

class MainPageTableViewController: UIViewController {
    
    @IBOutlet weak var tableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.delegate = self
        tableView.dataSource = self
    }
}

extension MainPageTableViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        return UITableViewCell()
    }
    
    
}
