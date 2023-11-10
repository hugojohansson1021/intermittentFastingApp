//
//  FastingManager.swift
//  FastingApp
//
//  Created by Hugo Johansson on 2023-10-17.
//

import SwiftUI




struct ContentView: View {
    @EnvironmentObject var fastingManager: FastingManager
    
    


    @State private var selectedFastingPlan: FastingPlan = .intermediate
    @State private var isAddFastingDataViewVisible = false
    @State private var currentView: CurrentView = .data
    @State private var showRestartAlert = false


    
    
    enum CurrentView {
            case data, trackWeight, ai, profil
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
        HStack {
            Spacer()

            NavigationLink(destination: ProfileView()) {
                Image(systemName: "person.circle")
                    .imageScale(.large)
                    .foregroundColor(.white)
            }
            .buttonStyle(PlainButtonStyle())
            .disabled(currentView == .profil)

            Spacer()

            Divider()
                .frame(height: 20)
                .background(Color.black)

            Spacer()

            NavigationLink(destination: TrackWeightView()) {
                Image(systemName: "chart.xyaxis.line")
                    .imageScale(.large)
                    .foregroundColor(.white)
            }
            .buttonStyle(PlainButtonStyle())
            .disabled(currentView == .trackWeight)

            Spacer()
            
            
            Divider()
                .frame(height: 20)
                .background(Color.black)
            
            Spacer()
            
            NavigationLink(destination: Ai()) {
                Image(systemName: "text.bubble")
                    .imageScale(.large)
                    .foregroundColor(.white)
            }
            .buttonStyle(PlainButtonStyle())
            .disabled(currentView == .ai)
            
            Spacer()
            
        }
        .padding(.vertical, 8)
        .padding(.horizontal, 16)
        .background(.ultraThinMaterial)
        .cornerRadius(20)
        .frame(maxWidth: .infinity)
        .shadow(radius: 5)
        .padding(.horizontal, 16)

    }
    

    var body: some View {
        NavigationView {
            ZStack {
                //MARK: Background
                LinearGradient(gradient: Gradient(colors: [Color.darkPurple, Color.purpleDark, Color.darkPink]), startPoint: .topLeading, endPoint: .bottomTrailing)
                    .ignoresSafeArea()
                content
                    //.padding()
                    //.background(Color.clear)
                VStack {
                        Spacer()
                        bottomNavBar
                    }

            }//Z-Stack
            
            
            
        }
        .accentColor(.white)  // Sätter accentfärgen för NavigationView
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
                         
                               // Start fasting
                               fastingManager.toggleFastingState()
                           
                       } label: {
                           Text(fastingManager.fastingState == .fasting ? "End fast" : "Start fasting")
                               .fontWeight(.bold)
                               .padding(.horizontal, 24)
                               .padding(.vertical, 8)
                               .background(.thinMaterial)
                               .cornerRadius(20)
                               .foregroundColor(.white)
                       }
                       
                 
                  

               

                //MARK: New Restart Fasting button
                Button {
                    if fastingManager.fastingState == .fasting {
                        // Om fastan pågår, visa toasten
                        showRestartAlert = true
                    } else {
                        //  fitt kod asså Om inte, restarta fastan som vanligt
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
                
                
                
                
                
                
                NavigationLink(destination: InfoViews()) {
                    HStack {
                        Image(systemName: "info.bubble")
                            .imageScale(.large)
                            .foregroundColor(.white)

                        Text("info")
                            .foregroundColor(.white)
                            .font(.title) // Anpassa fontstorleken här
                    }
                    .frame(width: 300, height: 120)
                    .background(.thinMaterial)
                    .cornerRadius(20)
                }
                
                
                
                
                NavigationLink(destination: ExerciseSearchView()) {
                    HStack {
                        Image(systemName: "figure.strengthtraining.traditional")
                            .imageScale(.large)
                            .foregroundColor(.white)

                        Text("Exersciese")
                            .foregroundColor(.white)
                            .font(.title) // Anpassa fontstorleken här
                    }
                    .frame(width: 300, height: 120)
                    .background(.thinMaterial)
                    .cornerRadius(20)
                }

                
                
                
                
                NavigationLink(destination: TrackWeightView()) {
                    HStack {
                        Image(systemName: "cross.vial")
                            .imageScale(.large)
                            .foregroundColor(.white)

                        Text("Vitamins")
                            .foregroundColor(.white)
                            .font(.title) // Anpassa fontstorleken här
                    }
                    .frame(width: 300, height: 120)
                    .background(.thinMaterial)
                    .cornerRadius(20)
                }
                
                
                
                
                
                Spacer()

                

                
                
                



               
            }
            
        }
    }
}



struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
            .environmentObject(FastingManager()) // Provide a mock FastingManager for preview
    }
}
