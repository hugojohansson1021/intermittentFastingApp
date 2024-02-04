//
//  FastingManager.swift
//  FastingApp
//
//  Created by Hugo Johansson on 2023-10-17.
//





import Foundation
import UserNotifications
import CoreData



enum FastingState: String {
    case notStarted
    case fasting
    case feeding
}

enum FastingPlan: String {
    case beginner = "12:12"
    case intermediate = "16:8"
    case advanced = "20:4"

    var fastingPeriod: Double {
        switch self {
        case .beginner:
            return 0.01
        case .intermediate:
            return 16
        case .advanced:
            return 20
        }
    }
}





class FastingManager: ObservableObject {
    @Published private(set) var fastingState: FastingState = .notStarted 
    @Published var fastingPlan: FastingPlan = .intermediate {
        didSet {
            if fastingState == .fasting {
                elapsed = false
            } else {
                elapsed = true
            }
        }
        }
    
    @Published private(set) var startTime: Date {
        didSet {
            if fastingState == .fasting {
                endTime = startTime.addingTimeInterval(fastingTime)
            } else {
                endTime = startTime.addingTimeInterval(feedingTime)
            }
        }
    }
    
    @Published private(set) var endTime: Date {
        didSet {
            if fastingState == .fasting {
                elapsed = false
            } else {
                elapsed = true
            }
        }
    }
    
    @Published private(set) var fastingPeriodCompleted: Bool = false

    
    @Published private(set) var elapsed: Bool = false
    @Published private(set) var elapsedTime: Double = 0.0
    @Published private(set) var progress: Double = 0.0
    
    var fastingTime: Double {
        return fastingPlan.fastingPeriod * 60 * 60
    }
    
    var feedingTime: Double {
        return (24 - fastingPlan.fastingPeriod) * 60 * 60
    }
    
    
    
    //Picker logik
    var isPickerEnabled: Bool {
        return fastingState == .notStarted || fastingState == .feeding
    }
    var hasRestartedFasting = false

    
    
    init(initialFastingPlan: FastingPlan = .intermediate) {
        self.fastingPlan = initialFastingPlan

        // Skapa en temporär variabel för nuvarande tid
        let now = Date.now

        // Använd den temporära variabeln för att sätta startTime och endTime
        self.startTime = now
        self.endTime = now.addingTimeInterval(initialFastingPlan.fastingPeriod * 60 * 60)

    }

    
    func toggleFastingState() {
        fastingState = fastingState == .fasting ? .feeding : .fasting
        startTime = Date()
        
        if fastingState == .fasting {
                // Schemalägg alla relevanta notifikationer
                scheduleStartNotification()
                scheduleHalfwayNotification()
                scheduleEndOfFastingNotification()
            }
        
    
    }


    
  //MARK: Track Time
    
    func track() {
        let currentTime = Date()
        elapsedTime = currentTime.timeIntervalSince(startTime)
        let totalTime = fastingState == .fasting ? fastingTime : feedingTime
        elapsed = currentTime >= endTime

        // Kontrollera om fasteperioden är avslutad men fastan inte manuellt avslutad
        if fastingState == .fasting && currentTime >= endTime {
            fastingPeriodCompleted = true
        } else {
            fastingPeriodCompleted = false
        }

        progress = round(min((elapsedTime / totalTime), 1.0) * 100) / 100
    }

    
    
    
    func resetFasting() {
            fastingState = .notStarted
            let calendar = Calendar.current
            let components = DateComponents(hour: 20)
            let scheduledTime = calendar.nextDate(after: .now, matching: components, matchingPolicy: .nextTime)!
            startTime = scheduledTime
            endTime = scheduledTime.addingTimeInterval(fastingPlan.fastingPeriod * 60 * 60)
            elapsedTime = 0.0
            progress = 0.0
        }
    
    
    
    
    func tuggleFastingState() {
        fastingState = fastingState == .fasting ? .feeding : .fasting
            if fastingState == .feeding {
                fastingPeriodCompleted = false
                elapsed = true
                
            }
            startTime = Date()
        
        if fastingState == .fasting {
                // Schemalägg alla relevanta notifikationer
                scheduleStartNotification()
                scheduleHalfwayNotification()
                scheduleEndOfFastingNotification()
            }

        
        
        }
    
    
    func elapsedTimeComponents() -> (hours: Int, minutes: Int, seconds: Int) {
        let totalSeconds = Int(elapsedTime)
        let hours = totalSeconds / 3600
        let minutes = (totalSeconds % 3600) / 60
        let seconds = totalSeconds % 60
        return (hours, minutes, seconds)
    }

    
    
    //MARK: Timer lifecykle
    
    func startTimer() {
        let startDate = Date()  // Nuvarande tidpunkt

        // Beräkna fastingPeriod baserat på den valda fasta planen
        let fastingPeriod = calculateFastingPeriod(for: fastingPlan)

        let endDate = startDate.addingTimeInterval(fastingPeriod)

        // Spara start- och sluttid
        UserDefaults.standard.set(startDate, forKey: "startDate")
        UserDefaults.standard.set(endDate, forKey: "endDate")

        // Här kan du starta din timer logik
    }

    private func calculateFastingPeriod(for plan: FastingPlan) -> TimeInterval {
        switch plan {
        case .beginner:
            return 12 * 60 * 60  // 12 timmar i sekunder
        case .intermediate:
            return 16 * 60 * 60  // 16 timmar i sekunder
        case .advanced:
            return 20 * 60 * 60  // 20 timmar i sekunder
        }
    }


    func checkTimer() {
        guard let savedStartDate = UserDefaults.standard.object(forKey: "startDate") as? Date,
              let savedEndDate = UserDefaults.standard.object(forKey: "endDate") as? Date else {
            // Ingen timer var sparad, eventuellt hantera detta tillstånd
            return
        }

        let currentDate = Date()
        if currentDate < savedEndDate {
            // Timern ska fortfarande vara igång
            let remainingTime = savedEndDate.timeIntervalSince(currentDate)
            
            // Här kan du starta om timern med kvarvarande tid
            // Exempelvis uppdatera din UI eller starta en ny nedräkning
            updateTimer(with: remainingTime)
        } else {
            // Timern är avslutad
            // Hantera avslutningen av timern
            // Exempelvis uppdatera UI eller skicka notifieringar
            timerEnded()
        }
    }

    private func updateTimer(with remainingTime: TimeInterval) {
        // Uppdatera elapsedTime och progress baserat på den återstående tiden
        DispatchQueue.main.async {
            self.elapsedTime = self.fastingTime - remainingTime
            self.progress = self.elapsedTime / self.fastingTime
        }
    }

    private func timerEnded() {
        DispatchQueue.main.async {
            // Uppdatera fastingState och andra relevanta egenskaper
            self.fastingState = .feeding
            self.fastingPeriodCompleted = true

            // Här kan du spara data eller utföra andra åtgärder som behövs vid fastans slut
            self.saveFastingData()

            // Om du har en metod för att visa en popup eller ett meddelande i UI, anropa den här
            // Exempel: self.showFastingCompletedMessage()
        }
    }


    

    
    
    
    
    
    //MARK: Notifications
    
    
    class NotificationManager: NSObject, UNUserNotificationCenterDelegate {
        override init() {
            super.init()
            UNUserNotificationCenter.current().delegate = self
        }

        func userNotificationCenter(_ center: UNUserNotificationCenter, willPresent notification: UNNotification, withCompletionHandler completionHandler: @escaping (UNNotificationPresentationOptions) -> Void) {
            completionHandler([.banner, .sound])  // Använd .banner istället för .alert
        }
    }

    
    
    
    // Funktion för att skicka en notifikation en minut efter att fastan har börjat
    func scheduleStartNotification() {
        let content = UNMutableNotificationContent()
        content.title = "Congratulations!"
        content.body = "You have started your fast."
            
        // En minut efter att fastan har börjat
        let trigger = UNTimeIntervalNotificationTrigger(timeInterval: 60, repeats: false)

        let request = UNNotificationRequest(identifier: "fastingStart", content: content, trigger: trigger)
        UNUserNotificationCenter.current().add(request) { error in
            if let error = error {
                print("Det gick inte att schemalägga startnotifikation: \(error)")
            }
        }
        print("Schemalägger startnotifikation fast 1 min after start")
    }
    
    
    
   

    
    func scheduleHalfwayNotification() {
        let content = UNMutableNotificationContent()
        content.title = "Half Way There"
        content.body = "You're halfway through your fast!"

        let halfwayInterval = fastingTime / 2
        if halfwayInterval > 0 {
            let trigger = UNTimeIntervalNotificationTrigger(timeInterval: halfwayInterval, repeats: false)
            let request = UNNotificationRequest(identifier: "fastingHalfway", content: content, trigger: trigger)
            UNUserNotificationCenter.current().add(request) { error in
                if let error = error {
                    print("Det gick inte att schemalägga halvvägs-notifikation: \(error)")
                }
            }
        }
        print("Schemalägger startnotifikation fast half")
    }



    
    
    
    
    
    
    
    
    
        private func getFastingDuration(for plan: FastingPlan) -> TimeInterval {
            switch plan {
            case .beginner:
                return 12 * 60 * 60  // 12 timmar
            case .intermediate:
                return 16 * 60 * 60  // 16 timmar
            case .advanced:
                return 20 * 60 * 60  // 20 timmar
            }
        }
    
    
    // logg fasting time notis
    func scheduleFastingLoggedNotification() {
        let content = UNMutableNotificationContent()
        content.title = "Fasting Complete"
        content.body = "Your fasting time is logged."

        // Deliver the notification immediately
        let trigger = UNTimeIntervalNotificationTrigger(timeInterval: 1, repeats: false)

        // Create the request
        let request = UNNotificationRequest(identifier: "fastingLogged", content: content, trigger: trigger)

        // Schedule the request with the system
        UNUserNotificationCenter.current().add(request) { error in
            if let error = error {
                // Handle any errors
                print("Error scheduling notification: \(error)")
            }
        }
            print("Schemalägger startnotifikation fast logged ")
    }
    
    
    


    
    func scheduleEndOfFastingNotification() {
        let content = UNMutableNotificationContent()
        content.title = "Grattis!"
        content.body = "Din fasta är nu klar."
        content.sound = UNNotificationSound.default

        // Beräkna tidpunkt när notifikationen ska skickas
        let triggerDate = endTime // antar att `endTime` är den tid då fastan är klar
        let triggerComponents = Calendar.current.dateComponents([.year, .month, .day, .hour, .minute, .second], from: triggerDate)
        let trigger = UNCalendarNotificationTrigger(dateMatching: triggerComponents, repeats: false)

        // Skapa en notifikationsbegäran med ett unikt identifierare
        let request = UNNotificationRequest(identifier: "endOfFastingNotification", content: content, trigger: trigger)

        // Lägg till notifikationsbegäran till UNUserNotificationCenter
        UNUserNotificationCenter.current().add(request) { error in
            if let error = error {
                print("Det gick inte att schemalägga slutnotifikationen: \(error)")
            } else {
                print("Slutnotifikation för fasta schemalagd.")
            }
        }
    }

    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    //MARK: saving fasting time data
    
    func saveFastingData() {
        // Use an existing elapsedTime property if available
        let totalFastingTime = elapsedTime

        // Create a new FastingRecord
        let newRecord = FastingRecord(context: PersistenceController.shared.container.viewContext)
        newRecord.totalFastingTime = totalFastingTime
        newRecord.endDate = Date()  // Consider using the current date as the end date

        // Save the record
        do {
            try PersistenceController.shared.container.viewContext.save()
        } catch {
            // Handle the error
            print("Error saving fasting data: \(error)")
        }
    }

  
    
    
    
   // spara data livcykel
    func saveFastingState() {
        UserDefaults.standard.set(startTime, forKey: "savedStartTime")
        UserDefaults.standard.set(endTime, forKey: "savedEndTime")
        UserDefaults.standard.set(fastingState.rawValue, forKey: "savedFastingState")
        UserDefaults.standard.set(fastingPlan.rawValue, forKey: "savedFastingPlan")
    }

    func restoreFastingState() {
        guard let savedStartTime = UserDefaults.standard.object(forKey: "savedStartTime") as? Date,
              let savedEndTime = UserDefaults.standard.object(forKey: "savedEndTime") as? Date,
              let savedFastingState = UserDefaults.standard.string(forKey: "savedFastingState"),
              let savedFastingPlan = UserDefaults.standard.string(forKey: "savedFastingPlan"),
              let fastingState = FastingState(rawValue: savedFastingState),
              let fastingPlan = FastingPlan(rawValue: savedFastingPlan) else {
            return
        }
        self.fastingState = fastingState
        self.fastingPlan = fastingPlan
        self.startTime = savedStartTime
        self.endTime = savedEndTime

        // Uppdatera progress och andra värden
        self.track()
    }

    
    
   
    
    
    
    
    
    
    

    
}//last
    


