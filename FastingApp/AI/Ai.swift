//
//  Ai.swift
//  FastingApp
//
//  Created by Hugo Johansson on 2023-11-09.
//

import SwiftUI

struct Ai: View {
    @State private var userInput: String = ""
    @State private var messages: [Message] = []
    @State private var isLoading: Bool = false

    @EnvironmentObject var userSettings: UserSettings

    var body: some View {
        ZStack {
            CustomBackground()
                .edgesIgnoringSafeArea(.all)

            VStack {
                ScrollView {
                    VStack(spacing: 10) {
                        ForEach(messages) { message in
                            HStack {
                                if message.isUser {
                                    Spacer()
                                    Text(message.text)
                                        .padding()
                                        .background(.thinMaterial)
                                        .cornerRadius(10)
                                        .foregroundColor(.white)
                                        .frame(maxWidth: UIScreen.main.bounds.width * 0.7, alignment: .trailing)
                                } else {
                                    Text(message.text)
                                        .padding()
                                        .background(Color.gray.opacity(0.7))
                                        .cornerRadius(10)
                                        .foregroundColor(.white)
                                        .frame(maxWidth: UIScreen.main.bounds.width * 0.7, alignment: .leading)
                                    Spacer()
                                }
                            }
                        }
                        
                        if isLoading {
                            HStack {
                                Spacer()
                                ProgressView()
                                    .progressViewStyle(CircularProgressViewStyle(tint: .white))
                                    .scaleEffect(1.5, anchor: .center)
                                Spacer()
                            }
                        }
                    }
                }
                .padding()

                HStack {
                    TextField("Ask your question here...", text: $userInput)
                        .padding(10)
                        .background(Color.white)
                        .cornerRadius(20)
                        .overlay(
                            RoundedRectangle(cornerRadius: 20)
                                .stroke(Color.gray, lineWidth: 1)
                        )
                        .foregroundColor(.black)
                    
                    Button(action: sendMessage) {
                        Text("Send")
                            .fontWeight(.bold)
                            .padding(.horizontal, 20)
                            .padding(.vertical, 10)
                            .background(.thinMaterial)
                            .cornerRadius(20)
                            .foregroundColor(.white)
                    }
                    .disabled(isLoading || userInput.isEmpty)
                }
                .padding()
            }
            .navigationTitle("Fasting GPT")
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

    private func sendMessage() {
        let userMessage = Message(text: userInput, isUser: true)
        messages.append(userMessage)
        userInput = ""

        isLoading = true
        APIManager.shared.fetchResponse(for: userMessage.text) { response in
            let assistantMessage = Message(text: response, isUser: false)
            messages.append(assistantMessage)
            isLoading = false
        }
    }
}

struct Message: Identifiable {
    let id = UUID()
    let text: String
    let isUser: Bool
}

#Preview {
    Ai()
        .environmentObject(UserSettings())
}


