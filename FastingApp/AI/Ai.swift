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
        
    @EnvironmentObject var userSettings: UserSettings 
    var body: some View {
        ZStack {
            CustomBackground()

            ScrollView {
                VStack(spacing: 5) {
                    Spacer()
                    
                    Image(systemName: "brain.head.profile")
                        .imageScale(.large)
                        .foregroundColor(.white)
                        .font(.system(size: 70))
                    
                    Spacer()
                    
                    Text("ask me any health related question")
                        .foregroundStyle(.white)
                        .font(.headline)
                        .fontWeight(.bold)
                    
                    Spacer()
                    
                    Text("The gpt may take a few seconds")
                        .foregroundStyle(.white)
                        .font(.caption)
                        .fontWeight(.bold)
                    
                    TextField("Ask your question here..", text: $userInput)
                        .padding(10)
                        .background(Color.white)
                        .cornerRadius(5)
                        .overlay(
                            RoundedRectangle(cornerRadius: 5)
                                .stroke(Color.gray, lineWidth: 1)
                        )
                        .foregroundColor(.black)
                        .padding()
                    
                    Button("Send") {
                        isLoading = true
                        APIManager.shared.fetchResponse(for: userInput) { response in
                            self.assistantResponse = response
                            isLoading = false
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
                    
                    Text(assistantResponse)
                        .padding()
                        .foregroundStyle(.white)
                }
            }
            .navigationTitle("Fasting GPT1")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .principal) {
                    Text("Fasting GPT")
                        .foregroundColor(.white)
                        .font(.title2)
                        .fontWeight(.bold)
                }
            }
        }
        .environment(\.colorScheme, .light)
    }
}

#Preview {
    Ai()
        .environmentObject(UserSettings())
}

