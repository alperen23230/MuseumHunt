//
//  SettingsViewController.swift
//  MuseumHunt
//
//  Created by Alperen Ünal on 1.07.2019.
//  Copyright © 2019 Alperen Ünal. All rights reserved.
//

import UIKit
import Eureka
import CoreBluetooth

class SettingsViewController: FormViewController {
    
    var settingsVM: SettingsViewModel!
    
    var isBluetoothOpen = false
    
    var bluetoothState = "Disable"
    
    var manager:CBCentralManager!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
       
        
        isBluetoothOpen = UserDefaults.standard.bool(forKey: "isBluetoothOpen")
        if isBluetoothOpen {
            bluetoothState = "Enable"
        } else {
            bluetoothState = "Disable"
        }
        settingsVM = SettingsViewModel()
        setupForm()
    }
    

    
    @objc func openBluetooth(alert: UIAlertAction){
        let url = URL(string: "App-Prefs:root=Bluetooth") //for bluetooth setting
        let app = UIApplication.shared
        app.open(url!, options: [:])
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
                row.value = bluetoothState
                row.options = ["Enable", "Disable"]
                row.onChange({ row in
                    //update the state
                    if row.value == "Enable" {
                        UserDefaults.standard.set(true, forKey: "isBluetoothOpen")
                        if currentBluetoothState == "Off" {
                            let alert = UIAlertController(title: "Settings",
                                                          message: "Please open your bluetooth for use this feature",
                                                          preferredStyle: UIAlertController.Style.alert)
                            
                            alert.addAction(UIAlertAction(title: "Open Settings",
                                                          style: UIAlertAction.Style.default,
                                                          handler: self.openBluetooth))
                            alert.addAction(UIAlertAction(title: "Cancel",
                                                          style: UIAlertAction.Style.default,
                                                          handler: nil))
                            self.present(alert, animated: true)
                        }
                    } else {
                        UserDefaults.standard.set(false, forKey: "isBluetoothOpen")
                    }
                })
                row.cellUpdate({ (cell, row) in
                    //for change text color
                    if row.value == "Enable" {
                        cell.textLabel?.textColor = .green
                    } else {
                        cell.textLabel?.textColor = .red
                    }
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
