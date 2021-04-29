//
//  SettingsTableViewController.swift
//  FocusOn
//
//  Created by James Tapping on 06/04/2021.
//

import UIKit

class SettingsTableViewController: UITableViewController {

    let dataManager = DataManager()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        

    }
    
    @IBOutlet weak var spinner: UIActivityIndicatorView!
    @IBOutlet weak var createTestData: UILabel!
    
    
    
    // MARK: - Table view data source

    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        switch indexPath.row {
        
        case 0:
            
            self.showAlert(title: "FocusOn",
                           message: "This will also delete all current data, are you sure?",
                           alertStyle: .alert,
                           actionTitles: ["Yes","No"],
                           actionStyles: [.default, .default],
                           actions: [
                           
                            { [self]_ in
                                
                                DispatchQueue.main.async {
                                    
                                    spinner.startAnimating()
                                    view.isUserInteractionEnabled = false
                                    
                                }
                                
                                DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) {
                                    
                                    dataManager.buildTestData(arg: true) { (success) in

                                        if success {

                                            view.isUserInteractionEnabled = true
                                            spinner.stopAnimating()
                                            
                                            self.showAlert(title: "FocusOn",
                                                           message: "Test data created",
                                                           alertStyle: .alert,
                                                           actionTitles: ["Ok"],
                                                           actionStyles: [.default],
                                                           actions: [

                                                            { [self]_ in

                                                                navigationController?.popToRootViewController(animated: true)

                                                            }

                                                           ])

                                        }
                                    }
                                    
                                }
                                
                                
                            },
                            
                            { []_ in
                                
                            
                                // Action 2
                            
                                // Do nothing 
                           
                            }
                           ])
            
        case 1:
            
            self.showAlert(title: "FocusOn",
                           message: "This will delete all data, are you sure?",
                           alertStyle: .alert,
                           actionTitles: ["Yes","No"],
                           actionStyles: [.default, .default],
                           actions: [
                           
                            { [self]_ in
                            
                                
                                deleteAllDataWithPrompt()
                                
                                
                            },
                            
                            { []_ in
                                
                            
                                // Action 2
                            
                                // Do nothing
                           
                            }
                           ])
            
        default:
            
            return
        }
    }
    
    // Split this out to make things clearer
    
    func deleteAllDataWithPrompt() {
        
        dataManager.deleteAllData(arg: true) { (success) in
            
            
            if success {
                
                self.showAlert(title: "FocusOn",
                               message: "All data deleted",
                               alertStyle: .alert,
                               actionTitles: ["Ok"],
                               actionStyles: [.default],
                               actions: [
                               
                                { [self]_ in
                                    
                                    navigationController?.popToRootViewController(animated: true)
                                    
                                }
                               
                               ])
                    }
            }
    }
}


