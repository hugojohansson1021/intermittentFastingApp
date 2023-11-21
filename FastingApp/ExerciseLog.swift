//
//  ExerciseLog.swift
//  FastingApp
//
//  Created by Hugo Johansson on 2023-11-20.
//

import SwiftUI
import CoreData

struct ExerciseLog: View {
    @Environment(\.managedObjectContext) private var viewContext
    @FetchRequest(
        sortDescriptors: [NSSortDescriptor(keyPath: \MarkedDate.date, ascending: true)],
        animation: .default)
    private var markedDates: FetchedResults<MarkedDate>

    @State private var currentDate = Date()
    private let calendar = Calendar.current

    private var daysInMonth: [Date] {
        guard let monthRange = calendar.range(of: .day, in: .month, for: currentDate) else { return [] }
        return monthRange.compactMap { day -> Date? in
            return calendar.date(bySetting: .day, value: day, of: currentDate)
        }
    }

    

    
    var body: some View {
        
        
        ZStack{
            
            LinearGradient(gradient: Gradient(colors: [Color.darkPurple, Color.purpleDark, Color.darkPink]), startPoint: .topLeading, endPoint: .bottomTrailing)
                .ignoresSafeArea()
            
            VStack(spacing:25) {
                
                Text("Exercise Logs")
                    .font(.title)
                    .foregroundStyle(.white)
                
                
                
                Text("This lets you track every workout")
                    .font(.title3)
                    .foregroundStyle(.white)
                
                
                
                
                
                // Månadsnavigering och titel
                HStack {
                    Button(action: previousMonth) {
                        Image(systemName: "chevron.left")
                            .foregroundStyle(.white)
                    }
                    Spacer()
                    Text(monthTitle)
                        .font(.title)
                        .foregroundStyle(.white)
                    Spacer()
                    Button(action: nextMonth) {
                        Image(systemName: "chevron.right")
                            .foregroundStyle(.white)
                    }
                }
                .padding()
                
                LazyVGrid(columns: Array(repeating: GridItem(.flexible()), count: 7)) {
                    ForEach(daysInMonth, id: \.self) { date in
                        Text(date.formatted(.dateTime.day()))
                            .foregroundStyle(.white)
                            .frame(width: 40, height: 40)
                            .foregroundColor(Color.black)
                            .background(isDateMarked(date) ? Color.blueBack : Color.clear)
                            .cornerRadius(20)
                            .onTapGesture {
                                toggleDateSelection(date)
                            }
                    }
                }
                .padding()
                .foregroundStyle(.white)
                
                Text("All your logs are saved automatically")
                    .font(.caption)
                    .foregroundStyle(.white)
                
                Spacer()
                
                
                Text("New features and updates will come in time ")
                    .font(.footnote)
                    .foregroundStyle(.white)
                
            }
            
            
            
        }
        
        
        
        
        
    }
    

    private var monthTitle: String {
        currentDate.formatted(.dateTime.month().year())
    }

    private func isDateMarked(_ date: Date) -> Bool {
        markedDates.contains(where: { $0.date == date })
    }

    private func toggleDateSelection(_ date: Date) {
        if let markedDate = markedDates.first(where: { $0.date == date }) {
            viewContext.delete(markedDate)
        } else {
            let newMarkedDate = MarkedDate(context: viewContext)
            newMarkedDate.date = date
        }
        saveContext()
    }

    private func nextMonth() {
        if let nextMonth = calendar.date(byAdding: .month, value: 1, to: currentDate) {
            currentDate = nextMonth
        }
    }

    private func previousMonth() {
        if let prevMonth = calendar.date(byAdding: .month, value: -1, to: currentDate) {
            currentDate = prevMonth
        }
    }

    private func saveContext() {
        do {
            try viewContext.save()
        } catch {
            // Hantera felet här
        }
    }
    
    
    
    
    
}//view Last

struct ExerciseLog_Previews: PreviewProvider {
    static var previews: some View {
        // Använd din anpassade PersistenceController för att få context
        let context = PersistenceController.shared.container.viewContext
        ExerciseLog().environment(\.managedObjectContext, context)
    }
}

