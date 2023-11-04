//
//  CoreDataManager.swift
//  FastingApp
//
//  Created by Hugo Johansson on 2023-11-03.
//

import Foundation
import CoreData

class CoreDataManager {
    static let shared = CoreDataManager()
    let persistentContainer: NSPersistentContainer

    init() {
        persistentContainer = NSPersistentContainer(name: "TotalFastingRecord")  // Ändra "DinDatabasNamn" till det faktiska namnet på din Core Data databas
        persistentContainer.loadPersistentStores { (_, error) in
            if let error = error {
                fatalError("Failed to load Core Data stack: \(error)")
            }
        }
        print("Core Data file URL: \(persistentContainer.persistentStoreDescriptions.first?.url)")

    }

    func saveContext() {
        let context = persistentContainer.viewContext
        if context.hasChanges {
            do {
                try context.save()
            } catch {
                print("Failed to save context: \(error)")
            }
        }
    }

    func addFastingRecord(startDate: Date, endDate: Date, fastingPlan: String, notes: String? = nil) {
        let context = persistentContainer.viewContext
        let record = FastingSession(context: context)
        record.startDate = startDate
        record.endDate = endDate
        record.duration = endDate.timeIntervalSince(startDate)
        record.fastingPlan = fastingPlan
        record.notes = notes
        saveContext()
    }

    // Lägg till funktioner för att hämta data här, t.ex. att få en lista av alla fasta sessioner
    
    func printAllFastingRecords() {
        let context = persistentContainer.viewContext
        let fetchRequest = NSFetchRequest<FastingSession>(entityName: "FastingSession")
        
        do {
            let records = try context.fetch(fetchRequest)
            for record in records {
                print(record)
            }
        } catch {
            print("Failed to fetch fasting records: \(error)")
        }
    }

    
    func fetchAllFastingSessions() -> [FastingSession] {
        let context = persistentContainer.viewContext
        let fetchRequest: NSFetchRequest<FastingSession> = FastingSession.fetchRequest()
        do {
            return try context.fetch(fetchRequest)
        } catch {
            print("Error fetching sessions: \(error)")
            return []
        }
    }

    
    
}
