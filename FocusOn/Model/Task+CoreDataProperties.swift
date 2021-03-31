//
//  Task+CoreDataProperties.swift
//  FocusOn
//
//  Created by James Tapping on 15/03/2021.
//
//

import Foundation
import CoreData


extension Task {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Task> {
        return NSFetchRequest<Task>(entityName: "Task")
    }

    @NSManaged public var completed: Bool
    @NSManaged public var name: String?
    @NSManaged public var taskId: UUID?
    @NSManaged public var goal: Goal?

}

extension Task : Identifiable {

}
