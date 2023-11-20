//
//  FastingAppApp.swift
//  FastingApp
//
//  Created by Hugo Johansson on 2023-10-17.
//

import SwiftUI
import UserNotifications

@main
struct FastingAppApp: App {
    @StateObject var fastingManager = FastingManager(initialFastingPlan: .intermediate)
    let persistenceController = PersistenceController.shared
    @State private var isActive = false

    // Skapa en instans av NotificationManager
    private let notificationManager = NotificationManager()

    init() {
        // Begär tillstånd för notifikationer
        UNUserNotificationCenter.current().requestAuthorization(options: [.alert, .sound, .badge]) { granted, error in
            if granted {
                print("Notifikationstillstånd beviljat")
            } else if let error = error {
                print("Fel vid begäran om notifikationstillstånd: \(error)")
            }
        }

        
    }

    var body: some Scene {
        WindowGroup {
            if isActive {
                ContentView()
                    .environmentObject(fastingManager)
                    .environment(\.managedObjectContext, persistenceController.container.viewContext)
                    .environment(\.colorScheme, .light)//set to only LightMode
            } else {
                SplashScreenView(isActive: $isActive)
            }
        }
    }
}
