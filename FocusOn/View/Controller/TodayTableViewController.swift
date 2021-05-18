//
//  TodayTableViewController.swift
//  FocusOn
//
//  Created by James Tapping on 12/03/2021.
//

import Foundation
import UIKit
import SAConfettiView
import UserNotifications

class TodayTableViewController: UITableViewController {
    
    let untick = UIImage(named: "untick-gray")
    let untickWhite = UIImage(named: "untick-white")
    
    var dataManager = DataManager()
    var dateManager = DateManager()
    var helper = GeneralHelper()

    var goals = [Goal]()
    
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
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        configure()
        
        checkFirstRun()
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        
        checkYesterdaysGoals()
        
    }
    
    func configure() {
        
        registerForKeyboardNotifications()
        scheduleMorningNotification()
        
        // Change navigation bar titles / button fonts
        
        self.navigationController!.navigationBar.titleTextAttributes = [NSAttributedString.Key.font: UIFont(name: "Helvetica Neue Bold", size: 19)!]
        
        UIBarButtonItem.appearance().setTitleTextAttributes([NSAttributedString.Key.font: UIFont(name: "Helvetica Neue", size: 15)!], for: UIControl.State.normal)

        }
    
    // Stop tableview from being hidden by keyboard
    
    func registerForKeyboardNotifications() {
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow), name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide), name: UIResponder.keyboardWillHideNotification, object: nil)
    }

    @objc func keyboardWillShow(notification: NSNotification){
        
        let keyboardFrame = notification.userInfo![UIResponder.keyboardFrameEndUserInfoKey] as! CGRect
        adjustLayoutForKeyboard(targetHeight: keyboardFrame.size.height)
    }

    @objc func keyboardWillHide(notification: NSNotification){
        
        adjustLayoutForKeyboard(targetHeight: 0)
        
    }

    func adjustLayoutForKeyboard(targetHeight: CGFloat){

            tableView.contentInset.bottom = targetHeight
        
    }
    
    func updateTableView() {
        
        goals = dataManager.returnTodaysGoals()
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.3) {
            self.tableView.reloadData()
        }
        
    }
    
    func checkYesterdaysGoals() {
    
        goals = dataManager.returnTodaysGoals()
        
        let today = dateManager.startOfDay(for: Date())
        let yesterday = dateManager.startOfDay(for: Date()).addingTimeInterval(-86400)
        let yesterdaysGoals = dataManager.returnGoalsBetweenDate(from: yesterday, to: today)
        let completedGoals = yesterdaysGoals.filter{ $0.completed }.count
        
        let pluralize = yesterdaysGoals.count == 1 ? "" : "s"
        let pluralize2 = yesterdaysGoals.count == 1 ? "it " : "them"
        
        if goals.count == 0 && yesterdaysGoals.count != 0 && completedGoals == 0 {
            
            self.showAlert(title: "FocusOn",
                           message: "Found uncompleted goal\(pluralize) from yesterday, would you like to use \(pluralize2)?",
                           alertStyle: .alert,
                           actionTitles: ["Yes","No"],
                           actionStyles: [.default, .default],
                           actions: [
                           
                            { [self]_ in
                                
                                for i in 0 ... yesterdaysGoals.count - 1 {
                                     yesterdaysGoals[i].date = dateManager.startOfDay(for: Date())
                                     dataManager.updateGoal(goal: yesterdaysGoals[i])
                                }
                                
                                goals = dataManager.returnTodaysGoals()
                                tableView.reloadData()
                                
                            },
                            
                            { []_ in
                            
                                // Do nothing
                            }
                           ])
            
        }
            
        tableView.reloadData()
    }
    
    func scheduleMorningNotification() {
        
        let identifier = "FocusOnMorning"
        let notificationCenter = UNUserNotificationCenter.current()
        var calendar = Calendar.current
        calendar.timeZone = TimeZone.current

        // delete any scheduled notifications
        notificationCenter.removeDeliveredNotifications(withIdentifiers: [identifier])

        let content = UNMutableNotificationContent()
        content.title = "FocusOn"
        content.body = "Good Morning - Lets set some goals for Today!"
        content.sound = UNNotificationSound.default
           
        // We want to set a date of tomorrow 8am so as not to send a notification if the person uses
        // the app before that time.
        
        let date = calendar.date(bySettingHour: 8, minute: 0, second: 0, of: Date().addingTimeInterval(86400))

        let components = calendar.dateComponents([.day, .hour, .minute, .second], from: date!)
        let trigger = UNCalendarNotificationTrigger(dateMatching: components, repeats: false)
        let request = UNNotificationRequest(identifier: identifier, content: content, trigger: trigger)
           
        // schedule notification
        
        notificationCenter.add(request) { error in
            if let error = error {
                print(error)
                
                return
            }
            
            print("Notification Scheduled")
        }

    }
    
    func showWellDoneAlert() {
        
        // Display Confetti
        
        let confettiView = SAConfettiView(frame: view.bounds)
        confettiView.type = .Star
        view.addSubview(confettiView)
        confettiView.startConfetti()
        
        showAlert(title: "FocusOn",
                       message: "Well Done!",
                       alertStyle: .alert,
                       actionTitles: ["Ok"],
                       actionStyles: [.default],
                       actions: [
                       
                        { []_ in
                        
                            // action /  Stop confetti View
                            
                            confettiView.stopConfetti()
                            confettiView.removeFromSuperview()
                        }
                       ])
    }
    
    func checkFirstRun() {
        
        if helper.isFirstRun() {
            
            showAlert(title: "FocusOn",
                           message: helper.welcomeMessage,
                           alertStyle: .alert,
                           actionTitles: ["Ok"],
                           actionStyles: [.default],
                           actions: [
                           
                            { []_ in
                            
                                // action do nothing.
                                
                            }
                           ])
            
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
        
            delete.backgroundColor = UIColor.midnightBlue
         
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
}

extension TodayTableViewController: TodayGoalCellDelegate, TodayTaskCellDelegate {
    
    func moveToBottomOfTableView(cell: TodayTaskTableViewCell) {
    
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.4) {

            let newGoalIndexPath = IndexPath(row: 0, section: self.tableView.numberOfSections - 1)
            self.tableView.scrollToRow(at: newGoalIndexPath, at: .top, animated: true)
        }
    
    }

    func updateCellHeight() {
        
        tableView.beginUpdates()
        tableView.endUpdates()
    }
    
    func updateGoalCell(cell: TodayGoalTableViewCell) {
        
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
        
        if goals[goalToUpdate].completed == true {

            // Get all tasks for the goal and mark them as completed

            let goalID = goals[goalToUpdate].goalId
            let tasks = dataManager.fetchTasksforGoalUUID(goalID: goalID!)
            
            for i in 0 ..< tasks.count - 1 {
                
                tasks[i].completed = true
                
                dataManager.updateTask(task: tasks[i])
            }
        
            tableView.reloadData()
            
            showWellDoneAlert()
    
        }
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
        
        if completed { showTaskAnimatedMessage(.success) }
                else { showTaskAnimatedMessage(.failure) }
        
        let indexPath = self.tableView.indexPath(for: cell)!
        let goalID = goals[indexPath.section].goalId
        let tasks = dataManager.fetchTasksforGoalUUID(goalID: goalID!)
        let task = tasks[indexPath.row - 2]
        
        dataManager.updateTask(task: task, completed: completed)
        
        // dataManager.updateTask(task: task)
        
        // Check if all tasks completed
        
        let completedCount = tasks.filter{ $0.completed == true }.count
        
        if completedCount == tasks.count - 1 && !goals[indexPath.section].completed  {
            
            showAlert(title: "FocusOn",
                           message: helper.completedAllTasksMessage,
                           alertStyle: .alert,
                           actionTitles: ["Yes","No"],
                           actionStyles: [.default, .default],
                           actions: [
                           
                            { [self]_ in
                            
                                // action 1 , mark goal as completed
                                
                                goals[indexPath.section].completed = true
                                dataManager.updateGoal(goal: goals[indexPath.section])
                                tableView.reloadData()
                                
                                showWellDoneAlert()
                                
                            },
                            
                            { []_ in
                        
                                // Action 2 - Do nothing
                            }
                           ])
            
        } else {
            
            // mark the goal as incomplete
            
            goals[indexPath.section].completed = false
            dataManager.updateGoal(goal: goals[indexPath.section])
            tableView.reloadData()
        }
        
        tableView.reloadData()
    }
}

