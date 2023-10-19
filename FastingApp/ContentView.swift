import SwiftUI

struct ContentView: View {
    @StateObject var fastingManager = FastingManager(initialFastingPlan: .intermediate)
    @State private var selectedFastingPlan: FastingPlan = .intermediate

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

                //MARK: Button
                Button {
                    fastingManager.toggleFastingState()
                } label: {
                    Text(fastingManager.fastingState == .fasting ? "End fast" : "Start fasting")
                        .fontWeight(.bold)
                        .padding(.horizontal, 24)
                        .padding(.vertical, 8)
                        .background(.thinMaterial)
                        .cornerRadius(20)
                }

                // New Restart Fasting button
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

            }
            .foregroundColor(.white)  // Moved inside VStack
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}

