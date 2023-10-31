//
//  WeightEntrySheet.swift
//  FastingApp
//
//  Created by Hugo Johansson on 2023-10-30.
//

import SwiftUI

struct WeightEntrySheet: View {
    @Environment(\.managedObjectContext) private var managedObjectContext
    @Environment(\.dismiss) private var dismiss
    
    @State private var hundreds: Int = 0
    @State private var tens: Int = 0
    @State private var ones: Int = 0
    @State private var tenths: Int = 0
    @State private var date = Date()
    
    let numberRange = 0...9
    
    var weight: Double {
        return Double(hundreds * 100 + tens * 10 + ones) + Double(tenths) / 10.0
    }
    
    var formattedWeight: String {
        let formatter = NumberFormatter()
        formatter.minimumFractionDigits = 1
        formatter.maximumFractionDigits = 1
        formatter.minimumIntegerDigits = 1
        
        if let formattedString = formatter.string(from: NSNumber(value: weight)) {
            return "\(formattedString) kg"
        } else {
            return "N/A kg"
        }
    }
    
    var body: some View {
        
        
        NavigationView {
            
            
            
            Form {
                
                
                HStack {
                    
                    
                    Picker("Hundreds", selection: $hundreds) {
                        ForEach(numberRange, id: \.self) {
                            Text("\($0)")
                        }
                    }
                    .pickerStyle(WheelPickerStyle())
                    
                    Picker("Tens", selection: $tens) {
                        ForEach(numberRange, id: \.self) {
                            Text("\($0)")
                        }
                    }
                    .pickerStyle(WheelPickerStyle())
                    
                    Picker("Ones", selection: $ones) {
                        ForEach(numberRange, id: \.self) {
                            Text("\($0)")
                        }
                    }
                    .pickerStyle(WheelPickerStyle())
                    
                    Text(".")
                    
                    Picker("Tenths", selection: $tenths) {
                        ForEach(numberRange, id: \.self) {
                            Text("\($0)")
                        }
                    }
                    .pickerStyle(WheelPickerStyle())
                    
                    Text("kg")
                        .font(.largeTitle)
                }
                
                DatePicker("Date", selection: $date, displayedComponents: .date)
                
                Button("Save") {
                    let newWeightEntry = CDWeightEntry(context: managedObjectContext)
                    newWeightEntry.weight = weight
                    newWeightEntry.date = date
                                    
                    do {
                        try managedObjectContext.save()
                        dismiss()
                    } catch {
                        print("Error saving weight: \(error)")
                    }
                }
            }
            
            .navigationTitle("Add Weight")
            .toolbar {
                ToolbarItem(placement: .cancellationAction) {
                    Button("Cancel") {
                        dismiss()
                            
                    }
                }
            }
            
        }
        
        
    }
}



#Preview {
    WeightEntrySheet()
}
