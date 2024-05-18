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
    @StateObject var userSettings = UserSettings()
    let persistenceController = PersistenceController.shared
    @State private var isActive = false

    // Skapa en instans av NotificationManager
    private let notificationManager = NotificationManager()

    @Environment(\.scenePhase) var scenePhase

    init() {
        // Anpassa navigation bar utseende
        let appearance = UINavigationBarAppearance()
        appearance.configureWithOpaqueBackground()
        appearance.backgroundColor = .clear
        appearance.titleTextAttributes = [.foregroundColor: UIColor.white]
        appearance.largeTitleTextAttributes = [.foregroundColor: UIColor.white]
        UINavigationBar.appearance().standardAppearance = appearance
        UINavigationBar.appearance().scrollEdgeAppearance = appearance
        UINavigationBar.appearance().tintColor = .white // Färg för navigationspilar och "Back" text
        
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
                    .environmentObject(userSettings)
                    .environment(\.managedObjectContext, persistenceController.container.viewContext)
                    .environment(\.colorScheme, .light) // Set to only LightMode
                    
            } else {
                SplashScreenView(isActive: $isActive)
                    .environmentObject(userSettings)
            }
        }
        .onChange(of: scenePhase) { newScenePhase in
            switch newScenePhase {
            case .background:
                print("Appen går i bakgrunden")
                fastingManager.saveFastingState() // Spara staten när appen går i bakgrunden
            case .active:
                print("Appen blir aktiv")
                fastingManager.restoreFastingState() // Återställ staten när appen blir aktiv
            case .inactive:
                print("Appen blir inaktiv")
                // Inga ytterligare åtgärder för inaktiv tillstånd
            @unknown default:
                print("Okänd scenfas upptäckt")
                // Hantera okända fall
            }
        }
    }
}
