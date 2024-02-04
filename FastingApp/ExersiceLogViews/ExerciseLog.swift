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
    @State private var showingSheet = false
    @State private var selectedMarkedDate: MarkedDate? = nil
    @State private var selectedDate: Date? = nil
    
    @State private var isDataLoaded = false
    @State private var preparedMarkedDate: MarkedDate? = nil
    
    @EnvironmentObject var userSettings: UserSettings//color status
    
    // Anpassad kalender som börjar veckan med måndag
    private var calendar: Calendar {
        var cal = Calendar.current
        cal.firstWeekday = 2 // Sätt första veckodagen till måndag (2)
        return cal
    }

    // Beräknar dagarna i månaden med hänsyn till veckans startdag
    private var daysInMonth: [Date?] {
        guard let monthStart = calendar.date(from: calendar.dateComponents([.year, .month], from: currentDate)),
              let monthRange = calendar.range(of: .day, in: .month, for: monthStart) else { return [] }

        let firstWeekday = calendar.component(.weekday, from: monthStart)
        let daysOffset = (firstWeekday - calendar.firstWeekday + 7) % 7

        let previousMonthFillerDays = daysOffset > 0 ? Array(repeating: nil as Date?, count: daysOffset) : []
        let monthDays = (1...monthRange.count).compactMap { day -> Date? in
            calendar.date(bySetting: .day, value: day, of: monthStart)
        }

        return previousMonthFillerDays + monthDays
    }

    var body: some View {
        ZStack {
            CustomBackground()
            
            VStack(spacing: 25) {
                Text("Workout Logs").font(.title).foregroundStyle(.white)
                Text("This lets you track every workout").font(.title3).foregroundStyle(.white)

                HStack {
                    Button(action: previousMonth) {
                        Image(systemName: "chevron.left").foregroundStyle(.white)
                    }
                    Spacer()
                    Text(monthTitle).font(.title).foregroundStyle(.white)
                    Spacer()
                    Button(action: nextMonth) {
                        Image(systemName: "chevron.right").foregroundStyle(.white)
                    }
                }
                .padding()

                LazyVGrid(columns: Array(repeating: GridItem(.flexible()), count: 7)) {
                    ForEach(0..<7, id: \.self) { index in
                        Text(calendar.veryShortWeekdaySymbols[(index + calendar.firstWeekday - 1) % 7])
                            .foregroundStyle(.gray)
                    }

                    ForEach(daysInMonth, id: \.self) { date in
                        if let date = date {
                            Button(action: {
                                selectedMarkedDate = markedDates.first(where: { $0.date == date })
                                selectedDate = date
                                showingSheet = true
                                loadDataForDate(date) {
                                                        self.isDataLoaded = true
                                                        self.showingSheet = true
                                                    }

                            }) {
                                Text(date.formatted(.dateTime.day()))
                                    .foregroundColor(isToday(date) ? Color.red : Color.white)
                                    .frame(width: 40, height: 40)
                                    .foregroundColor(Color.black)
                                    .background(backgroundForDate(date))
                                    .cornerRadius(20)
                            }
                        } else {
                            Text("")
                                .frame(width: 40, height: 40)
                        }
                    }
                }
                .padding()
                .foregroundStyle(.white)
                
                Text("Press on a date to logg your workout").font(.caption).foregroundStyle(.white)
                Spacer()
                Text("New features and updates will come in time").font(.footnote).foregroundStyle(.white)
            }
            .sheet(isPresented: $showingSheet) {
                        if isDataLoaded, let selectedDate = selectedDate {
                            DateDetailsSheet(isPresented: $showingSheet, markedDate: selectedMarkedDate, date: selectedDate)
                                .onAppear(perform: clearSheetBackground)
                                .presentationDetents([.medium])
                                .environment(\.managedObjectContext, self.viewContext)
                        }
                    }
        }.environment(\.colorScheme, .light) // HårdK light mode
    }

    
    
    //MARK: Funktion för röd today
    private func isToday(_ date: Date?) -> Bool {
            guard let date = date else { return false }
            return Calendar.current.isDateInToday(date)
        }
    
    

    //MARK: LoadDataForDate load data when user nav to this view
    private func loadDataForDate(_ date: Date, completion: @escaping () -> Void) {
        
        let fetchRequest: NSFetchRequest<MarkedDate> = MarkedDate.fetchRequest()
        fetchRequest.predicate = NSPredicate(format: "date == %@", date as NSDate)

        // Asynkron fetch för att undvika att blockera UI-tråden
        DispatchQueue.global(qos: .userInitiated).async {
            do {
                let results = try self.viewContext.fetch(fetchRequest)
   
                DispatchQueue.main.async {
                    // Uppdatera tillstånd och UI här
                    completion()
                }
            } catch {
                print("Error loading data: \(error)")
                DispatchQueue.main.async {
                    completion()
                }
            }
        }
    }







    //MARK: Bug fix for Whitesheet
    private func clearSheetBackground() {
            guard let windowScene = UIApplication.shared.connectedScenes.first as? UIWindowScene else { return }
            guard let controller = windowScene.windows.first?.rootViewController?.presentedViewController else { return }
            controller.view.backgroundColor = .clear
        }





    //MARK: Gets the months
    private var monthTitle: String {
        currentDate.formatted(.dateTime.month().year())
    }

    //MARK: Sets the colors for date in sheet
    private func backgroundForDate(_ date: Date) -> Color {
        guard let markedDate = markedDates.first(where: { $0.date == date }),
              let colorStr = markedDate.color else {
            return Color.clear
        }

        switch colorStr {
        case "Blue": return Color("blueBack") // Antag att "blueBack" är namnet på din färg i Assets.xcassets
        case "Red": return Color.red // Om du använder en standardfärg
        case "Yellow": return Color.yellow // Om du använder en standardfärg
        case "Green": return Color.green // Om du använder en standardfärg
        case "Pink": return Color("PinkLink") // Antag att "pinkilink" är namnet på din färg i Assets.xcassets
        default: return Color.clear
        }
    }


    //MARK: Funktion to change to next Month
    private func nextMonth() {
        if let nextMonth = calendar.date(byAdding: .month, value: 1, to: currentDate) {
            currentDate = nextMonth
        }
    }

    //MARK: Funktion to change to previus Month
    private func previousMonth() {
        if let prevMonth = calendar.date(byAdding: .month, value: -1, to: currentDate) {
            currentDate = prevMonth
        }
    }

    //MARK: func that saves auto change
    private func saveContext() {
        do {
            try viewContext.save()
        } catch {
            print("Error saving context: \(error)")
        }
    }
}

struct ExerciseLog_Previews: PreviewProvider {
    static var previews: some View {
        let context = PersistenceController.shared.container.viewContext
        ExerciseLog().environment(\.managedObjectContext, context)
        .environmentObject(UserSettings())
    }
}
