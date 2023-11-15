//
//  ProfileView.swift
//  FastingApp
//
//  Created by Hugo Johansson on 2023-11-10.
//

import SwiftUI

struct ProfileView: View {
        @State private var name: String = ""
        @State private var email: String = ""
        @State private var message: String = ""
        @State private var showToast: Bool = false
    
    var body: some View {
        ZStack {
            LinearGradient(gradient: Gradient(colors: [Color.darkPurple, Color.purpleDark, Color.darkPink]), startPoint: .topLeading, endPoint: .bottomTrailing)
                .ignoresSafeArea()
            
            VStack(spacing: 15) {
                Image(systemName: "person.circle")
                    .imageScale(.large)
                    .foregroundColor(.white)
                
                Text("Profil")
                    .foregroundStyle(.white)
                    .font(.title)
                    .fontWeight(.bold)
                
                Spacer()
                
                Text("FeedBack ")
                    .foregroundStyle(.white)
                    .font(.title)
                    .fontWeight(.bold)
                
                
                Text("New Feature Idés?")
                    .foregroundStyle(.white)
                    .font(.headline)
                    .fontWeight(.bold)
                
                
                
                //MARK: Feedback Name
                TextField("Name ...", text: $name)
                    .padding()
                    .background(Color.white)
                    .cornerRadius(10)
                    .foregroundColor(.black)
                    .padding()
                
                
                //MARK: Feedback Emal
                TextField("Email ...", text: $email)
                    .padding()
                    .background(Color.white)
                    .cornerRadius(10)
                    .foregroundColor(.black)
                    .padding()
                
                //MARK: Feedback Message
                TextField("Message ...", text: $message)
                    .padding()
                    .background(Color.white)
                    .cornerRadius(10)
                    .foregroundColor(.black)
                    .padding()
                
                
                
                
                
                Button {
                sendFeedback(name: name, email: email, message: message)
                
                name = ""
                email = ""
                message = ""
                showToast = true
                                    
                DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
                showToast = false
                }
                } label: {
                Text("Send Feedback")
                        .fontWeight(.bold)
                        .padding(.horizontal, 24)
                        .padding(.vertical, 8)
                        .background(.thinMaterial)
                        .cornerRadius(20)
                        .foregroundColor(.white)
                                        
                    }

                    if showToast {
                    ToastView()
                    .transition(.opacity)
                    .zIndex(1)
                                }
                
                
                
                Spacer()
            
            } // VStack
             
        } //Z-stack
    }//body
    
    struct ToastView: View {
        var body: some View {
            Text("Message sent")
                .padding()
                .background(Color.white.opacity(0.7))
                .foregroundColor(Color.white)
                .cornerRadius(8)
                .padding(10)
        }
    }
    
    func sendFeedback(name: String, email: String, message: String) {
            guard let webhookURL = URL(string: "https://discord.com/api/webhooks/1174143032237494333/4cQLyvNgoYJwUpOsQO2vRP4X7GhHadkU1wgxtjvxoMSYWcFwA6gaUzifFt_TODsLEqHs") else {
                print("Ogiltig URL.")
                return
            }

            var request = URLRequest(url: webhookURL)
            request.httpMethod = "POST"
            request.addValue("application/json", forHTTPHeaderField: "Content-Type")

            let body: [String: Any] = [
                "content": "Name: \(name)\nEmail: \(email)\nMessage: \(message)"
            ]
            request.httpBody = try? JSONSerialization.data(withJSONObject: body, options: [])

            URLSession.shared.dataTask(with: request) { data, response, error in
                if let error = error {
                    print("Error sending feedback: \(error)")
                    return
                }
                
            }.resume()
        
        
        
        
        
        
        
    }
    
}
    // Preview
    struct ProfileView_Previews: PreviewProvider {
        static var previews: some View {
            ProfileView()
        }
    }
    

