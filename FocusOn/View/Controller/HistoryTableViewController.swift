//
//  HistoryTableViewController.swift
//  FocusOn
//
//  Created by James Tapping on 31/03/2021.
//

import UIKit

class HistoryTableViewController: UITableViewController {
    
    struct Pair : Hashable {
        var i : Int
        var j : Int
    }
    
    struct CompletedStat {
        
        var completedInMonth: Int
        var totalForMonth: Int
        
    }
    
    let blueGray = UIColor(named: "BlueGray")
    let midnightBlue = UIColor(named: "MidnightBlue")
    
    var dataManager = DataManager()
    var dateManager = DateManager()
    
    var goals = [Goal]()
    
    var hasIndex : Set<Pair> = []
    var completedStats : [CompletedStat] = []
    var sectionHeaders:[String] = []
    var tempItems:[Goal] = []
    var items:[[Goal]] = []
    var tempDate:String?
    var dateText: String?
    
    
    

    override func viewDidLoad() {
        super.viewDidLoad()

        // Change navigation bar titles font
        
        self.navigationController!.navigationBar.titleTextAttributes = [NSAttributedString.Key.font: UIFont(name: "Helvetica Neue Bold", size: 19)!]
        
        
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        goals = dataManager.returnAllGoalsSortedByDate()
        
        
        // Quick and dirty Debug
        
        for i in 0 ..< goals.count {
            
            print (goals[i].date as Any)
            
        }
        
        buildHistory()
        buildDaysHeaders()
        buildGoalCompletionStats()
        
        tableView.reloadData()
        
    }
    
    func buildGoalCompletionStats() {
        
        var tempMonth = String()
        var goalCounter = 0
        var completedCountForMonth = 0
        
        goals = dataManager.returnAllGoalsSortedByDate()
        
        // No goals ? Return
        
        guard goals.count != 0 else { return }
        
        tempMonth = (goals[goals.count - 1].date?.monthAsString())!
        
        let sequence = stride(from: goals.count - 1, through: 0, by: -1)
        
        for i in sequence {
            
            if goals[i].date?.monthAsString() == tempMonth {
                
                // do nothing except append the month - this is still the same month
                
                if goals[i].completed {
                    
                    completedCountForMonth += 1
                    
                }
                
                goalCounter += 1
                
                
            } else {
                
                
                completedStats.append(CompletedStat(completedInMonth: completedCountForMonth, totalForMonth: goalCounter))
                tempMonth = (goals[i].date?.monthAsString())!
                goalCounter = 0
                completedCountForMonth = 0
                
            }
        
        }
        
        completedStats.append(CompletedStat(completedInMonth: completedCountForMonth, totalForMonth: goalCounter))
        
    }
    
    // Function for building day headers
    
    func buildDaysHeaders() {
        
        tempDate = ""
        hasIndex = []

        for i in 0..<sectionHeaders.count {
            for j in 0..<items[i].count {
                // let name = items[i][j].name
                let date = dateManager.dateAsString(for: items[i][j].date!)
                if tempDate != date {
                    hasIndex.insert(Pair(i: i, j: j))
                    // OR items[i][j].showHeader = true
                    tempDate = date
                } else {
                    // OR items[i][j].showHeader = false
                }
            }
        }
    }
    
    
    // Function to build month headers for the TableView and goals per month
    
    func buildHistory() {
        
        var tempMonth = String()
        
        completedStats  = []
        
        sectionHeaders = []
        
        tempItems = []
        
        items = []
        
        goals = dataManager.returnAllGoalsSortedByDate()
        
        // No goals? Return
        
        guard goals.count > 0 else { return }
        
        tempMonth = (goals[goals.count - 1].date?.monthAsString())!
        
        let sequence = stride(from: goals.count - 1, through: 0, by: -1)
        
        for i in sequence  {
            
            if goals[i].date?.monthAsString() == tempMonth {
                
                // do nothing except append the month - this is still the same month
                
                tempItems.append(goals[i])
                
            } else {
                
                items.append(tempItems)
                
                // reset tempItems
                
                tempItems = []
                
                sectionHeaders.append(tempMonth)
                
                // completedStats.append(CompletedStat(completedInMonth: 0, totalInMonth: goalsPerMonth))
                
                tempMonth = (goals[i].date?.monthAsString())!

            }
        }
        
        
        // add the last month header and last months items (goals)
        
        sectionHeaders.append(tempMonth)
        
        items.append(tempItems)
        
    }
    
    
    
    // MARK: - Table view data source
    
    override func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {

            let headerView = UIView(frame: CGRect(x: 0, y: 0, width: UIScreen.main.bounds.width, height: 0))
            headerView.backgroundColor = blueGray
            let label = UILabel(frame: CGRect(x: 0, y: 4, width: UIScreen.main.bounds.width, height: 20))
            label.textColor = midnightBlue
            label.font =  UIFont(name: "Helvetica Neue", size: 17)

            let totalForMonth = completedStats[section].totalForMonth
            let completedForMonth = completedStats[section].completedInMonth
        
            label.text = "\(sectionHeaders[section]) - \(completedForMonth) of \(totalForMonth) goals completed"

            label.textAlignment = .center
            headerView.addSubview(label)

            return headerView

        }
    

//    override func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
//
//        // return sectionHeader.contains(section) ? 60 : 0
//
//        return  60
//    }
    
//    override func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
//        return section == 1 ? nil : nil
//    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        let goal = items[indexPath.section][indexPath.row]
        
        performSegue(withIdentifier: "historyDetailVC", sender: goal)
        
    }
    
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        
        return sectionHeaders.count
    }


    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return items[section].count
        
    }

    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "historyGoalCell", for: indexPath)
        let name = items[indexPath.section][indexPath.row].name
        let date = dateManager.dateAsString(for: items[indexPath.section][indexPath.row].date!)
        
        if hasIndex.contains(Pair(i: indexPath.section, j: indexPath.row)) {
                cell.textLabel?.text = date
            
            } else {
                
                cell.textLabel?.text = ""
            }
            
            cell.detailTextLabel?.text = name
    
        
        return cell
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        if segue.identifier == "historyDetailVC" {
            let destinationVC = segue.destination as! HistoryDetailTableViewController
                destinationVC.recievedGoal = sender as? Goal
                
        }
        
    }

}


