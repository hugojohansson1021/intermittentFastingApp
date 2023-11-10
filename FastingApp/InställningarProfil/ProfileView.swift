//
//  ProfileView.swift
//  FastingApp
//
//  Created by Hugo Johansson on 2023-11-10.
//

import SwiftUI

struct ProfileView: View {
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
                    .font(/*@START_MENU_TOKEN@*/.title/*@END_MENU_TOKEN@*/)
                    .fontWeight(.bold)
                
                
                Spacer()
                
                
               
               
            
        }
    }
    
    
}
        
}


#Preview {
    ProfileView()
}
