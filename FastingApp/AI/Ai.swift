//
//  Ai.swift
//  FastingApp
//
//  Created by Hugo Johansson on 2023-11-09.
//


import SwiftUI

struct Ai: View {
    @State private var userInput: String = ""
    @State private var assistantResponse: String = ""
    
    var body: some View {
        ZStack {
            LinearGradient(gradient: Gradient(colors: [Color.darkPurple, Color.purpleDark, Color.darkPink]), startPoint: .topLeading, endPoint: .bottomTrailing)
                .ignoresSafeArea()
            
            
            
            
            
            
            VStack(spacing: 15) {
                Spacer()
                
                Text("Ai Fasting Assistent")
                    .foregroundStyle(.white)
                    .font(/*@START_MENU_TOKEN@*/.title/*@END_MENU_TOKEN@*/)
                    .fontWeight(.bold)
                
                
                Spacer()
                
                Text("ask any health related question")
                    .foregroundStyle(.white)
                    .font(.headline)
                    .fontWeight(.bold)
                
                Spacer()
                
                
                TextField("Ask your question here..", text: $userInput)
                    .textFieldStyle(RoundedBorderTextFieldStyle())
                    .padding()
                    .foregroundColor(.blue)
                
                Button("Send") {
                    //send 
                    print("button pressed")
                }
                .foregroundStyle(.white)
                
                
                
            Spacer()
                
                ScrollView {
                    Text(assistantResponse)
                        .padding()
                        .foregroundStyle(.white)
                }
            }
        }
    }
    
    
}

#Preview {
    Ai()
}

