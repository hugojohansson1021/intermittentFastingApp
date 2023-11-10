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
            VStack {
                HStack {
                    TextField("Search Exercises", text: $searchText)
                        .padding()
                        .border(Color.gray)
                    
                    Button("Search") {
                        loadExercises()
                    }
                    .padding()
                }
                
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
            .navigationTitle("Exercise Search")
        }
    }
    
    
    
    
    
    
    struct ExerciseResponse: Codable {
        let id: Int
        let exercises: [Exercise]
    }
    
    struct Exercise: Codable, Identifiable {
        let id = UUID()  // If each exercise doesn't have an unique id, you can use UUID
        let name: String
        let muscle: String
        let infoLink: String
    }
    
    // In your loadExercises function, decode to ExerciseResponse
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
    

