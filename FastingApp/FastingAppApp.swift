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
    @State private var isActive = false  // State to control the transition

    var body: some Scene {
        WindowGroup {
            if isActive {
                ContentView()
                    .environmentObject(fastingManager)
                    .environment(\.managedObjectContext, persistenceController.container.viewContext)
            } else {
                SplashScreenView(isActive: $isActive)
            }
        }
    }
}
