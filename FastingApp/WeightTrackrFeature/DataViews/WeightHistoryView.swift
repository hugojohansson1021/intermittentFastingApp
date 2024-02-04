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

    @State private var weightEntryToDelete: CDWeightEntry?
    @State private var showDeleteAlert = false

    var body: some View {
        NavigationView {
            ZStack {
                CustomBackground()

                VStack {
                    Text("This list all your logs, if you want to delete list items tap on them")
                        .fontWeight(.thin)
                        .padding()
                        .font(.subheadline)
                        .foregroundColor(.white)

                    ScrollView {
                        LazyVStack {
                            ForEach(weightEntries, id: \.self) { weightEntry in
                                HStack {
                                    Text("\(weightEntry.date ?? Date(), formatter: itemFormatter)")
                                    Spacer()
                                    Text(String(format: "%.1f kg/lbs", weightEntry.weight))
                                }
                                .foregroundColor(.white)
                                .padding()
                                .background(Color.white.opacity(0.1))
                                .cornerRadius(10)
                                .onTapGesture {
                                    self.weightEntryToDelete = weightEntry
                                    self.showDeleteAlert = true
                                }
                            }
                        }
                    }
                    .padding(.horizontal)

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
            .environment(\.colorScheme, .light) // Hårdk
            .alert(isPresented: $showDeleteAlert) {
                Alert(
                    title: Text("Delete Weight Entry"),
                    message: Text("Are you sure you want to delete this weight entry?"),
                    primaryButton: .destructive(Text("Delete")) {
                        if let weightEntryToDelete = weightEntryToDelete {
                            deleteWeightEntry(weightEntryToDelete)
                        }
                    },
                    secondaryButton: .cancel()
                )
            }
            .navigationViewStyle(StackNavigationViewStyle())
        }
    }

    private func deleteWeightEntry(_ weightEntry: CDWeightEntry) {
        managedObjectContext.delete(weightEntry)
        saveContext()
    }

    private func saveContext() {
        do {
            try managedObjectContext.save()
        } catch {
            print("Error saving context after delete: \(error)")
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
            .environmentObject(UserSettings())
    }
}
