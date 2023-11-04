//
//  FastingHistoryView.swift
//  FastingApp
//
//  Created by Hugo Johansson on 2023-11-03.
//
import SwiftUI
import CoreData

struct FastingHistoryView: View {
    @Environment(\.managedObjectContext) private var viewContext

    @FetchRequest(
        sortDescriptors: [NSSortDescriptor(keyPath: \FastingSession.startDate, ascending: false)],
        animation: .default)
    
    private var fastingSessions: FetchedResults<FastingSession>

    var body: some View {
        NavigationView {
            List {
                ForEach(fastingSessions) { session in
                    VStack(alignment: .leading) {
                        if let startDate = session.startDate, let endDate = session.endDate {
                            Text("Start: \(startDate, formatter: itemFormatter)")
                            Text("End: \(endDate, formatter: itemFormatter)")
                            Text("Duration: \(session.duration) hours") // Anpassa detta efter hur du har lagrat varaktigheten
                            Text("Fasting Plan: \(session.fastingPlan ?? "Unknown")")
                            if let notes = session.notes, !notes.isEmpty {
                                Text("Notes: \(notes)")
                            }
                        } else {
                            Text("Invalid Session Data")
                        }
                    }
                }
                .onDelete(perform: deleteItems)
            }
            .navigationTitle("Fasting History")
            .toolbar {
                EditButton()
         
            }
            .onAppear {
                print("Antal fastingSessions: \(fastingSessions.count)")
            }

        }
    }

    private func deleteItems(offsets: IndexSet) {
        withAnimation {
            offsets.map { fastingSessions[$0] }.forEach(viewContext.delete)

            do {
                try viewContext.save()
            } catch {
                let nsError = error as NSError
                fatalError("Unresolved error \(nsError), \(nsError.userInfo)")
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

struct FastingHistoryView_Previews: PreviewProvider {
    static var previews: some View {
        FastingHistoryView().environment(\.managedObjectContext, previewContext)
    }
    
    static var previewContext: NSManagedObjectContext {
        let context = CoreDataManager.shared.persistentContainer.viewContext
        // Lägg till kod här för att skapa och spara några testdata om du behöver
        return context
    }
}
