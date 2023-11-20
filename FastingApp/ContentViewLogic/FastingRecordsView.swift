//
//  FastingRecordsView.swift
//  FastingApp
//
//  Created by Hugo Johansson on 2023-11-20.
//


import SwiftUI
import CoreData

struct FastingRecordsView: View {
    @Environment(\.managedObjectContext) private var viewContext
    @FetchRequest(
        entity: FastingRecord.entity(),
        sortDescriptors: [NSSortDescriptor(keyPath: \FastingRecord.endDate, ascending: false)]
    ) var fastingRecords: FetchedResults<FastingRecord>

    var body: some View {
        
        
        
        NavigationView {
            
            VStack{
                
                
                
                List {
                    ForEach(fastingRecords, id: \.self) { record in
                        VStack(alignment: .leading) {
                            Text("Date: \(formattedDate(record.endDate ?? Date()))")
                            Text("Fasting Time: \(formatTimeInterval(record.totalFastingTime))")
                        }
                    }
                    .onDelete(perform: deleteRecords)
                }
                .listStyle(PlainListStyle())
                .padding()
                .background(Color.customPurpleDark)
                
               
            }
            .background(Color.customPurpleDark)
            .navigationTitle("Weight History")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .principal) {
                    Text("Weight History")
                        .foregroundColor(.white)
                        .font(.title2)
                        .fontWeight(.bold)
                }
            }
        }
        .navigationViewStyle(StackNavigationViewStyle())
        
    }

    
    
    
    
    
   
    
    
    
    private func deleteRecords(at offsets: IndexSet) {
        for index in offsets {
            let record = fastingRecords[index]
            viewContext.delete(record)
        }

        do {
            try viewContext.save()
        } catch {
            // Handle the error, e.g., show an error message to the user
            print("Error deleting record: \(error)")
        }
    }

    private func formattedDate(_ date: Date) -> String {
        let formatter = DateFormatter()
        formatter.dateStyle = .long
        formatter.timeStyle = .short
        return formatter.string(from: date)
    }

    private func formatTimeInterval(_ interval: TimeInterval) -> String {
        let hours = Int(interval) / 3600
        let minutes = Int(interval) % 3600 / 60
        return "\(hours) hours, \(minutes) minutes"
    }
}

// Preview Provider
struct FastingRecordsView_Previews: PreviewProvider {
    static var previews: some View {
        FastingRecordsView().environment(\.managedObjectContext, PersistenceController.shared.container.viewContext)
    }
}

