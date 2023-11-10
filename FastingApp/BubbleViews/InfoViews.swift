//
//  InfoViews.swift
//  FastingApp
//
//  Created by Hugo Johansson on 2023-11-10.
//

import SwiftUI

struct InfoViews: View {
    var body: some View {
        
        
        
        
        ZStack {
            LinearGradient(gradient: Gradient(colors: [Color.darkPurple, Color.purpleDark, Color.darkPink]), startPoint: .topLeading, endPoint: .bottomTrailing)
                .ignoresSafeArea()
            
            
            VStack(spacing: 15) {
                
                
                Image(systemName: "info.bubble")
                    .imageScale(.large)
                    .foregroundColor(.white)
              
                
                Text("BioHacks")
                    .foregroundStyle(.white)
                    .font(/*@START_MENU_TOKEN@*/.title/*@END_MENU_TOKEN@*/)
                    .fontWeight(.bold)
                
                
                Text("What will this app provide:")
                    .foregroundStyle(.white)
                    .font(.headline)
                    .fontWeight(.bold)
                
                
                Spacer()
                
                
            }
        }
        
        
        
        
        
    }
}

#Preview {
    InfoViews()
}
