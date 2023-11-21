//
//  ExerciseSearchView.swift
//  FastingApp
//
//  Created by Hugo Johansson on 2023-11-10.
//

import SwiftUI

struct ExerciseSearchView: View {
    @State private var searchText = ""
    @State private var exercises: [Exercise] = []
    
    var body: some View {
        NavigationView {
            ZStack {
                //MARK: Background
                LinearGradient(gradient: Gradient(colors: [Color.darkPurple, Color.purpleDark, Color.darkPink]), startPoint: .topLeading, endPoint: .bottomTrailing)
                    .ignoresSafeArea()
                
                
                
                VStack(spacing:10) {
                    
                    
                    Text("Search Exercise")
                        .font(.title)
                        .fontWeight(/*@START_MENU_TOKEN@*/.bold/*@END_MENU_TOKEN@*/)
                        .foregroundStyle(.white)
                    
                    
                    Text("Search for specific mucle grups you want to train")
                        .font(.title2)
                        .fontWeight(/*@START_MENU_TOKEN@*/.bold/*@END_MENU_TOKEN@*/)
                        .foregroundStyle(.white)
                        .padding()
                    
                    
                    TextField("Search Exercises", text: $searchText)
                        .padding(.horizontal, 24)
                        .padding(.vertical, 8)
                        .foregroundColor(.white)
                        .background(.thinMaterial)
                        .cornerRadius(20)
                        .frame(maxWidth: .infinity, alignment: .leading)
                        .padding()

                        
                        
                    
                    
                    
                    Button {
                        loadExercises()
                    } label: {
                        Text("Search")
                            .fontWeight(.bold)
                            .padding(.horizontal, 24)
                            .padding(.vertical, 8)
                            .background(.thinMaterial)
                            .cornerRadius(20)
                            .foregroundColor(.white)
                    }
                    
                    
                    
                    
                    Spacer()
                    
                    List(exercises, id: \.id) { exercise in
                        VStack(alignment: .leading) {
                            Text(exercise.name)
                                .font(.headline)
                            Text(exercise.muscle)
                                .font(.subheadline)
                            Button("Exercise Info") {
                                if let url = URL(string: exercise.infoLink) {
                                    UIApplication.shared.open(url)
                                }
                            }
                            .font(.footnote)
                            
                            
                            
                        }
                        
                    }
                }
                
                
            }
            
        }
        
    }
    
    
    
    
    
    
    struct ExerciseResponse: Codable {
        let id: Int
        let exercises: [Exercise]
    }
    
    struct Exercise: Codable, Identifiable {
        let id = UUID()
        let name: String
        let muscle: String
        let infoLink: String
    }
    
    
    func loadExercises() {
        guard let url = URL(string: "https://api.algobook.info/v1/gym/categories/\(searchText)") else { return }
        
        URLSession.shared.dataTask(with: url) { data, response, error in
            if let data = data {
                do {
                    let decodedResponse = try JSONDecoder().decode(ExerciseResponse.self, from: data)
                    DispatchQueue.main.async {
                        self.exercises = decodedResponse.exercises
                    }
                } catch {
                    print("Failed to decode JSON: \(error)")
                }
            }
        }.resume()
    }
    
    
    
}
    
    // Preview
    struct ExerciseSearchView_Previews: PreviewProvider {
        static var previews: some View {
            ExerciseSearchView()
        }
    }
    

