//
//  APIManager.swift
//  FastingApp
//
//  Created by Hugo Johansson on 2023-11-15.
//


import Foundation

class APIManager {
    static let shared = APIManager()

    func fetchResponse(for userInput: String, completion: @escaping (String) -> Void) {
        let urlString = "https://api.openai.com/v1/chat/completions"

        guard let url = URL(string: urlString) else {
            fatalError("Invalid URL, check for typos")
        }

       
        
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        request.setValue("Bearer \("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")", forHTTPHeaderField: "Authorization")


        let parameters: [String: Any] = [
            "model": "gpt-3.5-turbo",
            "messages": [
                [
                    "role": "system",
                    "content": "You help people with health"
                ],
                [
                    "role": "user",
                    "content": userInput
                ]
            ],
            "temperature": 0.7,
            "max_tokens": 150
        ]

        guard let jsonData = try? JSONSerialization.data(withJSONObject: parameters) else {
            fatalError("Error encoding parameters")
        }

        request.httpBody = jsonData

        let session = URLSession.shared

        
        let task = session.dataTask(with: request) { data, response, error in
            if let error = error {
                print("Error: \(error)")
                DispatchQueue.main.async {
                    completion("Error: \(error.localizedDescription)")
                }
                return
            }

            guard let data = data else {
                print("No data returned")
                DispatchQueue.main.async {
                    completion("No data returned")
                }
                return
            }

            do {
                if let json = try JSONSerialization.jsonObject(with: data, options: []) as? [String: Any],
                   let choices = json["choices"] as? [[String: Any]],
                   let firstChoice = choices.first,
                   let message = firstChoice["message"] as? [String: Any],
                   let content = message["content"] as? String {
                    DispatchQueue.main.async {
                        completion(content)
                    }
                } else {
                    DispatchQueue.main.async {
                        completion("Invalid response format")
                    }
                }
            } catch {
                DispatchQueue.main.async {
                    completion("JSON parsing error: \(error)")
                }
            }
        }
        task.resume()

    }
}
