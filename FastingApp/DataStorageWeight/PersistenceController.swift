//
//  PersistenceController.swift
//  FastingApp
//
//  Created by Hugo Johansson on 2023-10-30.
//

import Foundation


import CoreData


// structure responsible for seting up and managing the Core Data stack, and reachable from anywere
struct PersistenceController {
    static let shared = PersistenceController()

    let container: NSPersistentContainer

    init() {
        container = NSPersistentContainer(name: "WeightTracker")
        container.loadPersistentStores { (storeDescription, error) in
            if let error = error as NSError? {
                fatalError("Unresolved error \(error), \(error.userInfo)")
            }
        }
    }
}
