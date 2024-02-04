//
//  ProfilView.swift
//  FastingApp
//
//  Created by Hugo Johansson on 2024-01-09.
//



import SwiftUI

struct ProfilView: View {
      
    @State private var showingSettings = false
    @State private var showingInfoView = false
    @State private var showingFeedback = false
    
    @EnvironmentObject var userSettings: UserSettings//color status
    var body: some View {
        
            ZStack {
                CustomBackground()

                
                VStack(spacing: 15) {
                    Image(systemName: "person.circle")
                        .font(.system(size: 70))
                        .imageScale(.large)
                        .foregroundColor(.white)
                    
                    Text("")
                        .foregroundStyle(.white)
                        .font(.title)
                        .fontWeight(.bold)
                    
                    
                    
                    
                    
                    
                    
                    Text("")
                        .foregroundStyle(.white)
                        .font(.headline)
                        .fontWeight(.bold)
                    
                    
                    
                    Spacer()
                    
                    
                    
                    //MARK: Setting Sheet
                    Button(action: {
                                   showingSettings = true
                               }) {
                                   HStack {
                                       Image(systemName: "transmission")
                                           .imageScale(.large)
                                           .foregroundColor(.white)
                                       
                                       Text("Settings")
                                           .foregroundColor(.white)
                                           .font(.title)
                                   }
                                   .frame(width: 300, height: 40)
                                   .background(.thinMaterial)
                                   .cornerRadius(20)
                                   .padding()
                               }
                               .sheet(isPresented: $showingSettings) {
                                   Settings()
                               }
                    
                    
                    
                    
                    //MARK: Info Sheet
                    Button(action: {
                                     showingInfoView = true
                               }) {
                                   HStack {
                                       Image(systemName: "info.bubble")
                                           .imageScale(.large)
                                           .foregroundColor(.white)
                                       
                                       Text("Info")
                                           .foregroundColor(.white)
                                           .font(.title)
                                   }
                                   .frame(width: 300, height: 40)
                                   .background(.thinMaterial)
                                   .cornerRadius(20)
                                   .padding()
                               }
                               .sheet(isPresented: $showingInfoView) {
                                   InfoViews()
                               }
                    
                    
                    //MARK: FeedBack Sheet
                    Button(action: {
                                     showingFeedback = true
                               }) {
                                   HStack {
                                       Image(systemName: "message")
                                           .imageScale(.large)
                                           .foregroundColor(.white)
                                       
                                       Text("FeedBack")
                                           .foregroundColor(.white)
                                           .font(.title)
                                   }
                                   .frame(width: 300, height: 40)
                                   .background(.thinMaterial)
                                   .cornerRadius(20)
                                   .padding()
                               }
                               .sheet(isPresented: $showingFeedback) {
                                   FeedBackView()
                               }
                    
                    
                
                    
                    
                    
                    
                    Spacer()
                    
                    
                    Text("New features and updates will come in time ")
                        .font(.footnote)
                        .foregroundStyle(.white)
                    
                } // VStack
                
            }//Z-stack
            .environment(\.colorScheme, .light) // Hårdk
        
    }//body
    
        
        
    }
    
    

    // Preview
    struct ProfilView_Previews: PreviewProvider {
        static var previews: some View {
            ProfilView()
            .environmentObject(UserSettings())
        }
    }
    

