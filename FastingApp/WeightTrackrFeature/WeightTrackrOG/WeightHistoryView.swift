//
//  WeightHistoryView.swift
//  FastingApp
//
//  Created by Hugo Johansson on 2023-10-30.
//

import CoreData
import SwiftUI

struct WeightHistoryView: View {
    @Environment(\.managedObjectContext) private var managedObjectContext
    @FetchRequest(
        entity: CDWeightEntry.entity(),
        sortDescriptors: [NSSortDescriptor(keyPath: \CDWeightEntry.date, ascending: false)]
    ) var weightEntries: FetchedResults<CDWeightEntry>
    @Environment(\.dismiss) private var dismiss

    var body: some View {
        NavigationView {
            VStack {
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
                .padding()
                .frame(maxWidth: .infinity)
                .background(Color.customDarkPink)
                .foregroundColor(.white)
                .cornerRadius(10)
                .padding()
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
