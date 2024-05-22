//
//  Settings.swift
//  FastingApp
//
//  Created by Hugo Johansson on 2024-01-09.
//

import SwiftUI

struct Settings: View {
    @State private var notificationsEnabled = false
    @State private var selectedGradient = GradientOption.purple
    
    @EnvironmentObject var userSettings: UserSettings
    
    var body: some View {
        NavigationView {
            ZStack {
                CustomBackground()
                
                VStack {
                    Image(systemName: "transmission")
                        .font(.system(size: 70))
                        .imageScale(.large)
                        .foregroundColor(.white)
                        .padding(.top, 16) // Adjust top padding to accommodate navigation bar
                    
                    Text("Choose Background Color")
                        .foregroundStyle(.white)
                        .font(.headline)
                        .fontWeight(.bold)
                        .padding(.top, 16) // Adjust top padding
                    
                    Picker("Välj Bakgrund", selection: $userSettings.selectedGradient) {
                        ForEach(GradientOption.allCases, id: \.self) { option in
                            Text(option.rawValue).tag(option)
                        }
                    }
                    .pickerStyle(SegmentedPickerStyle())
                    .padding()
                    
                    Toggle("Enable Notifications", isOn: $notificationsEnabled)
                        .padding()
                        .onChange(of: notificationsEnabled) { newValue in
                            toggleNotifications(enabled: newValue)
                        }
                    
                    Spacer()
                    
                    Text("New features and updates will come in time")
                        .font(.footnote)
                        .foregroundStyle(.white)
                } // VStack
                .padding(.horizontal)
                .padding(.top, 16) // Adjust top padding
            }
            .navigationViewStyle(StackNavigationViewStyle())
            .environment(\.colorScheme, .light) // Hardcoded color scheme
        }
        .onAppear {
            checkNotificationStatus()
        }
    }
    
    private func checkNotificationStatus() {
        UNUserNotificationCenter.current().getNotificationSettings { settings in
            DispatchQueue.main.async {
                self.notificationsEnabled = (settings.authorizationStatus == .authorized)
            }
        }
    }
    
    private func toggleNotifications(enabled: Bool) {
        if enabled {
            UNUserNotificationCenter.current().requestAuthorization(options: [.alert, .sound, .badge]) { granted, _ in
                DispatchQueue.main.async {
                    self.notificationsEnabled = granted
                }
            }
        } else {
            // Logic to revoke notification permission if needed
        }
    }
}
    
// Preview
struct Settings_Previews: PreviewProvider {
    static var previews: some View {
        Settings()
            .environmentObject(UserSettings())  // Provide an instance of UserSettings here
    }
}

enum GradientOption: String, CaseIterable {
    case purple = "Purple"
    case blue = "Blue"
    case green = "Green/Purple"
    
    var colors: [Color] {
        switch self {
        case .purple:
            return [Color("DarkPurple"), Color("purpleDark"), Color("darkPink")]
        case .blue:
            return [Color("darkBack"), Color("blueBack"), Color("babyBlue")]
        case .green:
            return [Color("darkBack"), Color("lightDarkBack"), Color("mintBack")]
        }
    }
}
