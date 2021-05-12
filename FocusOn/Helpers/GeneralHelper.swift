//
//  GeneralHelpers.swift
//  FocusOn
//
//  Created by James Tapping on 08/05/2021.
//

import Foundation

struct GeneralHelper {
    
    let welcomeMessage = "Welcome to FocusOn! Get started by creating a goal by tapping the + sign in the top right hand corner. Give your goal a title and add some tasks. Have fun! "
    let completedAllTasksMessage = "You have completed all tasks, shall I mark the goal as completed?"
    
    func isFirstRun() -> Bool {
        
        let userDefaults = UserDefaults.standard
        
        let firstRunTest = userDefaults.bool(forKey: "isFirstRun")
        
        if firstRunTest == false {
            
            userDefaults.setValue(true, forKey: "isFirstRun")
            
            return true
            
        } else {
            
            return false
        }
        
      }
    
}
