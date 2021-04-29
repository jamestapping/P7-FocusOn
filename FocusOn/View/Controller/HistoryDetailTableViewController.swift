//
//  HistoryDetailTableViewController.swift
//  FocusOn
//
//  Created by James Tapping on 08/04/2021.
//

import UIKit

class HistoryDetailTableViewController: UITableViewController {

    var recievedGoal:Goal?
    
    var dataManager = DataManager()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
    }

    
    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
    
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        let rowsInSection = dataManager.fetchTasksforGoalUUID(goalID: (recievedGoal?.goalId)!).count
        
        print ("Rows in section", rowsInSection)
        
        return rowsInSection
    }

    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        switch indexPath.row
        
        {
        
        case 0:
            
            let cell = tableView.dequeueReusableCell(withIdentifier: "historyGoalCell", for: indexPath) as! HistoryGoalDetailTableViewCell
            
            let completed = recievedGoal?.completed
            let name = recievedGoal?.name
            
            cell.goalToggleButton.isSelected = completed!
            cell.goalTextView.text = name
            
            completed! ? cell.goalTextView.strike(type: .single) : cell.goalTextView.unstrike()

            return cell
        
        default:
            
            let cell = tableView.dequeueReusableCell(withIdentifier: "historyTaskCell", for: indexPath) as! HistoryTaskTableViewCell
            
            let tasks = dataManager.fetchTasksforGoalUUID(goalID: (recievedGoal?.goalId)!)
            
            let taskName = tasks[indexPath.row - 1].name
            let completed = tasks[indexPath.row - 1].completed
            
            cell.taskTextView.text = taskName
            cell.taskToggleButton.isSelected = completed
            completed ? cell.taskTextView.strike(type: .single) : cell.taskTextView.unstrike()
            
            return cell
        }
        
       
    }
    
}
