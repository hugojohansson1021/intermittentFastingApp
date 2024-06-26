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
    @State private var isDataLoading = false
    @EnvironmentObject var userSettings: UserSettings

    private var calendar: Calendar {
        var cal = Calendar.current
        cal.firstWeekday = 2
        return cal
    }

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
            
            ScrollView {
            
            VStack(spacing: 25) {
                Text("This lets you track every workout")
                    .font(.title3)
                    .foregroundColor(.white)
                    .padding(.top)

                HStack {
                    Button(action: previousMonth) {
                        Image(systemName: "chevron.left").foregroundColor(.white)
                    }
                    Spacer()
                    Text(monthTitle).font(.title).foregroundColor(.white)
                    Spacer()
                    Button(action: nextMonth) {
                        Image(systemName: "chevron.right").foregroundColor(.white)
                    }
                }
                .padding()

                LazyVGrid(columns: Array(repeating: GridItem(.flexible()), count: 7)) {
                    ForEach(0..<7, id: \.self) { index in
                        Text(calendar.veryShortWeekdaySymbols[(index + calendar.firstWeekday - 1) % 7])
                            .foregroundColor(.gray)
                    }

                    ForEach(daysInMonth.indices, id: \.self) { index in
                        let date = daysInMonth[index]
                        if let date = date {
                            Button(action: {
                                isDataLoading = true
                                loadDataForDate(date)
                            }) {
                                Text(date.formatted(.dateTime.day()))
                                    .foregroundColor(isToday(date) ? Color.red : Color.white)
                                    .frame(width: 40, height: 40)
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
                .foregroundColor(.white)

                Text("Press on a date to log your workout").font(.caption).foregroundColor(.white)
                Spacer()
                Text("New features and updates will come in time").font(.footnote).foregroundColor(.white)
            }
            .navigationTitle("Settings")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .principal) {
                    Text("Workout logs")
                        .foregroundColor(.white)
                        .font(.title2)
                        .fontWeight(.bold)
                }
            }
            }
            .sheet(isPresented: $showingSheet) {
                if let selectedDate = selectedDate, !isDataLoading {
                    DateDetailsSheet(isPresented: $showingSheet, markedDate: selectedMarkedDate, date: selectedDate)
                        .onAppear(perform: clearSheetBackground)
                        .presentationDetents([.medium])
                        .environment(\.managedObjectContext, self.viewContext)
                }
            }
            
            if isDataLoading {
                LoadingView()
                    .transition(.opacity)
            }
        }
        .environment(\.colorScheme, .light)
    }

    private func isToday(_ date: Date?) -> Bool {
        guard let date = date else { return false }
        return Calendar.current.isDateInToday(date)
    }

    private func loadDataForDate(_ date: Date) {
        let fetchRequest: NSFetchRequest<MarkedDate> = MarkedDate.fetchRequest()
        fetchRequest.predicate = NSPredicate(format: "date == %@", date as NSDate)

        DispatchQueue.global(qos: .userInitiated).async {
            do {
                let results = try self.viewContext.fetch(fetchRequest)
                DispatchQueue.main.async {
                    self.selectedMarkedDate = results.first
                    self.selectedDate = date
                    self.isDataLoading = false
                    self.showingSheet = true
                }
            } catch {
                print("Error loading data: \(error)")
                DispatchQueue.main.async {
                    self.isDataLoading = false
                }
            }
        }
    }

    private func clearSheetBackground() {
        guard let windowScene = UIApplication.shared.connectedScenes.first as? UIWindowScene else { return }
        guard let controller = windowScene.windows.first?.rootViewController?.presentedViewController else { return }
        controller.view.backgroundColor = .clear
    }

    private var monthTitle: String {
        currentDate.formatted(.dateTime.month().year())
    }

    private func backgroundForDate(_ date: Date) -> Color {
        guard let markedDate = markedDates.first(where: { $0.date == date }),
              let colorStr = markedDate.color else {
            return Color.clear
        }

        switch colorStr {
        case "Blue": return Color("blueBack")
        case "Red": return Color.red
        case "Yellow": return Color.yellow
        case "Green": return Color.green
        case "Pink": return Color("PinkLink")
        default: return Color.clear
        }
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
            print("Error saving context: \(error)")
        }
    }
}

struct LoadingView: View {
    var body: some View {
        ZStack {
            Color.black.opacity(0.4).edgesIgnoringSafeArea(.all)
            ProgressView("Loading...")
                .progressViewStyle(CircularProgressViewStyle(tint: .white))
                .foregroundColor(.white)
                .padding()
                .background(Color.gray.opacity(0.8))
                .cornerRadius(10)
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








