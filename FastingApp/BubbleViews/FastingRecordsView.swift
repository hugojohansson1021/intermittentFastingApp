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

    @EnvironmentObject var userSettings: UserSettings // color status
    
    @State private var recordToDelete: FastingRecord?
    @State private var showDeleteAlert = false

    var body: some View {
        ZStack {
            CustomBackground()

            VStack {
                Text("This lists all your fasting logs. To delete a list item, tap on it.")
                    .fontWeight(.thin)
                    .padding()
                    .font(.subheadline)
                    .foregroundStyle(.white)

                ScrollView {
                    LazyVStack {
                        ForEach(fastingRecords, id: \.self) { record in
                            HStack {
                                VStack(alignment: .leading) {
                                    Text("Date: \(formattedDate(record.endDate ?? Date()))")
                                    Text("Fasting Time: \(formatTimeInterval(record.totalFastingTime))")
                                }
                                Spacer()
                            }
                            .padding()
                            .foregroundStyle(.white)
                            .background(Color.white.opacity(0.1))
                            .cornerRadius(10)
                            .onTapGesture {
                                self.recordToDelete = record
                                self.showDeleteAlert = true
                            }
                        }
                    }
                }
                .padding(.horizontal)
                .padding(.top, 16) // Adjust the top padding
            }
            .navigationTitle("Fasting Logs")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .principal) {
                    Text("Fasting Logs")
                        .foregroundColor(.white)
                        .font(.title2)
                        .fontWeight(.bold)
                }
            }
            .alert(isPresented: $showDeleteAlert) {
                Alert(
                    title: Text("Delete Record"),
                    message: Text("Are you sure you want to delete this record?"),
                    primaryButton: .destructive(Text("Delete")) {
                        if let recordToDelete = recordToDelete {
                            deleteRecord(recordToDelete)
                        }
                    },
                    secondaryButton: .cancel()
                )
            }
        }
        .navigationViewStyle(StackNavigationViewStyle())
        .environment(\.colorScheme, .light) // Hårdkodad färgschema
    }

    private func deleteRecord(_ record: FastingRecord) {
        viewContext.delete(record)
        saveContext()
    }

    private func saveContext() {
        do {
            try viewContext.save()
        } catch {
            print("Error saving context after delete: \(error)")
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

struct FastingRecordsView_Previews: PreviewProvider {
    static var previews: some View {
        FastingRecordsView().environment(\.managedObjectContext, PersistenceController.shared.container.viewContext)
            .environmentObject(UserSettings())
    }
}


