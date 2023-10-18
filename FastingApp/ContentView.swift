//
//  ContentView.swift
//  FastingApp
//
//  Created by Hugo Johansson on 2023-10-17.
//

import SwiftUI

struct ContentView: View {
    
    @StateObject  var fastingManager = FastingManager()
    
    var title: String{
        switch fastingManager.fastingState {
        case .notStarted:
            return "Lets get started"
        case .fasting:
            return "you are now fasting"
        case .feeding:
            return "you are now feeding"
        }
    }
    
    
    
    
    
    var body: some View {
        ZStack{
        //MARK: Background
            
            LinearGradient(gradient: Gradient(colors: [Color.darkPurple, Color.purpleDark, Color.darkPink]), startPoint: .topLeading, endPoint: .bottomTrailing)
                .ignoresSafeArea()
            
            //Color(#colorLiteral(red: 0.07061080267, green: 0.3755476364, blue: 0.4745892397, alpha: 1))
              //  .ignoresSafeArea()
            
            
            content
        }
    }
    
    var content: some View {
        
        VStack (spacing: 40){
            
            //MARK: Title
            
            Text(title)
                .font(.headline)
                
            // MARK: FAsting plan
             
            Text(fastingManager.fastingPlan.rawValue)
                .fontWeight(.bold)
                .padding(.horizontal, 24)
                .padding(.vertical, 8)
                .background(.thinMaterial)
                .cornerRadius(20)
            
            
            //MARK: Progressring
            
            ProgressRing()
                .environmentObject(fastingManager)
            
            
            HStack(spacing: 60){
                
            //MARK: Start Time
                VStack(spacing: 5){
                    Text(fastingManager.fastingState == .notStarted ? "Start" : "Started")
                        .opacity(0.7)
                    
                    
                    Text(fastingManager.startTime, format: .dateTime.weekday().hour().minute().second())
                        .fontWeight(.bold)
                    
                    
                }
                
            //MARK: End Time
                VStack(spacing: 5){
                    Text(fastingManager.fastingState == .notStarted ? "End" : "Ends")
                        .opacity(0.7)
                    
                    
                    Text(fastingManager.endTime, format: .dateTime.weekday().hour().minute().second())
                        .fontWeight(.bold)
                }
                
                
                
            }
            
            //MARK: Button
            
            Button {
                fastingManager.toggleFastingState()
            
            } label: {
                Text(fastingManager.fastingState == .fasting ? "End fast" : "Start fasting")
                    .fontWeight(.bold)
                    .padding(.horizontal, 24)
                    .padding(.vertical, 8)
                    .background(.thinMaterial)
                    .cornerRadius(20)
                
            }
            
            
            
            
            
            Spacer()
            
            
          
        }
       
        .foregroundColor(.white)
    }
}

#Preview {
    ContentView()
}
