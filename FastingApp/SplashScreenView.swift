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
    @EnvironmentObject var userSettings: UserSettings
    
    var body: some View {
       
           
        
        
        ZStack{
            
            CustomBackground()
            
            
            
            VStack{
                
                VStack{
                    Image(systemName: "circle.dashed.inset.fill")
                        .font(.system(size: 200))
                        .foregroundStyle(.white)
                        .padding()
                   
                    
                    Text("BioFast")
                        .foregroundStyle(.white)
                        .font(.title)
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
            
            
        }.environment(\.colorScheme, .light) // HårdK light mode 
        
        
    }
}



struct SplashScreenView_Previews: PreviewProvider {
    @State static var isActive = false

    static var previews: some View {
        SplashScreenView(isActive: $isActive) 
            .environmentObject(UserSettings())
    }
}
