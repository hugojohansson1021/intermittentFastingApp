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
        
            ZStack {
                CustomBackground()
                
                VStack(spacing: 15) {
                    Image(systemName: "transmission")
                        .font(.system(size: 70)) 
                        .imageScale(.large)
                        .foregroundColor(.white)
                    
                  
                    
                    Text("Settings")
                        .foregroundStyle(.white)
                        .font(.title)
                        .fontWeight(.bold)
                    
                    Spacer()
                    
                    Text("Choose Backgrund Color")
                        .foregroundStyle(.white)
                        .font(.headline)
                        .fontWeight(.bold)
                    
                    Picker("Välj Bakgrund", selection: $userSettings.selectedGradient) {
                                ForEach(GradientOption.allCases, id: \.self) { option in
                                    Text(option.rawValue).tag(option)
                                }
                            }
                            .pickerStyle(SegmentedPickerStyle())
                            .padding()
                    
                   
                    
                    
                    
                    
                    
                    .onChange(of: notificationsEnabled) { newValue in
                        toggleNotifications(enabled: newValue)
                    }
                    
                    Spacer()
                    
                    Text("New features and updates will come in time ")
                        .font(.footnote)
                        .foregroundStyle(.white)
                    
                } // VStack
                
            }//Z-stack
            .environment(\.colorScheme, .light) // Hårdk
        
        
    }//body
    
    
    
    private func checkNotificationStatus() {
            UNUserNotificationCenter.current().getNotificationSettings { settings in
                DispatchQueue.main.async {
                    self.notificationsEnabled = (settings.authorizationStatus == .authorized)
                }
            }
        }
    
    
    
    
    
    private func toggleNotifications(enabled: Bool) {
        if enabled {
            // Begär tillstånd för att skicka notifikationer
            UNUserNotificationCenter.current().requestAuthorization(options: [.alert, .sound, .badge]) { granted, _ in
                if granted {
                    print("Notifikationstillstånd beviljat")
                } else {
                    print("Notifikationstillstånd nekat")
                    DispatchQueue.main.async {
                        self.notificationsEnabled = false
                    }
                }
            }
        } else {
            // Återkalla tillstånd för notifikationer
            // Här kan du lägga till logik för att återkalla tillståndet
        }
        
        
        
        
    }
}
    
    

    // Preview
// Preview
struct Settings_Previews: PreviewProvider {
    static var previews: some View {
        Settings()
            .environmentObject(UserSettings())  // Tillhandahåll en instans av UserSettings här
    }
}

    
enum GradientOption: String, CaseIterable {
    case purple = "Purple"
    case blue = "Blue"
    case green = "Green/Purple"
    // Lägg till fler alternativ här

    
    
    
    var colors: [Color] {
            switch self {
            case .purple:
                return [Color("DarkPurple"), Color("purpleDark"), Color("darkPink")]
            case .blue:
                return [Color("darkBack"), Color("blueBack"), Color("babyBlue")]
            case .green:
                return [Color("darkBack"), Color("lightDarkBack"), Color("mintBack")]
            // Definiera färgerna för andra alternativ här
            }
        }
    
    
    
    
    
    
    
}
