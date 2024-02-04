//
//  FastingManager.swift
//  FastingApp
//
//  Created by Hugo Johansson on 2023-10-17.
//

import SwiftUI

struct ContentView: View {
    @EnvironmentObject var fastingManager: FastingManager
    //@State private var selectedFastingPlan: FastingPlan = .intermediate
    @State private var isAddFastingDataViewVisible = false
    @State private var currentView: CurrentView = .data
    @State private var showRestartAlert = false
    @State private var showFastingEndPopup = false
    
    @State private var showingEndFastingAlert = false


    @EnvironmentObject var userSettings: UserSettings
    

    @State private var selectedFastingPlan: FastingPlan = {
        if let savedPlanRawValue = UserDefaults.standard.string(forKey: "savedFastingPlan"),
           let savedPlan = FastingPlan(rawValue: savedPlanRawValue) {
            return savedPlan
        } else {
            return .intermediate // eller något standardvärde
        }
    }()

    
    
    
    
    enum CurrentView {
            case data, trackWeight, ai, profil, Exercise
        }

    var title: String {
        switch fastingManager.fastingState {
        case .notStarted:
            return "Let's get started"
        case .fasting:
            return "You are now fasting"
        case .feeding:
            return "You are now feeding"
        }
    }

    
    
    
    
    
    
    
    
    
    var bottomNavBar: some View {
        HStack {// h-stack for nav-bar
            
            Spacer()
            
            
            //MARK: Profile View bar
            NavigationLink(destination: ProfilView()) {
                Image(systemName: "person.circle")
                    .imageScale(.large)
                    .foregroundColor(.white)
            }
            .buttonStyle(PlainButtonStyle())
            .disabled(currentView == .profil)

            
            //MARK: Divider
            Spacer()
            Divider()
                .frame(height: 20)
                .background(Color.black)
            Spacer()

            
            //MARK: Track weight View bar
            NavigationLink(destination: TrackWeightView()) {
                Image(systemName: "chart.xyaxis.line")
                    .imageScale(.large)
                    .foregroundColor(.white)
            }
            .buttonStyle(PlainButtonStyle())
            .disabled(currentView == .trackWeight)

            
            //MARK: Divider
            Spacer()
            Divider()
                .frame(height: 20)
                .background(Color.black)
            Spacer()
            
            
            //MARK: Exercise Log View bar
            NavigationLink(destination: ExerciseLog()) {
                Image(systemName: "figure.strengthtraining.traditional")
                    .imageScale(.large)
                    .foregroundColor(.white)
            }
            .buttonStyle(PlainButtonStyle())
            .disabled(currentView == .Exercise)
            
            Spacer()
            
        }// H-stack
        .padding(.vertical, 8)
        .padding(.horizontal, 16)
        .background(.ultraThinMaterial)
        .cornerRadius(20)
        .frame(maxWidth: .infinity)
        .shadow(radius: 5)
        .padding(.horizontal, 16)

    }// Nav-stack

    var body: some View {
        NavigationView {
            ZStack {
                //MARK: Background
                CustomBackground()
                content

                    
                VStack {
                        Spacer()
                        bottomNavBar
                    }

            }//Z-Stack
            .environment(\.colorScheme, .light) // Hårdk
            
            
        }
        .accentColor(.white)
        .navigationBarHidden(true)
    
    }

    var content: some View {
        ScrollView {
            VStack(spacing: 40) {

                //MARK: Title
                Text(title)
                    .font(.headline)
                    .foregroundStyle(.white)

                // MARK: Fasting plan Picker
                Picker("Select Fasting Plan", selection: $selectedFastingPlan) {
                    Text(FastingPlan.beginner.rawValue).tag(FastingPlan.beginner)
                    Text(FastingPlan.intermediate.rawValue).tag(FastingPlan.intermediate)
                    Text(FastingPlan.advanced.rawValue).tag(FastingPlan.advanced)
                }
                
                .pickerStyle(SegmentedPickerStyle())
                .onChange(of: selectedFastingPlan) { newValue in
                    // Update the fasting plan when the user makes a selection
                    fastingManager.fastingPlan = newValue
                    UserDefaults.standard.set(newValue.rawValue, forKey: "savedFastingPlan")

                }
                .background(.thinMaterial)
                .disabled(!fastingManager.isPickerEnabled)  // Disable the picker based on fasting state
                

                //MARK: Progressring
                ProgressRing()
                    .environmentObject(fastingManager)
                    .foregroundStyle(.white)

                HStack(spacing: 60) {
                    
                    //MARK: Start Time
                    VStack(spacing: 5) {
                        Text(fastingManager.fastingState == .notStarted ? "Start" : "Started")
                            .opacity(0.7)
                            .foregroundStyle(.white)

                        Text(fastingManager.startTime, format: .dateTime.weekday().hour().minute().second())
                            .fontWeight(.bold)
                            .foregroundStyle(.white)
                        
                    }

                    //MARK: End Time
                    VStack(spacing: 5) {
                        Text(fastingManager.fastingState == .notStarted ? "End" : "Ends")
                            .opacity(0.7)
                            .foregroundStyle(.white)

                        Text(fastingManager.endTime, format: .dateTime.weekday().hour().minute().second())
                            .fontWeight(.bold)
                            .foregroundStyle(.white)
                    }
                    
                }

             
                

                
                
                //MARK: start and end Button
                Button {
                    if fastingManager.fastingState == .fasting {
                        // Visa en alert för att bekräfta att användaren vill avsluta fastan
                        showingEndFastingAlert = true
                    } else {
                        // Starta fastan
                        fastingManager.tuggleFastingState()
                        
                        

                    }
                } label: {
                    Text(fastingManager.fastingState == .fasting ? "End fast" : "Start fasting")
                        .fontWeight(.bold)
                        .padding(.horizontal, 24)
                        .padding(.vertical, 8)
                        .background(.thinMaterial)
                        .cornerRadius(20)
                        .foregroundColor(.white)
                }
                .alert(isPresented: $showingEndFastingAlert) {
                    Alert(
                        title: Text("End Fast"),
                        message: Text("Sure you want to en you fast?"),
                        primaryButton: .destructive(Text("End")) {
                            // Användaren har bekräftat att avsluta fastan
                            fastingManager.toggleFastingState()
                            fastingManager.saveFastingData()  // Spara fastedatan
                            fastingManager.scheduleFastingLoggedNotification()  // Schemalägg notifikationen
                            
                            fastingManager.scheduleEndOfFastingNotification()
                            
                        },
                        secondaryButton: .cancel()
                    )
                }



                       
                 
                  

               

                //MARK: New Restart Fasting button
                Button {
                    if fastingManager.fastingState == .fasting {
                        
                        showRestartAlert = true
                    } else {
                        
                        fastingManager.resetFasting()
                        
                        
                        

                    }
                } label: {
                    Text("Restart fasting")
                        .fontWeight(.bold)
                        .padding(.horizontal, 24)
                        .padding(.vertical, 8)
                        .background(.thinMaterial)
                        .cornerRadius(20)
                        .foregroundColor(.white)
                }
                .alert("End Fasting to restart session", isPresented: $showRestartAlert) {
                    Button("OK", role: .cancel) { }
                }
                
                
                
                
                
                
                //MARK: Fasting record View Bubble
                
                NavigationLink(destination: FastingRecordsView()) {
                    HStack {
                        Image(systemName: "timer.circle")
                            .imageScale(.large)
                            .foregroundColor(.white)

                        Text("Fasting Logs")
                            .foregroundColor(.white)
                            .font(.title)
                    }
                    .frame(width: 300, height: 120)
                    .background(.thinMaterial)
                    .cornerRadius(20)
                }
                
                
                //MARK: Ai GPT View Bubble
                
                NavigationLink(destination: Ai()) {
                    HStack {
                        
                        Image(systemName: "text.bubble" )
                            .imageScale(.large)
                            .foregroundColor(.white)

                        Text("FastingGPT")
                            .foregroundColor(.white)
                            .font(.title)
                    }
                    .frame(width: 300, height: 120)
                    .background(.thinMaterial)
                    .cornerRadius(20)
                }
                
                
                
                
                
                Text("New features and updates will come in time ")
                    .font(.footnote)
                    .foregroundStyle(.white)
                
                
                Spacer()


            }
            
            
        }
    }
}



struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
            .environmentObject(FastingManager())
            .environmentObject(UserSettings())
    }
}
