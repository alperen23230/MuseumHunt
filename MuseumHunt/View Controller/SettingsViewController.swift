//
//  SettingsViewController.swift
//  MuseumHunt
//
//  Created by Alperen Ünal on 1.07.2019.
//  Copyright © 2019 Alperen Ünal. All rights reserved.
//

import UIKit
import Eureka

class SettingsViewController: FormViewController {
    
    var settingsVM: SettingsViewModel!

    override func viewDidLoad() {
        super.viewDidLoad()
        settingsVM = SettingsViewModel()
        setupForm()
    }
    
    //This function setup the form of the Settings UI
    func setupForm(){
        form +++ Section("Location Services")
            <<< PickerInputRow<String>(){row in
                row.title = "Location"
                row.value = "Enable"
                row.options = ["Enable", "Disable"]
                row.onChange({ row in
                    //update the state
                })
                row.cellUpdate({ (cell, row) in
                    //for change text color
                })
            }
            <<< PickerInputRow<String>(){row in
                row.title = "Bluetooth Low Energy"
                row.value = "Enable"
                row.options = ["Enable", "Disable"]
                row.onChange({ row in
                    //update the state
                })
                row.cellUpdate({ (cell, row) in
                    //for change text color
                })
        }
            
         +++ Section("Notifications")
            <<< PickerInputRow<String>(){row in
                row.title = "Notification"
                row.value = "Enable"
                row.options = ["Enable", "Disable"]
                row.onChange({ row in
                    //update the state
                })
                row.cellUpdate({ (cell, row) in
                    //for change text color
                })
        }
        +++ Section("Content Updates")
            <<< ButtonRow(){
                $0.title = "Check for content updates"
                $0.onCellSelection(self.checkContentUpdateClicked)
                $0.cellUpdate({ (cell, row) in
                    //for change text color
                })
        }
    }
    
    //When the content updates button clicked this function works.
    func checkContentUpdateClicked(cell: ButtonCellOf<String>, row: ButtonRow){
        settingsVM.checkContentUpdate()
    }
}
