//
//  WeightEntrySheet.swift
//  FastingApp
//
//  Created by Hugo Johansson on 2023-10-30.
//

import SwiftUI
import CoreData

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
    
    
    init(initialWeight: Double) {
            _hundreds = State(initialValue: Int(initialWeight / 100))
            _tens = State(initialValue: Int((initialWeight / 10).truncatingRemainder(dividingBy: 10)))
            _ones = State(initialValue: Int(initialWeight.truncatingRemainder(dividingBy: 10)))
            _tenths = State(initialValue: Int((initialWeight * 10).truncatingRemainder(dividingBy: 10)))
        }
    
    
    var body: some View {
        NavigationView {
            
            VStack {
                
                Text("Date")
                       .foregroundColor(.white)
                       .font(.title2)
                       .fontWeight(.bold)
                       

                DatePicker("", selection: $date, displayedComponents: .date)
                    .datePickerStyle(GraphicalDatePickerStyle())
                    .labelsHidden()
                    .accentColor(.white)
                    .background(Color.white.opacity(0.7))
                    .cornerRadius(10)
                    .padding()
                
                
                
                Text("Weight")
                       .foregroundColor(.white)
                       .font(.title2)
                       .fontWeight(.bold)
                
                
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
                .accentColor(.white)
                .background(Color.white.opacity(0.7))
                .cornerRadius(10)
                
                

                
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
                .fontWeight(.bold)
                .padding(.horizontal, 24)
                .padding(.vertical, 8)
                .background(.thinMaterial)
                .cornerRadius(20)
                .foregroundColor(.white)
                
                Spacer()
            }
            .padding()
            .background(.purpleDark)
            .navigationTitle("Add Weight")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .principal) {
                    Text("Add Weight")
                        .font(.headline)
                        .foregroundColor(.white)
                        .font(.title2)
                        .fontWeight(.bold)
                }
                ToolbarItem(placement: .cancellationAction) {
                    Button("Back") {
                        dismiss()
                    }
                    
                    .foregroundColor(.white)
                    .font(.title2)
                    .fontWeight(.bold)
                }
            }
        }
    }
}


extension Color {
    static let customDarkPurple = Color("darkPurple")
    static let customPurpleDark = Color("purpleDark")
    static let customDarkPink = Color("darkPink")
}


func fetchLastWeight(managedObjectContext: NSManagedObjectContext) -> Double {
    let request: NSFetchRequest<CDWeightEntry> = CDWeightEntry.fetchRequest()
    request.sortDescriptors = [NSSortDescriptor(keyPath: \CDWeightEntry.date, ascending: false)]
    request.fetchLimit = 1

    do {
        let result = try managedObjectContext.fetch(request)
        return result.first?.weight ?? 0.0
    } catch {
        print("Error fetching last weight: \(error)")
        return 0.0
    }
}



struct WeightEntrySheet_Previews: PreviewProvider {
    static var previews: some View {
        WeightEntrySheet(initialWeight: 0.0)
    }
}


