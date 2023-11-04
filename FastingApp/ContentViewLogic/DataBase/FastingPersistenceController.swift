//
//  FastingPersistenceController.swift
//  FastingApp
//
//  Created by Hugo Johansson on 2023-11-03.
//

import Foundation
import CoreData

struct FastingPersistenceController {
    static let shared = FastingPersistenceController()

    let container: NSPersistentContainer

    init() {
        container = NSPersistentContainer(name: "TotalFastingRecord")
        container.loadPersistentStores(completionHandler: { (storeDescription, error) in
            if let error = error as NSError? {
                fatalError("Otillåten fel: \(error), \(error.userInfo)")
            }
        })
    }
}
