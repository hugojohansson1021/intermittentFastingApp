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
    @State private var isLoading: Bool = false
        
    
    var body: some View {
        ZStack {
            LinearGradient(gradient: Gradient(colors: [Color.darkPurple, Color.purpleDark, Color.darkPink]), startPoint: .topLeading, endPoint: .bottomTrailing)
                .ignoresSafeArea()
            
            
            
            
            
            
            VStack(spacing: 5) {
                Spacer()
                
                Text("FastingGPT")
                    .foregroundStyle(.white)
                    .font(/*@START_MENU_TOKEN@*/.title/*@END_MENU_TOKEN@*/)
                    .fontWeight(.bold)
                
                
                Spacer()
                
                Text("ask me any health related question")
                    .foregroundStyle(.white)
                    .font(.headline)
                    .fontWeight(.bold)
                
                Spacer()
                
                Image(systemName: "brain.head.profile")
                    .imageScale(.large)
                    .foregroundColor(.white)
                
                Spacer()
                
                Text("The gpt may take a few seconds")
                    .foregroundStyle(.white)
                    .font(.caption)
                    .fontWeight(.bold)
                
                
                TextField("Ask your question here..", text: $userInput)
                                    .padding(10) // Adjust padding to increase the size of the TextField
                                    .background(Color.white) // Set the background color to white
                                    .cornerRadius(5) // Rounded corners
                                    .overlay(
                                        RoundedRectangle(cornerRadius: 5)
                                            .stroke(Color.gray, lineWidth: 1) // Border with color and line width
                                    )
                                    .foregroundColor(.black) // Text color
                                    .padding() // Padding around the TextField to match your layout
                                
                
                Button("Send") {
                    isLoading = true  // Start loading when button is pressed
                    APIManager.shared.fetchResponse(for: userInput) { response in
                        self.assistantResponse = response
                        isLoading = false  // Stop loading when response is received
                    }
                    userInput = "" 
                }
                .disabled(isLoading)
                .fontWeight(.bold)
                .padding(.horizontal, 54)
                .padding(.vertical, 15)
                .background(.thinMaterial)
                .cornerRadius(20)
                .foregroundColor(.white)
                
                Spacer()
                
                if isLoading {
                ProgressView()
                .progressViewStyle(CircularProgressViewStyle(tint: .white))
                .scaleEffect(1.5, anchor: .center)
                }
                
                
                
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

