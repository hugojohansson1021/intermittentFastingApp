//
//  GoalPickerView.swift
//  FastingApp
//
//  Created by Hugo Johansson on 2023-11-02.
//


import SwiftUI

struct GoalPickerView: View {
    @Binding var goalWeight: Int
    @Environment(\.presentationMode) var presentationMode
    
    var body: some View {
        ZStack {
            Color.purpleDark
                .ignoresSafeArea()
            
            VStack {
                HStack {
                    
                    Button("Back") {
                        presentationMode.wrappedValue.dismiss()
                    }
                    .foregroundColor(.white)
                    .font(.title2)
                    .fontWeight(.bold)
                    .padding()
                    Spacer()
                }
                
                
                Text("Choose a goal Weight")
                    .font(.title)
                    .padding()
                    .foregroundStyle(.white)
                    .fontWeight(.bold)
                    
                    
                Picker("Goal Weight", selection: $goalWeight) {
                    ForEach(50...350, id: \.self) {
                        Text("\($0)")
                    }
                }
                .pickerStyle(WheelPickerStyle())
                .frame(height: 150)
                .clipped()
                .accentColor(.white)
                .background(Color.white.opacity(0.7))
                .cornerRadius(10)
                .padding()
                
                Button("Save") {
                    // Lägg till kod här för att spara det valda målvikten
                    presentationMode.wrappedValue.dismiss()
                }
                .fontWeight(.bold)
                .padding(.horizontal, 24)
                .padding(.vertical, 8)
                .background(.thinMaterial)
                .cornerRadius(20)
                .foregroundColor(.white)
                
                Spacer()
            }
        }
        
    }
}

struct GoalPickerView_Previews: PreviewProvider {
    @State static var previewGoalWeight = 60

    static var previews: some View {
        GoalPickerView(goalWeight: $previewGoalWeight)
    }
}

