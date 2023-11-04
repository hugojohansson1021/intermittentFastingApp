//
//  FastingSession+CoreDataProperties.swift
//  FastingApp
//
//  Created by Hugo Johansson on 2023-11-03.
//
//

import Foundation
import CoreData


extension FastingSession {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<FastingSession> {
        return NSFetchRequest<FastingSession>(entityName: "FastingSession")
    }

    @NSManaged public var startDate: Date?
    @NSManaged public var endDate: Date?
    @NSManaged public var duration: Double
    @NSManaged public var fastingPlan: String?
    @NSManaged public var notes: String?

}

extension FastingSession : Identifiable {

}
