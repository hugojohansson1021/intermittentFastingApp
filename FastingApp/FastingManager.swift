//
//  FastingManager.swift
//  FastingApp
//
//  Created by Hugo Johansson on 2023-10-17.
//

import Foundation


enum FastingState {
    case notStarted
    case fasting
    case feeding
    
}

enum FastingPlan: String{
    case beginner = "12:12"
    case intermediate = "16:8"
    case advanced = "20:4"
    
    var fastingPeriod: Double{
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
    @Published private(set) var fastingPlan: FastingPlan = .intermediate
    @Published private(set) var startTime: Date {
        didSet{
            print("StartTime", startTime.formatted(.dateTime.month().day().hour().minute().second()))
            if fastingState == .fasting{
                endTime = startTime.addingTimeInterval(fastingTime)
            }else {
                endTime = startTime.addingTimeInterval(feedingTime)
            }
        }
    }

    @Published private(set) var endTime: Date{
        didSet{
            print("EndTime", endTime.formatted(.dateTime.month().day().hour().minute().second()))
        }
    }
    
    
    @Published private(set) var elapsed: Bool = false
    @Published private(set) var elapsedTime: Double = 0.0
    @Published private(set) var progress: Double = 0.0
    
    
    
    
    
    
    
    var fastingTime: Double{
        return fastingPlan.fastingPeriod
    } //* 60 * 60
    var feedingTime: Double{
        return (24 - fastingPlan.fastingPeriod)
    }//* 60 * 60
   
    init(){
        let calandar = Calendar.current
        
        //var components = calandar.dateComponents([.year, .month, .day, .hour], from: Date())
        //components.hour = 20
        //print(components)
        
        //let scheduledTime = calandar.date(from: components) ?? Date.now
        //print("scheduledTime", scheduledTime.formatted(.dateTime.month().day().hour().minute().second()))
        
        let components = DateComponents(hour: 20)
        let scheduledTime = calandar.nextDate(after: .now, matching: components, matchingPolicy: .nextTime)!
        print("scheduledTime", scheduledTime.formatted(.dateTime.month().day().hour().minute().second()))
        
        startTime = scheduledTime
        endTime = scheduledTime.addingTimeInterval(FastingPlan.intermediate.fastingPeriod ) //* 60 * 60
        
        
        
    }
    
    func toggleFastingState(){
        fastingState = fastingState == .fasting ? .feeding : .fasting
        startTime = Date()
        elapsedTime = 0.0
    }
    
    
    func track() {
        guard fastingState != .notStarted else { return }
        print("now", Date().formatted(.dateTime.month().day().hour().minute().second()))
        
        if endTime >= Date(){
            print("not Elapsed")
            elapsed = false
        } else {
            print("elapled")
            elapsed = true
        }
        
        
     elapsedTime += 1
        print("elapsedTime", elapsedTime)
        
        let totalTime = fastingState == .fasting ? fastingTime : feedingTime
        progress = (elapsedTime / totalTime * 100).rounded() / 100
        print("progress", progress)
    }
}
