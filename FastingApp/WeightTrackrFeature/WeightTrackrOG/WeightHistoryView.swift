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
                            Text(String(format: "%.1f kg", weightEntry.weight ?? 0))
                        }

                    }
                    .onDelete(perform: deleteItems)
                }
                .toolbar {
                    EditButton()
                }

                Button("Done") {
                    dismiss()
                }
                .padding()
                .frame(maxWidth: .infinity)
                .background(Color.blue)
                .foregroundColor(.white)
                .cornerRadius(10)
                .padding()
            }
            .navigationTitle("Weight History")
        }
    }

    private func deleteItems(offsets: IndexSet) {
        withAnimation {
            offsets.map { weightEntries[$0] }.forEach(managedObjectContext.delete)

            do {
                try managedObjectContext.save()
            } catch {
                // Add your error handling here
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
