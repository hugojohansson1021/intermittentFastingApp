import SwiftUI

struct ProfilView: View {
    @State private var showingSettings = false
    @State private var showingInfoView = false
    @State private var showingFeedback = false
    
    @EnvironmentObject var userSettings: UserSettings // color status

    // Retrieve the app version and build number
    var appVersion: String {
        let version = Bundle.main.object(forInfoDictionaryKey: "CFBundleShortVersionString") as? String ?? "Unknown"
        let build = Bundle.main.object(forInfoDictionaryKey: "CFBundleVersion") as? String ?? "Unknown"
        return "Version \(version) (\(build))"
    }

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

                // Display App Version
                Text(appVersion)
                    .foregroundColor(.white)
                    .font(.headline)
                    .fontWeight(.bold)

                Spacer()
                
                // Button for changing color settings
                Button(action: {
                    showingSettings = true
                }) {
                    HStack {
                        Image(systemName: "transmission")
                            .imageScale(.large)
                            .foregroundColor(.white)
                        Text("Change color")
                            .foregroundColor(.white)
                            .font(.title)
                    }
                    .frame(width: 300, height: 40)
                    .background(.thinMaterial)
                    .cornerRadius(20)
                    .padding()
                }
                .sheet(isPresented: $showingSettings) {
                    Settings()
                }

                // Button for app information
                Button(action: {
                    showingInfoView = true
                }) {
                    HStack {
                        Image(systemName: "info.bubble")
                            .imageScale(.large)
                            .foregroundColor(.white)
                        Text("App info")
                            .foregroundColor(.white)
                            .font(.title)
                    }
                    .frame(width: 300, height: 40)
                    .background(.thinMaterial)
                    .cornerRadius(20)
                    .padding()
                }
                .sheet(isPresented: $showingInfoView) {
                    InfoViews()
                }

                // Button for feedback
                Button(action: {
                    showingFeedback = true
                }) {
                    HStack {
                        Image(systemName: "message")
                            .imageScale(.large)
                            .foregroundColor(.white)
                        Text("FeedBack")
                            .foregroundColor(.white)
                            .font(.title)
                    }
                    .frame(width: 300, height: 40)
                    .background(.thinMaterial)
                    .cornerRadius(20)
                    .padding()
                }
                .sheet(isPresented: $showingFeedback) {
                    FeedBackView()
                }

                Spacer()

                Text("New features and updates will come in time")
                    .font(.footnote)
                    .foregroundStyle(.white)
            } // VStack
        } // ZStack
        .environment(\.colorScheme, .light) // Set color scheme to light mode
    } // Body
}

// Preview
struct ProfilView_Previews: PreviewProvider {
    static var previews: some View {
        ProfilView()
        .environmentObject(UserSettings())
    }
}
