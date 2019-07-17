//
//  PreferencesTableViewController.swift
//  MuseumHunt
//
//  Created by Alperen Ünal on 17.07.2019.
//  Copyright © 2019 Alperen Ünal. All rights reserved.
//

import UIKit

class PreferencesTableViewController: UITableViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "goToChangeLocation" {
            UserDefaults.standard.set(true, forKey: "isChange")
        }
    }

}
