//
//  DataManager.swift
//  FocusOn
//
//  Created by James Tapping on 15/03/2021.
//

import Foundation
import UIKit
import CoreData

class DataManager {
    
    var dateManager = DateManager()
    
    var date = Date()
    var oneDay = Double()
    
    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    
    func createNewGoal() -> UUID {
        
        let newGoal = Goal(context: context)
        
        newGoal.goalId = UUID()
        newGoal.date = dateManager.today
        newGoal.name = "Set your goal..."
        newGoal.completed = false
    
        saveContext()

        return newGoal.goalId!
    }
    
    func updateGoal(goal: Goal) {
        
        let request = Goal.fetchRequest() as NSFetchRequest<Goal>
        request.predicate = NSPredicate(format: "%K == %@", #keyPath(Goal.goalId), goal.goalId! as CVarArg)
        
        do {
            
            let result = try context.fetch(request)
            if result.count != 0 {
                
                let fetchedGoal = result.first!
                fetchedGoal.name = goal.name
                // fetchedGoal.date = goal.date
                fetchedGoal.completed = goal.completed

                saveContext()
                
            } else { print("Fetch result was empty for specified goal id: \(String(describing: goal.goalId))") }
            
        } catch { print("Fetch on goal id: \(String(describing: goal.goalId)) failed. \(error)") }
        
    }
    
    func returnGoal(goalId: UUID) -> Goal {
        
        let request = Goal.fetchRequest() as NSFetchRequest<Goal>
        request.predicate = NSPredicate(format: "%K == %@", #keyPath(Goal.goalId), goalId as CVarArg)
        
        do {
            
            let result = try context.fetch(request)
            if result.count != 0 {
                
                let fetchedGoal = result.first!
                
                return fetchedGoal
                
            } else { print("Fetch result was empty for specified goal id: \(String(describing: goalId))") }
            
        } catch { print("Fetch on goal id: \(String(describing: goalId)) failed. \(error)") }
        
        return Goal.init()
    }
    
    func createNewTask (goalID: UUID) {
        
        let newTask = Task(context: context)
        
        do {
            
            let request = Goal.fetchRequest() as NSFetchRequest<Goal>

            let pred = NSPredicate(format: "%K == %@", #keyPath(Goal.goalId), goalID as CVarArg)
            
            request.predicate = pred
            
            let result = try context.fetch(request)
            
            if result.count != 0 {
                
                let fetchedGoal = result.first!
                
                newTask.taskId = UUID()
                newTask.name = ""
                newTask.completed = false
                newTask.goal = fetchedGoal
                
                saveContext()
                
            } else { print("Fetch result was empty for specified goal id: \(goalID)") }
        }
            
        catch {
            
            // Warning
            
        }
        
    }
    
    func updateTask(task: Task, completed: Bool) {
        
        let request = Task.fetchRequest() as NSFetchRequest<Task>
        request.predicate = NSPredicate(format: "%K == %@", #keyPath(Task.taskId), task.taskId! as CVarArg)
        
        do {
            
            let result = try context.fetch(request)
            
            if result.count != 0 {
                
                let fetchedTask = result.first
                fetchedTask?.completed = completed
                
                saveContext()
                
            } else { print ("Fetch result was empty for specified task id: \(String(describing: task.taskId))") }
        }
            
        catch {
            
            // Warning
            
        }
        
    }
    
    func updateTask(task: Task) {
        
        let request = Task.fetchRequest() as NSFetchRequest<Task>
        request.predicate = NSPredicate(format: "%K == %@", #keyPath(Task.taskId), task.taskId! as CVarArg)
        
        do {
            
            let result = try context.fetch(request)
            
            if result.count != 0 {
                
                let fetchedTask = result.first
                fetchedTask?.name = task.name
                // fetchedTask?.completed = completed
                
                saveContext()
                
            } else { print ("Fetch result was empty for specified task id: \(String(describing: task.taskId))") }
        }
            
        catch {
            
            // Warning
            
        }
        
        
    }
    
    
    func updateTask(task: Task, name: String) {
        
        let request = Task.fetchRequest() as NSFetchRequest<Task>
        request.predicate = NSPredicate(format: "%K == %@", #keyPath(Task.taskId), task.taskId! as CVarArg)
        
        do {
            
            let result = try context.fetch(request)
            
            if result.count != 0 {
                
                let fetchedTask = result.first
                fetchedTask?.name = name
                // fetchedTask?.completed = completed
                
                saveContext()
                
            } else { print ("Fetch result was empty for specified task id: \(String(describing: task.taskId))") }
        }
            
        catch {
            
            // Warning
            
        }
        
    }
    
    func getFirstGoalUUID() -> UUID{
        
        let testFetchedGoalId:UUID = UUID()
        
        let request = Goal.fetchRequest() as NSFetchRequest<Goal>
        
        do {
            
            let result = try context.fetch(request)
            
            let fetchedGoalId = result.first?.goalId
            
            print ("Fetched GoalID = ", fetchedGoalId as Any )
            
            return fetchedGoalId!
        }
        
        catch {
        
        }
        
        return testFetchedGoalId
    }
    
    
    func returnAllGoals() -> [Goal] {
        
        
        let request = Goal.fetchRequest() as NSFetchRequest<Goal>
        
        do {
            
        let result = try context.fetch(request)
            
            return result
        }
        
        catch {
            
            
            
        }
        
        return []
    }
    
    func returnGoalsBetweenDate(from:Date, to:Date) -> [Goal] {
        
        let request = Goal.fetchRequest() as NSFetchRequest<Goal>
        
        let predicate = NSPredicate(format: "date >= %@ AND date <= %@", dateManager.startOfDay(for: from) as NSDate, dateManager.startOfDay(for: to) as NSDate)
        
        request.predicate = predicate
        
        request.returnsObjectsAsFaults = false
        
        do {
            
        let result = try context.fetch(request)
            
            return result
        }
        
        catch {
            
            // Error ?
            
        }
        
        return []
        
    }
    
    
    func returnTodaysGoals() -> [Goal] {
        
        // Get the current calendar with local time zone
        var calendar = Calendar.current
        calendar.timeZone = NSTimeZone.system
        
        let request = Goal.fetchRequest() as NSFetchRequest<Goal>

        // Get today's beginning & end
        // let dateFrom = calendar.startOfDay(for: Date()) // eg. 2016-10-10 00:00:00
        
        let startDate = dateManager.startOfDay(for: Date())
        
        // print (Date())
        
        print ("from Date", startDate)
        
        let endDate = calendar.date(byAdding: .day, value: 1, to: startDate)
        
        print ("To date", endDate as Any)
        
        // Set predicate as date being today's date
        // let fromPredicate = NSPredicate(format: "%@ >= %@", date as NSDate, dateFrom as NSDate)
        // let toPredicate = NSPredicate(format: "%@ < %@", date as NSDate, dateTo! as NSDate)
        // let datePredicate = NSCompoundPredicate(andPredicateWithSubpredicates: [fromPredicate, toPredicate])
        
        let predicate = NSPredicate(format: "date >= %@ AND date < %@", startDate as NSDate, endDate! as NSDate)
        request.predicate = predicate
        
        request.returnsObjectsAsFaults = false
        
        do {
            
        let result = try context.fetch(request)
            
            return result
        }
        
        catch {
            
            // Error ?
            
        }
        
        return []
    }

    func returnAllGoalsSortedByDate() -> [Goal] {
        
        let request = Goal.fetchRequest() as NSFetchRequest<Goal>
        let sort = NSSortDescriptor(key: #keyPath(Goal.date), ascending: true)
        request.sortDescriptors = [sort]
        
        do {
            
        let result = try context.fetch(request)
            
            return result
        }
        
        catch {
            
            // Error ?
            
        }
        
        return []

        
    }
    
    
    func showAllGoalUUIDs() {
        
        let request = Goal.fetchRequest() as NSFetchRequest<Goal>
        
        do {
            
        let result = try context.fetch(request)
            
            for i in 0 ..< result.count {
                
                print ("Found GoalID", result[i].goalId as Any)
                
            }
            
        }
        
        catch {
            
            
            
        }
    }
    
    func fetchTask(taskID:UUID) -> Task {
        
        var result:[Task] = []
        var first:Task?
        
        do {
            
            let request = Task.fetchRequest() as NSFetchRequest<Task>
            
            let pred = NSPredicate(format: "%K == %@", #keyPath(Task.taskId), taskID as CVarArg)
            
            request.predicate = pred
            
            result = try context.fetch(request)
            
            first = result.first!
            
            return first!
        
        }
        
        
        catch {
        
            // Warning
            
        }
        
        return first!
        
    }
    
    
    func fetchTasksforGoalUUID(goalID: UUID) -> [Task] {
        
       //  print ("Running fetchTasksforGoalUUID")
        
        var result:[Task] = []
        
        do {
            
            let request = Task.fetchRequest() as NSFetchRequest<Task>
            
            let pred = NSPredicate(format: "%K == %@", #keyPath(Task.goal.goalId), goalID as CVarArg)
            
            request.predicate = pred
            
            result = try context.fetch(request)
        
        }
        
        
        catch {
        
            // Warning
            
        }
        
        return result
    }
    
//    func showTasksForGoalUUID(goalID: UUID){
//        
//        do {
//            
//            let request = Task.fetchRequest() as NSFetchRequest<Task>
//            
//            let pred = NSPredicate(format: "%K == %@", #keyPath(Task.goal.goalId), goalID as CVarArg)
//            
//            request.predicate = pred
//            
//            let result = try context.fetch(request)
//            
//             print ("Found \(result.count) tasks")
//            
//            for i in 0 ..< result.count {
//
//                print (result[i].name as Any)
//
//            }
//            
//        }
//        
//        catch {
//            
//            
//        }
//        
//    }
    
    func deleteGoal(goalId: UUID) {
        
        let request = Goal.fetchRequest() as NSFetchRequest<Goal>
        request.predicate = NSPredicate(format: "%K == %@", #keyPath(Goal.goalId), goalId as CVarArg)
        request.returnsObjectsAsFaults = false
        do {
            let result = try context.fetch(request)
            
           //  print ("**** datamanager deleting task")
            
            context.delete(result.first!)
            
            saveContext()
            
        } catch {
            //Warning
        }
        
    }
    
    func deleteTask(taskId: UUID) {
        let request = Task.fetchRequest() as NSFetchRequest<Task>
        request.predicate = NSPredicate(format: "%K == %@", #keyPath(Task.taskId), taskId as CVarArg)
        request.returnsObjectsAsFaults = false
        do {
            let result = try context.fetch(request)
            
            context.delete(result.first!)
            
            saveContext()
            
        } catch {
            
            //Warning
      }
        
    }
    
    func buildTestData(arg: Bool, completion: (Bool) -> ()) {
        
        // Delete all data first
        
        deleteAllData(arg: true) { (success) in
            
            if success {

               // Do nothing

            }
        }
        
        // Some example goal / task names
        
        let testGoals = ["Finish Focus On", "Work on my side project", "Design UI for new app idea"
                         ]
        
        let testTasks = ["Complete second view", "Refactoring", "Test UI", "Update version","Commit to Git",
                         "Create some test data", "Update AppStore description", "Bug fixes", "Documentation"]
        
        var goals = [Goal]()
        var tasks = [Task]()
        
        var goalCounter = 0
        
        // Create 55 days worth of goals
        
        for i in 1 ... 55 {
            
            // Create up to 5 goals per day
            
            let rand = Int.random(in: 1...5)
            for _ in 1 ... rand {
                
                    let newGoalId = createNewGoal()
                
                    goals = returnAllGoals()
                
                    // give all created goals for this day the same date
                
                    goals[goalCounter].date = date
                    updateGoal(goal: goals[goalCounter])
                
                    // createNewTask(goalID: newGoalId)
                
                    goalCounter += 1

                // create a random number of tasks
                
                let rand = Int.random(in: 3...11)
                
                for _ in 1 ... rand {
                    
                    createNewTask(goalID: newGoalId)
                    
                    }
                
               }
            
            // date = Date()
            
            date = dateManager.startOfDay(for: Date())
            
            oneDay = Double(i * 3600 * 24)
            date.addTimeInterval(-oneDay )
            
          }
        
        
        // update Goals titles and tasks titles + Task completion
        
        goals = returnAllGoals()
                
        for i in 0 ..< goals.count {
        
            goals[i].name = testGoals.randomElement()

            tasks = fetchTasksforGoalUUID(goalID: goals[i].goalId!)
            
            for i in 0 ..< tasks.count - 1 {
                
                tasks[i].name = testTasks.randomElement()
                tasks[i].completed = Bool.random()
                updateTask(task: tasks[i])
                
            }
            
            // Complete the goal if required
            
            let completedTasksCount  = tasks.filter { $0.completed == true }.count
            
            let completed = completedTasksCount == tasks.count - 1 ? true : false
            
            goals[i].completed = completed
            
            
        }
        
        completion(arg)
    }
    
    func deleteAllData(arg: Bool, completion: (Bool) -> ()) {
        
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "Goal")
        let batchDeleteRequest = NSBatchDeleteRequest(fetchRequest: fetchRequest)
        
        do {
            try context.execute(batchDeleteRequest)
        }
        catch{
            
            // Error
            
        }
        
        // We also delete tasks (although cascade option should do this), this fixes a coredata error
        
//        fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "Task")
//        batchDeleteRequest = NSBatchDeleteRequest(fetchRequest: fetchRequest)
//
//        do {
//            try context.execute(batchDeleteRequest)
//        }
//        catch{
//
//            // Error
//
//        }

        saveContext()
        
        completion(arg)
    }
    
    
    func saveContext() {
        do {
            try context.save()
        }
        catch {
            print("Save failed: \(error)")
            context.rollback()
        }
    }
    
}
