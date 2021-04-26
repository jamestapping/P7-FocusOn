//
//  TodayTableViewController.swift
//  FocusOn
//
//  Created by James Tapping on 12/03/2021.
//

import Foundation
import UIKit

class TodayTableViewController: UITableViewController {
    
    @IBAction func didTapAddGoal(_ sender: Any) {
        
        let newGoalID = dataManager.createNewGoal()
        dataManager.createNewTask(goalID: newGoalID)
        
        goals = dataManager.returnTodaysGoals()
        
        tableView.reloadData()
        
        // move to new goal at the bottom
        
        DispatchQueue.main.async {
            let newGoalIndexPath = IndexPath(row: 0, section: self.tableView.numberOfSections - 1)
            self.tableView.scrollToRow(at: newGoalIndexPath, at: .top, animated: true)
        }
        
    }
    
    let untick = UIImage(named: "untick-gray")
    let untickWhite = UIImage(named: "untick-white")
    let midnightBlue = UIColor(named: "MidnightBlue")
    
    var dataManager = DataManager()
    var dateManager = DateManager()
    
    var goals = [Goal]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        print ("Today View  - ViewDidLoad")
        

        configure()
        
        // updateTableView()
        
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        print ("Today View  - ViewDidAppear")
        
       updateTableView()
        
        print (dateManager.startOfDay(for: Date()))
        
    }
    
    func configure() {
        
        // Change navigation bar titles / button fonts
        
        self.navigationController!.navigationBar.titleTextAttributes = [NSAttributedString.Key.font: UIFont(name: "Helvetica Neue Bold", size: 19)!]
        
        UIBarButtonItem.appearance().setTitleTextAttributes([NSAttributedString.Key.font: UIFont(name: "Helvetica Neue", size: 15)!], for: UIControl.State.normal)



        }
    
    func updateTableView() {
        
        print ("Updating TableView ....")
        
        goals = dataManager.returnTodaysGoals()
        
        print ("Return goals count", goals.count)
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.3) {
            self.tableView.reloadData()
        }
        
    }
    

    // MARK: - Table view data source

    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
       
        return tableView.estimatedRowHeight
    }
    
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        
        return goals.count
    }
    

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        let rowsInSection = dataManager.fetchTasksforGoalUUID(goalID: goals[section].goalId!).count
        
        return rowsInSection + 2
    
    }
    
    
    // Disable edit for info cell and last add task cell
    
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        
        let lastRowInSection = tableView.numberOfRows(inSection: indexPath.section) - 1
        
        switch indexPath.row {
        
        case 1, lastRowInSection:
            return false
        
        default:
            return true
        }
        
    }
    
    // Custom Swipe to delete tasks and Goals
    
    override func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
         
        let delete = UIContextualAction(style: .destructive, title: "Delete") { [self] (action, view, completion) in
            
            if indexPath.row == 0 {
                
                deleteGoalCell(indexPath: indexPath)
                
                goals.remove(at: indexPath.section)
                
                let indexSet = IndexSet(arrayLiteral: indexPath.section)
                
                tableView.deleteSections(indexSet, with: .fade)

            } else {
                
                deleteTaskcell(indexPath: indexPath)
                
                tableView.deleteRows(at: [indexPath], with: .fade)
                
                DispatchQueue.main.asyncAfter(deadline: .now() + 0.4) {
                    self.tableView.reloadData()
                }
                
            }
            
                completion(true)
            }
        
        delete.backgroundColor = midnightBlue
         
            let config = UISwipeActionsConfiguration(actions: [delete])
            // config.performsFirstActionWithFullSwipe = true
         
            return config
        }
    
    func deleteTaskcell(indexPath: IndexPath) {
        
        let goalID = goals[indexPath.section].goalId
        let tasks = dataManager.fetchTasksforGoalUUID(goalID: goalID!)
        let task = tasks[indexPath.row - 2]
        
        dataManager.deleteTask(taskId: task.taskId!)
    }
    
    func deleteGoalCell(indexPath: IndexPath) {
        
        let goalID = goals[indexPath.section].goalId
        
        dataManager.deleteGoal(goalId: goalID!)
        
    }
    
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let lastRowInSection = tableView.numberOfRows(inSection: indexPath.section)
        
        switch indexPath.row {
        
        case 0:
            
            let cell = tableView.dequeueReusableCell(withIdentifier: "NewGoalCellID", for: indexPath) as! TodayGoalTableViewCell
            
            let completed = goals[indexPath.section].completed
            
            cell.delegate = self
            
            cell.goalToggleButton.setImage(untickWhite, for: .normal)
            cell.goalToggleButton.isSelected = completed
            cell.goalTextView.text = goals[indexPath.section].name
            
            completed ? cell.goalTextView.strike(type: .single) : cell.goalTextView.unstrike()
            
            return cell
            
        case 1:

            let cell = tableView.dequeueReusableCell(withIdentifier: "InfoCellID", for: indexPath) as! TodayInfoTableViewCell
            
            let uuid = goals[indexPath.section].goalId
            let tasks = dataManager.fetchTasksforGoalUUID(goalID: uuid!)
            
            let numberOfTasks = tasks.count - 1
            let numberOfCompletedTasks = tasks.filter{ $0.completed}.count
            var numberOfTasksToComplete = numberOfTasks - numberOfCompletedTasks
            
            if numberOfTasksToComplete == -1 {
                
                numberOfTasksToComplete = 1
                
            }
            
            if numberOfTasks == 0 {
                
                cell.infoLabel.text = "Add tasks to achieve your goal"
                
            } else {
                
                let pluralize = numberOfTasksToComplete == 1 ? "" : "s"
                cell.infoLabel.text = "\(numberOfTasksToComplete) task\(pluralize) out of \(numberOfTasks) left to achieve your goal"
                
            }

            return cell
            
        case lastRowInSection - 1:
            
            //Add + Task Cell
            
            let cell = tableView.dequeueReusableCell(withIdentifier: "TaskCellID", for: indexPath) as! TodayTaskTableViewCell
            
            cell.delegate = self
            
            cell.taskTextView?.text = ""
            cell.taskTextView.unstrike()
            cell.addTaskButton.isHidden = false
            cell.taskToggleButton.isHidden = true
            cell.taskToggleButton.isSelected = false
            cell.taskTextView.placeholder = ""

            return cell
            
        default:
            
            let cell = tableView.dequeueReusableCell(withIdentifier: "TaskCellID", for: indexPath) as! TodayTaskTableViewCell
        
            cell.delegate = self
            
            let uuid = goals[indexPath.section].goalId
            let tasks = dataManager.fetchTasksforGoalUUID(goalID: uuid!)
            let taskName = tasks[indexPath.row - 2].name
            let completed = tasks[indexPath.row - 2].completed
            
            cell.taskToggleButton.setImage(untick, for: .normal)
            cell.taskToggleButton.isSelected = completed
            cell.taskTextView?.text = taskName
            
            completed ? cell.taskTextView.strike(type: .single) : cell.taskTextView.unstrike()
            
            cell.addTaskButton.isHidden = true
            cell.taskToggleButton.isHidden = false
            cell.taskTextView.placeholder = ""
            
            return cell
        }
    
    }
    
    func scrollToBottom(){
        
        print ("Running Scroll to Bottom")
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
            let indexPath = IndexPath(row: 7, section: 1)
            self.tableView.scrollToRow(at: indexPath, at: .bottom, animated: true)
        }
    }
}

extension TodayTableViewController: TodayGoalCellDelegate, TodayTaskCellDelegate {
    
    
    func moveToBottomOfTableView(cell: TodayTaskTableViewCell) {
        
        let indexPath = self.tableView.indexPath(for: cell)
        
        let section = indexPath?.section
        
        if section == goals.count - 1 {
            
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.4) {
                
                print ("scrollToBottomRow")
                
                let newGoalIndexPath = IndexPath(row: 0, section: self.tableView.numberOfSections - 1)
                self.tableView.scrollToRow(at: newGoalIndexPath, at: .top, animated: true)
            }
            
        }
        
    }

    
    func updateCellHeight() {
        
        tableView.beginUpdates()
        tableView.endUpdates()
    }
    
    func updateGoalCell(cell: TodayGoalTableViewCell) {
        
        
        print ("Updating Goal cell - the array")
        
        let indexPath = self.tableView.indexPath(for: cell)!
        let goalToUpdate = indexPath.section
        
        goals[goalToUpdate].name = cell.goalTextView.text
        goals[goalToUpdate].completed = cell.goalToggleButton.isSelected

        dataManager.updateGoal(goal: goals[goalToUpdate])
        
        tableView.reloadData()
    }
    
    func updateGoalCellCompletion(cell: TodayGoalTableViewCell) {
        
        let indexPath = self.tableView.indexPath(for: cell)!
        let goalToUpdate = indexPath.section
        
        goals[goalToUpdate].name = cell.goalTextView.text
        goals[goalToUpdate].completed = cell.goalToggleButton.isSelected

        dataManager.updateGoal(goal: goals[goalToUpdate])
    }
    
    
    
    func createNewTask(cell: TodayTaskTableViewCell?) {
        
        guard let cell = cell, let indexPath = self.tableView.indexPath(for: cell) else { return }
            
        let goalID = goals[indexPath.section].goalId
        let tasks = dataManager.fetchTasksforGoalUUID(goalID: goalID!)
        
        // Create new task if we're at the last cell in section
        
        if tasks.count >= 1 && tasks.last?.name != "" {
            
            dataManager.createNewTask(goalID: goalID!)
            
        }
        
        updateTableView()
        
    }
    
    func updateTaskcell(task: Task) {
        
        dataManager.updateTask(task: task)
        
    }
    
    func updateTaskCell(cell: TodayTaskTableViewCell?, name: String) {
        
        guard let cell = cell, let indexPath = self.tableView.indexPath(for: cell) else { return }
            
        
        let goalID = goals[indexPath.section].goalId
        let tasks = dataManager.fetchTasksforGoalUUID(goalID: goalID!)
        let task = tasks[indexPath.row - 2]
        
        dataManager.updateTask(task: task, name: name)
        
        // only remove tasks if field is empty and this isn't the last row
            
        if task.name == "" && tasks.count != 1  {
            
            dataManager.deleteTask(taskId: task.taskId!)
            
        }
        
    }
    
    func updateTaskCell(cell: TodayTaskTableViewCell, completed: Bool) {
        
        print ("Updating task cell - completed status")
        
        let indexPath = self.tableView.indexPath(for: cell)!
        let goalID = goals[indexPath.section].goalId
        let tasks = dataManager.fetchTasksforGoalUUID(goalID: goalID!)
        let task = tasks[indexPath.row - 2]
        
        dataManager.updateTask(task: task, completed: completed)
        
        tableView.reloadData()
    }
    
}


