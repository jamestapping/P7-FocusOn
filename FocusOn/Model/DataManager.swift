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
    
    func createNewTask (goalID: UUID) {
        
        let newTask = Task(context: context)
        
        do {
            
            let request = Goal.fetchRequest() as NSFetchRequest<Goal>
            // let pred = NSPredicate(format: "goalID CONTAINS 'test'")

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
        
//            print (result.count)
//
//            print ("Return all goals: ")
            
//            for i in 0 ..< result.count {
//
//                // print ("name", result[i].name as Any)
//
//            }
            
            return result
        }
        
        catch {
            
            
            
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
            
            // print ("*** Datamanager fetchTasksforGoalUUID Found \(result.count) tasks")
            
//            for i in 0 ..< result.count {
//
//                print (result[i].taskId as Any)
//                print (result[i].name as Any)
//
//            }
            
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
            
            // print ("*** Datamanager fetchTasksforGoalUUID Found \(result.count) tasks")
            
//            for i in 0 ..< result.count {
//
//                print (result[i].taskId as Any)
//                print (result[i].name as Any)
//
//            }
        
        }
        
        
        catch {
        
            // Warning
            
        }
        
        return result
    }
    
    func showTasksForGoalUUID(goalID: UUID){
        
        do {
            
            let request = Task.fetchRequest() as NSFetchRequest<Task>
            
            let pred = NSPredicate(format: "%K == %@", #keyPath(Task.goal.goalId), goalID as CVarArg)
            
            request.predicate = pred
            
            let result = try context.fetch(request)
            
             print ("Found \(result.count) tasks")
            
            for i in 0 ..< result.count {

                print (result[i].name as Any)

            }
            
        }
        
        catch {
            
            
        }
        
    }
    
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
            
           //  print ("**** datamanager deleting task")
            
            context.delete(result.first!)
            
            saveContext()
            
        } catch {
            //Warning
        }
        
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
