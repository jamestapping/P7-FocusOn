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
        // #warning Incomplete implementation, return the number of sections
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        
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
    

    /*
    // Override to support conditional editing of the table view.
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return true
    }
    */

    /*
    // Override to support editing the table view.
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            // Delete the row from the data source
            tableView.deleteRows(at: [indexPath], with: .fade)
        } else if editingStyle == .insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        }    
    }
    */

    /*
    // Override to support rearranging the table view.
    override func tableView(_ tableView: UITableView, moveRowAt fromIndexPath: IndexPath, to: IndexPath) {

    }
    */

    /*
    // Override to support conditional rearranging of the table view.
    override func tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the item to be re-orderable.
        return true
    }
    */

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
