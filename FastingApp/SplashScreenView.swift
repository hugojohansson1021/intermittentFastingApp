//
//  SplashScreenView.swift
//  FastingApp
//
//  Created by Hugo Johansson on 2023-11-14.
//

import SwiftUI

struct SplashScreenView: View {
    @Binding var isActive: Bool
    @State private var size = 0.8
    @State private var opacity = 0.5
    
    
    var body: some View {
       
           
        
        
        ZStack{
            LinearGradient(gradient: Gradient(colors: [Color.darkPurple, Color.purpleDark, Color.darkPink]), startPoint: .topLeading, endPoint: .bottomTrailing)
                .ignoresSafeArea()
            
            
            
            VStack{
                
                VStack{
                    Image(systemName: "circle.dashed.inset.fill")
                        .font(.system(size: 150))
                        .foregroundStyle(.blueBack)
                    Text("Inttermittent Fasting")
                        .foregroundStyle(.white)
                        .fontWeight(.bold)
                        .foregroundStyle(.black.opacity(0.80))
                }
                .scaleEffect(size)
                .opacity(opacity)
                .onAppear{
                    withAnimation(.easeIn(duration: 1.2)){
                        self.size = 0.9
                        self.opacity = 1.0
                    }
                }
            }
            .onAppear{
                DispatchQueue.main.asyncAfter(deadline: .now() + 2.0){
                    self.isActive = true
                }
            }
            
            
        }
        
        
    }
}

struct SplashScreenView_Previews: PreviewProvider {
    @State static var isActive = false // Create a state variable for the preview

    static var previews: some View {
        SplashScreenView(isActive: $isActive) // Pass the binding to isActive
    }
}
