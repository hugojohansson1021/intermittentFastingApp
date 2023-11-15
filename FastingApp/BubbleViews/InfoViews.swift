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
            
            ScrollView{
                VStack(spacing: 15) {
                    
                    
                    Image(systemName: "info.bubble")
                        .imageScale(.large)
                        .foregroundColor(.white)
                    
                
                    Text("What will this app provide:")
                        .foregroundStyle(.white)
                        .font(.title)
                        .fontWeight(.bold)
                    
                    
                    Spacer()
                    
                    
                    Text("InterMittent fasting timer ")
                        .foregroundStyle(.white)
                        .font(.title2)
                        .fontWeight(.bold)
                    
                    Text("An intermittent fasting timer app, with its singular focus, offers distinct advantages. Its simplicity and user-friendly interface make it easy to navigate, ideal for those who prefer a no-frills approach. Such an app is less demanding on your device's battery and data, making it efficient and quick to access. It allows flexible customization of fasting schedules, fitting various fasting methods and personal routines. By offering just a timer, it encourages self-discipline and effective time management, essential for the success of intermittent fasting, without overwhelming the user with additional features or information.")
                        .foregroundStyle(.white)
                        .font(.headline)
                        .fontWeight(.bold)
                        .multilineTextAlignment(.center)
                        .frame(maxWidth: .infinity)
                        .padding()
                    
                    
                    
                    
                    Text("Weight Tracker ")
                        .foregroundStyle(.white)
                        .font(.title2)
                        .fontWeight(.bold)
                    
                    Text("Our app's weight tracking feature offers a comprehensive and motivational tool for managing your fitness journey. With an intuitive chart, you can easily visualize your progress over time, tracking changes in your weight against your personalized dream weight goal. The chart displays clear, easy-to-understand lines, enabling you to see at a glance how close you are to achieving your target. This feature not only helps in keeping you focused on your weight loss or gain objectives but also provides a satisfying visual representation of your hard-earned progress. It's designed to encourage and motivate you by making your journey towards your dream weight both clear and attainable.")
                        .foregroundStyle(.white)
                        .font(.headline)
                        .fontWeight(.bold)
                        .multilineTextAlignment(.center)
                        .frame(maxWidth: .infinity)
                        .padding()
                    
                    
                    
                    Text("Search training")
                        .foregroundStyle(.white)
                        .font(.title2)
                        .fontWeight(.bold)
                        
                    
                    Text("Explore our app's dynamic exercise search feature, designed to empower your workout routine with targeted exercises for specific muscle groups. Whether you're focusing on building strength in your arms, toning your legs, or enhancing core stability, simply search for the desired muscle group, and our app will present you with a curated list of effective exercises. Each exercise is accompanied by detailed instructions and visual guides to ensure proper form and maximize results. This feature is perfect for both beginners looking to learn new exercises and seasoned athletes seeking to diversify their training. Tailor your workouts with precision and achieve your fitness goals by engaging the right muscles with the right exercises, all at your fingertips.")
                        .foregroundStyle(.white)
                        .font(.headline)
                        .fontWeight(.bold)
                        .multilineTextAlignment(.center)
                        .frame(maxWidth: .infinity)
                        .padding()
                    
                    
                    Spacer()
                    
                    
                }
            }
            
        }
        
        
        
        
        
    }
}

#Preview {
    InfoViews()
}
