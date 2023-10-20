import SwiftUI

struct AddFastingDataView: View {
    @Environment(\.presentationMode) var presentationMode
    @State private var selectedDate = Date()
    @State private var selectedHours = 0
    @State private var selectedMinutes = 0

    @EnvironmentObject var fastingManager: FastingManager

    var body: some View {
        NavigationView {
            Form {
                Section(header: Text("Enter Fast Completion Data")) {
                    DatePicker("Date", selection: $selectedDate, in: ...Date(), displayedComponents: .date)
                    
                    HStack {
                        Text("Fasting Duration:")
                            .foregroundColor(.primary)
                        
                        Picker("Hours", selection: $selectedHours) {
                            ForEach(0..<24, id: \.self) { hour in
                                Text("\(hour) hours")
                            }
                        }
                        .pickerStyle(WheelPickerStyle())
                        
                        Picker("Minutes", selection: $selectedMinutes) {
                            ForEach(0..<60, id: \.self) { minute in
                                Text("\(minute) minutes")
                            }
                        }
                        .pickerStyle(WheelPickerStyle())
                    }
                }

                Button("Save") {
                    let fastingDurationInSeconds = selectedHours * 3600 + selectedMinutes * 60
                    if fastingDurationInSeconds >= 0 {
                        // Add the completed fast data to the manager's list
                        fastingManager.addCompletedFast(date: selectedDate, fastingDuration: TimeInterval(fastingDurationInSeconds))
                        // Dismiss the sheet
                        presentationMode.wrappedValue.dismiss()
                    } else {
                        // Handle negative duration here
                        showErrorAlert(message: "Fasting duration cannot be negative.")
                        fastingManager.completedFasts.append(FastingData(date: selectedDate, totalFastingTime: TimeInterval(fastingDurationInSeconds)))
                    }
                }
            }
            .navigationBarTitle("Add Fasting Data", displayMode: .inline)
        }
    }
    
    private func showErrorAlert(message: String) {
        let alert = UIAlertController(title: "Error", message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
        UIApplication.shared.windows.first?.rootViewController?.present(alert, animated: true, completion: nil)
    }
}

struct AddFastingDataView_Previews: PreviewProvider {
    static var previews: some View {
        AddFastingDataView()
            .environmentObject(FastingManager()) // Provide a mock FastingManager for preview
    }
}

