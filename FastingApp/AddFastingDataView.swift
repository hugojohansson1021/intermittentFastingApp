import SwiftUI

struct AddFastingDataView: View {
    @Environment(\.presentationMode) var presentationMode
    @State private var selectedDate = Date()
    @State private var fastingDurationString = "" // Changed variable name
    @State private var showErrorAlert = false // Added state variable
    @State private var errorMessage = "" // Added state variable

    @EnvironmentObject var fastingManager: FastingManager

    var body: some View {
        NavigationView {
            Form {
                Section(header: Text("Enter Fast Completion Data")) {
                    DatePicker("Date", selection: $selectedDate, in: ...Date(), displayedComponents: .date)
                    TextField("Fasting Duration (in hours)", text: $fastingDurationString) // Updated binding to text
                }

                Button("Save") {
                    if let fastingDuration = Double(fastingDurationString) {
                        if fastingDuration >= 0 {
                            // Add the completed fast data to the manager's list
                            fastingManager.addCompletedFast(date: selectedDate, fastingDuration: fastingDuration)
                            // Dismiss the sheet
                            presentationMode.wrappedValue.dismiss()
                        } else {
                            // Handle negative duration here
                            errorMessage = "Fasting duration cannot be negative."
                            showErrorAlert.toggle()
                        }
                    } else {
                        // Handle invalid input here (non-numeric input)
                        errorMessage = "Invalid fasting duration. Please enter a valid number."
                        showErrorAlert.toggle()
                    }
                }

            }
            .navigationBarTitle("Add Fasting Data", displayMode: .inline)
            .alert(isPresented: $showErrorAlert) {
                Alert(title: Text("Error"), message: Text(errorMessage), dismissButton: .default(Text("OK")))
            }
        }
    }
}

struct AddFastingDataView_Previews: PreviewProvider {
    static var previews: some View {
        AddFastingDataView()
            .environmentObject(FastingManager()) // Provide a mock FastingManager for preview
    }
}

