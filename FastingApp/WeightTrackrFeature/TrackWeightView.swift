//
//  TrackWeightView.swift
//  FastingApp
//
//  Created by Hugo Johansson on 2023-10-18.
//

import SwiftUI
import CoreData
import SwiftUICharts

struct TrackWeightView: View {
    @Environment(\.managedObjectContext) private var managedObjectContext
    @FetchRequest(
        entity: CDWeightEntry.entity(),
        sortDescriptors: [NSSortDescriptor(keyPath: \CDWeightEntry.date, ascending: true)]
    ) var weightEntries: FetchedResults<CDWeightEntry>
    
    @State private var showingAddWeightSheet = false
    @State private var showingWeightHistory = false
    @State private var goalWeight: Int = 60
    @State private var showingPicker = false

    var body: some View {
        ZStack {
            // Background
            LinearGradient(gradient: Gradient(colors: [Color.darkPurple, Color.purpleDark, Color.darkPink]), startPoint: .topLeading, endPoint: .bottomTrailing)
                .ignoresSafeArea()
            
            VStack {
                // Title
                Text("Spåra din vikt")
                    .font(.largeTitle)
                    .padding()

                // Chart
                if weightEntries.isEmpty {
                    Text("Ingen viktdata tillgänglig.")
                        .foregroundColor(.white)
                } else {
                    let data = weightEntries.compactMap { $0.weight as? Double }
                    LineView(data: data, title: "Vikt", legend: "kg")
                        .frame(height: 300)
                }
                
                Spacer()
                
                // Goal Weight Display and Picker
                Button(action: {
                    showingPicker.toggle()
                }) {
                    Text("Målvikt: \(goalWeight) kg")
                        .foregroundColor(.white)
                }
                .popover(isPresented: $showingPicker) {
                    VStack {
                        Text("Välj Målvikt").font(.headline).padding()
                        Picker("Målvikt", selection: $goalWeight) {
                            ForEach(30...150, id: \.self) { weight in
                                Text("\(weight)")
                            }
                        }
                        .pickerStyle(WheelPickerStyle())
                        .frame(height: 150)
                        .clipped()
                    }
                    .padding()
                    .frame(width: 200, height: 250)  // Justera dessa värden efter ditt behov
                }



                
                // Estimated Date Of Goal Weight
                if let estimatedDate = calculateEstimatedDateOfGoalWeight(goalWeight: Double(goalWeight)) {
                    Text("Beräknat datum för målvikt: \(estimatedDate, format: .dateTime.day().month().year())")
                        .padding()
                }


                Spacer()
                
                // Button to add new weight entry
                Button("Track Weight") {
                    showingAddWeightSheet.toggle()
                }
                .padding()
                .background(Capsule().fill(Color.purpleDark))
                .foregroundColor(.white)
                .shadow(radius: 5)
                
                // Button to show weight history
                Button("Weight History") {
                    showingWeightHistory.toggle()
                }
                .padding()
                .background(Capsule().fill(Color.gray))
                .foregroundColor(.white)
                .shadow(radius: 5)
            }
            .padding()
        }
        .sheet(isPresented: $showingAddWeightSheet) {
            WeightEntrySheet()
                .environment(\.managedObjectContext, managedObjectContext)
        }
        .sheet(isPresented: $showingWeightHistory) {
            WeightHistoryView()
                .environment(\.managedObjectContext, managedObjectContext)
        }
    }
    
    
    
    
  
    
    
    
    
    //Calculate weight
    func calculateEstimatedDateOfGoalWeight(goalWeight: Double) -> Date? {
        let weightData = weightEntries.compactMap { weightEntry -> (date: Date, weight: Double)? in
            if let date = weightEntry.date,
               let weight = weightEntry.weight as? Double {
                return (date, weight)
            }
            return nil
        }
        
        if let (slope, intercept) = linearRegression(data: weightData) {
            let estimatedDays = (goalWeight - intercept) / slope
            return Calendar.current.date(byAdding: .day, value: Int(estimatedDays), to: Date())
        }
        
        return nil
    }
}

struct TrackWeightView_Previews: PreviewProvider {
    static var previews: some View {
        TrackWeightView()
            .environment(\.managedObjectContext, PersistenceController.shared.container.viewContext)
    }
}


