//
//  WeightHistoryView.swift
//  FastingApp
//
//  Created by Hugo Johansson on 2023-10-30.
//

import CoreData
import SwiftUI

struct WeightHistoryView: View {
    @Environment(\.managedObjectContext) private var managedObjectContext//hold core data object
    @FetchRequest(
        entity: CDWeightEntry.entity(),
        sortDescriptors: [NSSortDescriptor(keyPath: \CDWeightEntry.date, ascending: false)]
    ) var weightEntries: FetchedResults<CDWeightEntry>//feach CDWeightEntry
    @Environment(\.dismiss) private var dismiss//Button to dissmiss

    var body: some View {
        NavigationView {
            VStack {
                
                Text("This list all your loggs, if you want to delate list items swipe right to left")
                    .fontWeight(.thin)
                    .padding()
                    .font(.subheadline)
                    .foregroundStyle(.white)
                
                List {
                    ForEach(weightEntries) { weightEntry in
                        HStack {
                            Text("\(weightEntry.date ?? Date(), formatter: itemFormatter)")
                            Spacer()
                            Text(String(format: "%.1f kg", weightEntry.weight))
                        }
                        foregroundColor(.white)
                        .padding()
                        .background(Color.white.opacity(0.8))
                        .cornerRadius(10)
                    }
                    .onDelete(perform: deleteItems)
                }
                .listStyle(PlainListStyle())
                .padding()
                .background(Color.customPurpleDark)
                
                Button("Done") {
                    dismiss()
                }
                .fontWeight(.bold)
                .padding(.horizontal, 24)
                .padding(.vertical, 8)
                .background(.thinMaterial)
                .cornerRadius(20)
                .foregroundColor(.white)
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

    
    
    
    
    private func deleteItems(offsets: IndexSet) {
        withAnimation {
            offsets.map { weightEntries[$0] }.forEach(managedObjectContext.delete)

            do {
                try managedObjectContext.save()
            } catch {
                print("Error deleting weight entries: \(error)")
            }
        }
    }
}

private let itemFormatter: DateFormatter = {
    let formatter = DateFormatter()
    formatter.dateStyle = .short
    formatter.timeStyle = .short
    return formatter
}()

struct WeightHistoryView_Previews: PreviewProvider {
    static var previews: some View {
        WeightHistoryView()
    }
}
