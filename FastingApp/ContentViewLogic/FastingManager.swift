//
//  FastingManager.swift
//  FastingApp
//
//  Created by Hugo Johansson on 2023-10-17.
//





import Foundation
import UserNotifications



enum FastingState {
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
            return 12
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
            // Update the fasting plan and recalculate start and end times when the plan changes
            if fastingState != .notStarted {
                if fastingState == .fasting {
                    startTime = Date()
                }
                endTime = startTime.addingTimeInterval(fastingTime)
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
    
    @Published private(set) var elapsed: Bool = false
    @Published private(set) var elapsedTime: Double = 0.0
    @Published private(set) var progress: Double = 0.0
    
    var fastingTime: Double {
        return fastingPlan.fastingPeriod * 60 * 60
    }
    
    var feedingTime: Double {
        return (24 - fastingPlan.fastingPeriod) * 60 * 60
    }
    
    var isPickerEnabled: Bool {
           return fastingState == .notStarted || fastingState == .feeding
       }
    
    init(initialFastingPlan: FastingPlan = .intermediate) {
        let calendar = Calendar.current
        let components = DateComponents(hour: 20)
        let scheduledTime = calendar.nextDate(after: .now, matching: components, matchingPolicy: .nextTime)!
        startTime = scheduledTime
        endTime = scheduledTime.addingTimeInterval(initialFastingPlan.fastingPeriod * 60 * 60)
    }
    
    func toggleFastingState() {
        fastingState = fastingState == .fasting ? .feeding : .fasting
        startTime = Date()
    }


    
    
    

    
  //MARK: Track Time
    
    func track() {
        let currentTime = Date()
        elapsedTime = currentTime.timeIntervalSince(startTime)
        let totalTime = fastingState == .fasting ? fastingTime : feedingTime
        elapsed = currentTime >= endTime
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
        startTime = Date()
        elapsedTime = 0.0

        if fastingState == .feeding {
            // If fasting state changed to feeding, add completed fast data
            let fastingDuration = endTime.timeIntervalSince(startTime)
            //addCompletedFast(date: Date(), fastingDuration: fastingDuration)
            
            
        }
    }
    
    
    
    func elapsedTimeComponents() -> (hours: Int, minutes: Int, seconds: Int) {
        let totalSeconds = Int(elapsedTime)
        let hours = totalSeconds / 3600
        let minutes = (totalSeconds % 3600) / 60
        let seconds = totalSeconds % 60
        return (hours, minutes, seconds)
    }

    
    
    
    
    
    
    //MARK: Notifications
    
    
    class NotificationManager: NSObject, UNUserNotificationCenterDelegate {
        override init() {
            super.init()
            UNUserNotificationCenter.current().delegate = self
        }

        func userNotificationCenter(_ center: UNUserNotificationCenter, willPresent notification: UNNotification, withCompletionHandler completionHandler: @escaping (UNNotificationPresentationOptions) -> Void) {
            completionHandler([.alert, .sound])
        }

                
    }
    
    // Funktion för att skicka en notifikation en minut efter att fastan har börjat
    func scheduleStartNotification() {
        let content = UNMutableNotificationContent()
        content.title = "Grattis!"
        content.body = "Du har startat din fasta."

        // En minut efter att fastan har börjat
        let trigger = UNTimeIntervalNotificationTrigger(timeInterval: 60, repeats: false)

        let request = UNNotificationRequest(identifier: "fastingStart", content: content, trigger: trigger)
        UNUserNotificationCenter.current().add(request) { error in
            if let error = error {
                print("Det gick inte att schemalägga startnotifikation: \(error)")
            }
        }
    }
    
    
    
   // Fasting Node Notifacation
    
    func scheduleCompletionNotification(for selectedPlan: FastingPlan) {
        let fastingDuration = getFastingDuration(for: selectedPlan)
        
            let content = UNMutableNotificationContent()
            content.title = "Grattis!"
            content.body = "Din fasta är nu klar. Bra jobbat!"

            let trigger = UNTimeIntervalNotificationTrigger(timeInterval: fastingDuration, repeats: false)

            let request = UNNotificationRequest(identifier: "fastingCompletion", content: content, trigger: trigger)
            UNUserNotificationCenter.current().add(request) { error in
                if let error = error {
                    print("Det gick inte att schemalägga notifikation: \(error)")
                }
            }
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
    
    
    
    
    
}//last
    


