//
//  TrackWeightView.swift
//  FastingApp
//
//  Created by Hugo Johansson on 2023-10-18.
//

import SwiftUI

struct TrackWeightView: View {
    var body: some View {
        
        
        ZStack{
        //MARK: Background
            
            LinearGradient(gradient: Gradient(colors: [Color.darkPurple, Color.purpleDark, Color.darkPink]), startPoint: .topLeading, endPoint: .bottomTrailing)
                .ignoresSafeArea()
            
            VStack{
                
                
                Text("Weight Tracker")
                    .font(.title)
                    .fontWeight(.bold)
                    .foregroundStyle(.white)
                    .padding(.bottom)
                    .padding(.top)
                    
                    
                
                
                VStack(spacing:30){
                    Rectangle()
                        .frame(width: 350, height: 270)
                        .cornerRadius(20.0)
                }
                
                
                
                Button(action: {
                    
                }, label: {
                    Text("Track Weight")
                })
                
                .fontWeight(.bold)
                .padding(.horizontal, 24)
                .padding(.vertical, 15)
                .background(.thinMaterial)
                .cornerRadius(20)
                
                
                
                Spacer()
                
            }
            
            
            
            
            
            
            
            
            
            
        }//Z-Stack
        
        
    }
}

#Preview {
    TrackWeightView()
}
