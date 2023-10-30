//
//  FastingAppApp.swift
//  FastingApp
//
//  Created by Hugo Johansson on 2023-10-17.
//

import SwiftUI

@main
struct FastingAppApp: App {
    @StateObject var fastingManager = FastingManager(initialFastingPlan: .intermediate)
    let persistenceController = PersistenceController.shared
    

    var body: some Scene {
        WindowGroup {
            ContentView()
                .environmentObject(fastingManager)
                .environment(\.managedObjectContext, persistenceController.container.viewContext)
                
                
        }
    }
}
