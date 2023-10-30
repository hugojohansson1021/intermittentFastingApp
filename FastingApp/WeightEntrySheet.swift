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
    
    @State private var weight = ""
    @State private var date = Date()
    
    var body: some View {
        NavigationView {
            Form {
                TextField("Weight", text: $weight)
                    .keyboardType(.decimalPad)
                DatePicker("Date", selection: $date, displayedComponents: .date)
                
                Button("Save") {
                    if let weight = Decimal(string: weight) {
                        let newWeightEntry = CDWeightEntry(context: managedObjectContext)
                        newWeightEntry.weight = NSDecimalNumber(decimal: weight)
                        newWeightEntry.date = date
                                        
                        do {
                            try managedObjectContext.save()
                            dismiss()
                        } catch {
                            print("Error saving weight: \(error)")
                        }
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
