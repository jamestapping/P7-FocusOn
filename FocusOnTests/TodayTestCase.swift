//
//  TodayTestCase.swift
//  FocusOnTests
//
//  Created by James Tapping on 05/05/2021.
//

import XCTest
@testable import FocusOn

class TodayTestCase: XCTestCase {

    var dataManager: DataManager!
 
    override func setUp() {
        super.setUp()
    
        dataManager = DataManager()
        
        deleteAllData()
        
    }
    
    override func tearDown() {
        
        deleteAllData()
    }
    
    // Helper
    
    func deleteAllData() {
        
        dataManager.deleteAllData(arg: true) { (success) in
            
            //
        }
        
    }
    
    // Test and confirm goal creation
    
    func testGivenZeroGoalsExist_whenGoalsAreCreated_correctNumberOfGoalsReturned() {
        
        for _ in 0...9 {
            
            _ = dataManager.createNewGoal()
            
        }
        
        let result = dataManager.returnAllGoals()
        
        XCTAssert(result.count == 10)
        
        
    }
    
    // Test add and delete tasks
    
    func testGivenGoalHasZeroTasks_whenTasksAddedToGoal_correctNumberOfTasksReturned() {
        
        let newGoalID = dataManager.createNewGoal()
        
        // Create 3 tasks
        
        dataManager.createNewTask(goalID: newGoalID)
        dataManager.createNewTask(goalID: newGoalID)
        dataManager.createNewTask(goalID: newGoalID)
        
        let tasksForGoal = dataManager.fetchTasksforGoalUUID(goalID: newGoalID)
        
        XCTAssert(tasksForGoal.count == 3)
        
    }
    
    // Test renaming a task
    
    func testGivenTaskHasDefaultName_whenTaskNameUpdated_confirmTaskNameChanged() {
        
        let testTaskName = "Xcode Test Task"
        
        // Create a new goal
        
        let newGoalID = dataManager.createNewGoal()
        
        // Create a task
        
        dataManager.createNewTask(goalID: newGoalID)
        
        let tasks = dataManager.fetchTasksforGoalUUID(goalID: newGoalID)
        
        let task = tasks[0]
        
        // update the task name
        
        task.name = testTaskName
        dataManager.updateTask(task: task)
        
        // retrieve the updated task
        
        let updatedTasks = dataManager.fetchTasksforGoalUUID(goalID: newGoalID)
        
        let updatedTask = updatedTasks[0]
        
        XCTAssertEqual(updatedTask.name , testTaskName )
        
    }
    
    
    // Test renaming a goal
    
    func testGivenGoalHasDefaultName_whenGoalNameUpdated_confirmGoalNameChanged() {
        
        let testGoalName = "Xcode Test Goal"
        
        // Create a new goal and retrieve it
        
        let newGoalID = dataManager.createNewGoal()
        let newGoal = dataManager.returnGoal(goalId: newGoalID)
        
        // Update the goal name
        
        newGoal.name = testGoalName
        dataManager.updateGoal(goal: newGoal)
        
        // Retreive the goal and verify it's name
        
        let updatedGoal = dataManager.returnGoal(goalId: newGoalID)
        
        XCTAssert(updatedGoal.name == testGoalName)
        
    }
    
    // Test remove a specific task
    
    func testGivenGoalHasThreeTasks_whenOneTaskRemoved_confirmTwoTasksRemaining() {
        
        let newGoalID = dataManager.createNewGoal()
        
        // Create 3 tasks
        
        dataManager.createNewTask(goalID: newGoalID)
        dataManager.createNewTask(goalID: newGoalID)
        dataManager.createNewTask(goalID: newGoalID)
        
        let tasks = dataManager.fetchTasksforGoalUUID(goalID: newGoalID)
        
        // Delete the second task
        
        dataManager.deleteTask(taskId: tasks[1].taskId!)
        
        let updatedTasks = dataManager.fetchTasksforGoalUUID(goalID: newGoalID)
        
        XCTAssert(updatedTasks.count == 2)
        
    }
    
    // Test goal completed status changed (False to True)
    
    func testGivenGoalHasUncompletedStatus_whenUpdatedToCompleted_confirmCompletedStatus() {
        
        // Create a new goal and retrieve it
        
        let newGoalID = dataManager.createNewGoal()
        let newGoal = dataManager.returnGoal(goalId: newGoalID)
        
        newGoal.completed = true
        
        dataManager.updateGoal(goal: newGoal)
        
        // Retrieve the goal
        
        let updatedGoal = dataManager.returnGoal(goalId: newGoalID)
        
        XCTAssertEqual(updatedGoal.completed, true)
        
    }
    
    
    func testDeleteAllData() {
        
        // create some test data
        
        dataManager.buildTestData(arg: true) { (success) in
            
            //
        }
        
        // Delete all Data
        
        deleteAllData()
        
        let result = dataManager.returnAllGoals()
        
        XCTAssert(result.count == 0)
        
    }
}
