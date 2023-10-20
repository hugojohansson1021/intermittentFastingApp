import SwiftUI

struct ContentView: View {
    @StateObject var fastingManager = FastingManager(initialFastingPlan: .intermediate)
    @State private var selectedFastingPlan: FastingPlan = .intermediate
    @State private var isAddFastingDataViewVisible = false

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

    var body: some View {
        NavigationView {
            ZStack {
                //MARK: Background
                LinearGradient(gradient: Gradient(colors: [Color.darkPurple, Color.purpleDark, Color.darkPink]), startPoint: .topLeading, endPoint: .bottomTrailing)
                    .ignoresSafeArea()
                content
                
            }
        }
    }

    var content: some View {
        ScrollView {
            VStack(spacing: 40) {

                //MARK: Title
                Text(title)
                    .font(.headline)

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
                .disabled(!fastingManager.isPickerEnabled)  // Disable the picker based on fasting state

                //MARK: Progressring
                ProgressRing()
                    .environmentObject(fastingManager)

                HStack(spacing: 60) {
                    //MARK: Start Time
                    VStack(spacing: 5) {
                        Text(fastingManager.fastingState == .notStarted ? "Start" : "Started")
                            .opacity(0.7)

                        Text(fastingManager.startTime, format: .dateTime.weekday().hour().minute().second())
                            .fontWeight(.bold)
                    }

                    //MARK: End Time
                    VStack(spacing: 5) {
                        Text(fastingManager.fastingState == .notStarted ? "End" : "Ends")
                            .opacity(0.7)

                        Text(fastingManager.endTime, format: .dateTime.weekday().hour().minute().second())
                            .fontWeight(.bold)
                    }
                }

                //MARK: start/end Button
                // ... (previous code)

                //MARK: Button
                Button {
                    if fastingManager.fastingState == .fasting {
                        // If fasting is currently in progress, only show the sheet to add fasting data
                        isAddFastingDataViewVisible.toggle()
                    } else {
                        // If fasting is not in progress, simply start fasting
                        fastingManager.toggleFastingState()
                    }
                } label: {
                    Text(fastingManager.fastingState == .fasting ? "End fast" : "Start fasting")
                        .fontWeight(.bold)
                        .padding(.horizontal, 24)
                        .padding(.vertical, 8)
                        .background(.thinMaterial)
                        .cornerRadius(20)
                }
                .sheet(isPresented: $isAddFastingDataViewVisible, onDismiss: {
                    // When the sheet is dismissed, then check if the fasting state was .fasting and toggle it
                    if fastingManager.fastingState == .fasting {
                        fastingManager.toggleFastingState()
                    }
                }) {
                    // Provide the environment object here
                    AddFastingDataView()
                        .environmentObject(fastingManager)
                }

                // ... (rest of your code)

                
                
                

                //MARK: New Restart Fasting button
                Button {
                    fastingManager.resetFasting()
                } label: {
                    Text("Restart fasting")
                        .fontWeight(.bold)
                        .padding(.horizontal, 24)
                        .padding(.vertical, 8)
                        .background(.thinMaterial)
                        .cornerRadius(20)
                }

                Spacer()

                //MARK: Bubbles

                NavigationLink(destination: TrackWeightView()) {
                    Rectangle()
                        .frame(width: 350, height: 150)
                        .cornerRadius(20.0)
                }
                .buttonStyle(PlainButtonStyle())

                NavigationLink(destination: TrackWeightView()) {
                    Rectangle()
                        .frame(width: 350, height: 150)
                        .cornerRadius(20.0)
                }
                .buttonStyle(PlainButtonStyle())

                //MARK: Button to Show Data List
                NavigationLink(destination: FastingDataListView(fastingDataArray: fastingManager.completedFasts)) {
                    Text("View All Data")
                        .fontWeight(.bold)
                        .padding(.horizontal, 24)
                        .padding(.vertical, 8)
                        .background(.thinMaterial)
                        .cornerRadius(20)
                        .foregroundColor(.black) // Customize the button's text color
                }
                .buttonStyle(PlainButtonStyle())
                .padding(.top, 20) // Adjust the spacing as needed
            }
            .sheet(isPresented: $isAddFastingDataViewVisible) {
                AddFastingDataView()
                    .environmentObject(fastingManager) // Provide the environment object here
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

