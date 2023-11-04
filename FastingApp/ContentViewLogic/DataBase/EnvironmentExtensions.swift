//
//  EnvironmentExtensions.swift
//  FastingApp
//
//  Created by Hugo Johansson on 2023-11-03.
//

import SwiftUI
import CoreData

struct FastingManagedObjectContextKey: EnvironmentKey {
    static let defaultValue: NSManagedObjectContext = NSManagedObjectContext(concurrencyType: .mainQueueConcurrencyType)
}

extension EnvironmentValues {
    var fastingManagedObjectContext: NSManagedObjectContext {
        get { self[FastingManagedObjectContextKey.self] }
        set { self[FastingManagedObjectContextKey.self] = newValue }
    }
}

