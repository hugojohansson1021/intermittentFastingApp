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
                    
                    
                    

                    
                      
                    
                    // MARK: Chart
                    
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
                    HStack(spacing: 50){
                        VStack(spacing: 10){
                            // MARK: Text
                            
                            Text("Goal Weight:")
                                .foregroundStyle(.white)
                                .fontWeight(.bold)
                            
                            // MARK: Button Goal Weight Display and Picker
                            Button(action: {
                                withAnimation {
                                    showingPicker.toggle()
                                }
                            }) {
                                Text("\(goalWeight).0")
                                    .fontWeight(.bold)
                                    .padding(.horizontal, 24)
                                    .padding(.vertical, 8)
                                    .background(.thinMaterial)
                                    .cornerRadius(20)
                                    .foregroundColor(.yellow)
                            }
                            .sheet(isPresented: $showingPicker) {
                                    GoalPickerView(goalWeight: $goalWeight)
                                    .presentationDetents([.medium])
                                }
                            
                            

                            .background(Color.clear.opacity(0))
                            .onChange(of: goalWeight) { _ in
                                saveGoalWeight()
                            }
                            
                            
                        }//V-stack
                        
                        
                        
                        VStack(spacing: 10){
                            
                            // MARK: Text current weight
                            Text("Current Weight:")
                                .foregroundStyle(.white)
                                .fontWeight(.bold)
                            
                            Button(action: {
                                withAnimation {
                                    showingAddWeightSheet.toggle()
                                }
                            }) {
                                if let latestWeight = latestWeightEntry(), let weight = latestWeight.weight as? Double {
                                    Text(String(format: "%.1f ", weight))
                                } else {
                                    Text("No Data")
                                }
                            }
                            .fontWeight(.bold)
                            .padding(.horizontal, 24)
                            .padding(.vertical, 8)
                            .background(.thinMaterial)
                            .cornerRadius(20)
                            .foregroundColor(.white)
                        }//V-stack
    
                        }//H-Stack
                        
                    
                    
                    
                    // Estimated Date Of Goal Weight
                    if let estimatedDate = calculateEstimatedDateOfGoalWeight(goalWeight: Double(goalWeight)) {
                        Text("Estimated Date to Goal: \(estimatedDate, format: .dateTime.day().month().year())")
                            .padding()
                            .foregroundStyle(.white)
                            .fontWeight(.bold)
                        
                    }//H-stack
                    
                  
                    Spacer()
                    
                    VStack {
                        // Button to add new weight entry
                        Button("Track Weight") {
                            withAnimation {
                                showingAddWeightSheet.toggle()
                            }
                        }
                        .fontWeight(.bold)
                        .padding(.horizontal, 35)
                        .padding(.vertical, 13)
                        .background(.thinMaterial)
                        .cornerRadius(20)
                        .foregroundColor(.white)
                        .sheet(isPresented: $showingAddWeightSheet) {
                            // Fetch the latest weight and pass it to the WeightEntrySheet
                            if let latestWeight = latestWeightEntry(), let weight = latestWeight.weight as? Double {
                                WeightEntrySheet(initialWeight: weight)
                                    .environment(\.managedObjectContext, managedObjectContext)
                            } else {
                                // In case there is no previous weight entry, initialize with default value (e.g., 0.0)
                                WeightEntrySheet(initialWeight: 0.0)
                                    .environment(\.managedObjectContext, managedObjectContext)
                            }
                        }
                        
                        // Button to show weight history
                        Button("Track History") {
                            withAnimation {
                                showingWeightHistory.toggle()
                            }
                        }
                        .fontWeight(.bold)
                        .padding(.horizontal, 24)
                        .padding(.vertical, 8)
                        .background(.thinMaterial)
                        .cornerRadius(20)
                        .foregroundColor(.white)
                    }
                    .padding()
                    .sheet(isPresented: $showingAddWeightSheet) {
                        let lastWeight = fetchLastWeight(managedObjectContext: managedObjectContext)
                        WeightEntrySheet(initialWeight: lastWeight)
                            .environment(\.managedObjectContext, managedObjectContext)
                    }

                    .popover(isPresented: $showingWeightHistory) {
                        WeightHistoryView()
                            .environment(\.managedObjectContext, managedObjectContext)
                    }
                    
                    .onAppear {
                        loadGoalWeight()
                    }
                    
                    Text("New features and updates will come in time ")
                        .font(.footnote)
                        .foregroundStyle(.white)
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
    
    

    //Help func to find last weight entry
    func latestWeightEntry() -> CDWeightEntry? {
        return weightEntries.last
    }

    
    
    
    
    
    
    
    
   }//VIEW

struct TrackWeightView_Previews: PreviewProvider {
    static var previews: some View {
        TrackWeightView()
            .environment(\.managedObjectContext, PersistenceController.shared.container.viewContext)
    }
}
