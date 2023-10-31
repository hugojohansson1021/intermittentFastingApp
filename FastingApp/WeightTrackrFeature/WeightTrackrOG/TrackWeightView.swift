//
//  TrackWeightView.swift
//  FastingApp
//
//  Created by Hugo Johansson on 2023-10-18.
//



import SwiftUI
import CoreData
import SwiftUICharts
import Charts

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
                Text("Track your weight")
                    .font(.largeTitle)
                    .padding()
                    .foregroundStyle(.white)
                
                
                
                // Chart
                
                if weightEntries.isEmpty {
                    Text("No data available.")
                        .foregroundColor(.white)
                } else {
                    Chart {
                        ForEach(weightEntries, id: \.self) { entry in
                            LineMark(
                                x: .value("Date", entry.date ?? Date()),
                                y: .value("Weight", entry.weight)
                            )
                            .foregroundStyle(.mintBack)
                            
                            PointMark(
                                x: .value("Date", entry.date ?? Date()),
                                y: .value("Weight", entry.weight)
                            )
                            .foregroundStyle(.white)
                        }
                        
                        RuleMark(
                               y: .value("Goal Weight", goalWeight)
                           )
                           .foregroundStyle(.yellow)
                           .lineStyle(StrokeStyle(lineWidth: 2, dash: [5, 5]))
                           .annotation(position: .trailing) {
                               Text("Goal")
                                   .foregroundStyle(.yellow)
                                   .font(.caption)
                                   .offset(x: 5)
                           }
                        
                        
                    }
                    .frame(height: 300)
                    .padding(.leading, 10)
                    .padding(.trailing, 10)

                    .chartXAxis {
                        AxisMarks(values: .stride(by: .day)) { _ in
                            AxisGridLine()
                                .foregroundStyle(.white)
                            AxisTick()
                                .foregroundStyle(.white)
                            AxisValueLabel(format: .dateTime.day().month())
                                .foregroundStyle(.white)
                        }
                    }
                    .chartYAxis {
                        AxisMarks { _ in
                            AxisGridLine()
                                .foregroundStyle(.white)
                            AxisTick()
                                .foregroundStyle(.white)
                            AxisValueLabel()
                                .foregroundStyle(.white)
                        }
                    }
                }
                
                
                
                Spacer()
                
                // Goal Weight Display and Picker
                Button(action: {
                    showingPicker.toggle()
                }
                       
                ) {
                    Text("Goal Weight: \(goalWeight) kg")
                        .foregroundColor(.yellow)
                        .padding()
                        .background(Capsule().fill(Color.purpleDark))
                        .shadow(radius: 5)
                }
                .popover(isPresented: $showingPicker) {
                    VStack {
                        Text("Choose a goal Weight").font(.headline).padding()
                        Picker("Goal Weight", selection: $goalWeight) {
                            ForEach(30...150, id: \.self) { weight in
                                Text("\(weight)")
                            }
                        }
                        .pickerStyle(WheelPickerStyle())
                        .frame(height: 150)
                        .clipped()
                    }
                    .padding()
                    .frame(width: 300, height: 350)
                }
                .onChange(of: goalWeight) { _ in
                    saveGoalWeight()
                }
                
                // Estimated Date Of Goal Weight
                if let estimatedDate = calculateEstimatedDateOfGoalWeight(goalWeight: Double(goalWeight)) {
                    Text("Estimated Time to Goal: \(estimatedDate, format: .dateTime.day().month().year())")
                        .padding()
                        .foregroundStyle(.white)
                }
                
                Spacer()
                VStack {
                    // Button to add new weight entry
                    Button("Track Weight") {
                        withAnimation {
                            showingAddWeightSheet.toggle()
                        }
                    }
                    .padding()
                    .background(Capsule().fill(Color.purpleDark))
                    .foregroundColor(.white)
                    .shadow(radius: 5)
                    
                    // Button to show weight history
                    Button("Track History") {
                        withAnimation {
                            showingWeightHistory.toggle()
                        }
                    }
                    .padding(8)
                    .background(Capsule().fill(Color.purpleDark))
                    .foregroundColor(.white)
                    .shadow(radius: 5)
                }
                .padding()
                .sheet(isPresented: $showingAddWeightSheet) {
                    WeightEntrySheet()
                        .environment(\.managedObjectContext, managedObjectContext)
                }
                .popover(isPresented: $showingWeightHistory) {
                    WeightHistoryView()
                        .environment(\.managedObjectContext, managedObjectContext)
                }

                .onAppear {
                    loadGoalWeight()
                }
            }
        }
        
        
    }//body
    
    
    
    // Calculate weight
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
    
    func loadGoalWeight() {
           let fetchRequest = NSFetchRequest<NSManagedObject>(entityName: "CDGoalWeight")
           do {
               let result = try managedObjectContext.fetch(fetchRequest)
               if let savedGoalWeight = result.first?.value(forKey: "goalWeight") as? Int {
                   goalWeight = savedGoalWeight
               }
           } catch {
               print("Error loading goal weight: \(error)")
           }
       }
    
    
    
    
    func saveGoalWeight() {
           let fetchRequest = NSFetchRequest<NSManagedObject>(entityName: "CDGoalWeight")
           do {
               let result = try managedObjectContext.fetch(fetchRequest)
               if let existingGoalWeight = result.first {
                   existingGoalWeight.setValue(goalWeight, forKey: "goalWeight")
               } else {
                   let entity = NSEntityDescription.entity(forEntityName: "CDGoalWeight", in: managedObjectContext)!
                   let newGoalWeight = NSManagedObject(entity: entity, insertInto: managedObjectContext)
                   newGoalWeight.setValue(goalWeight, forKey: "goalWeight")
               }
               
               try managedObjectContext.save()
           } catch {
               print("Error saving goal weight: \(error)")
           }
       }
    
    
    
    
   }

struct TrackWeightView_Previews: PreviewProvider {
    static var previews: some View {
        TrackWeightView()
            .environment(\.managedObjectContext, PersistenceController.shared.container.viewContext)
    }
}
