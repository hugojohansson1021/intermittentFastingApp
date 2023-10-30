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
                    let data = weightEntries.compactMap { weightEntries -> Double? in
                        if let weight = weightEntries.weight as? Double {
                            return weight
                        }
                        return nil
                    }
                    LineView(data: data, title: "Vikt", legend: "kg")
                        .frame(height: 300)
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
            }
            .padding()
        }
        .sheet(isPresented: $showingAddWeightSheet) {
            WeightEntrySheet()
                .environment(\.managedObjectContext, managedObjectContext)
        }
    }
}

struct TrackWeightView_Previews: PreviewProvider {
    static var previews: some View {
        TrackWeightView()
            .environment(\.managedObjectContext, PersistenceController.shared.container.viewContext)
    }
}


