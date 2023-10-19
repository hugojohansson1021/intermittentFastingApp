//
//  FastingDataListView.swift
//  FastingApp
//
//  Created by Hugo Johansson on 2023-10-19.
//


import SwiftUI

struct FastingData: Identifiable {
    var id = UUID()
    var date: Date
    var totalFastingTime: TimeInterval

    // Add other properties as needed
}

struct FastingDataListView: View {
    @State var fastingDataArray: [FastingData]

    var body: some View {
        NavigationView {
            List {
                ForEach(fastingDataArray.indices, id: \.self) { index in
                    let data = fastingDataArray[index]
                    VStack(alignment: .leading) {
                        Text("Date: \(data.date, formatter: dateFormatter)")
                        Text("Total Fasting Time: \(formattedTimeInterval(data.totalFastingTime))")
                        // Add other data properties as needed
                    }
                }
                .onDelete(perform: deleteFastingData)
            }
            .listStyle(PlainListStyle())
            .navigationBarTitle("Fasting Data", displayMode: .inline)
            .toolbar {
                EditButton()
            }
        }
    }

    var dateFormatter: DateFormatter {
        let formatter = DateFormatter()
        formatter.dateStyle = .long
        formatter.timeStyle = .short
        return formatter
    }

    func formattedTimeInterval(_ timeInterval: TimeInterval) -> String {
        let hours = Int(timeInterval) / 3600
        let minutes = Int(timeInterval) % 3600 / 60
        return String(format: "%02d:%02d", hours, minutes)
    }

    func deleteFastingData(at offsets: IndexSet) {
        fastingDataArray.remove(atOffsets: offsets)
    }
}

struct FastingDataListView_Previews: PreviewProvider {
    static var previews: some View {
        let sampleData: [FastingData] = [
            FastingData(date: Date(), totalFastingTime: 3600),
            // Add more sample data as needed
        ]
        return FastingDataListView(fastingDataArray: sampleData)
    }
}
