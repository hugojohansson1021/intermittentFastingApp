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

    var body: some Scene {
        WindowGroup {
            ContentView()
                .environmentObject(fastingManager)
                
        }
    }
}
