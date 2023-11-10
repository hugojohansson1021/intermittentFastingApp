//
//  OpenAIService.swift
//  FastingApp
//
//  Created by Hugo Johansson on 2023-11-09.
//






//work in progress//




import Foundation

class OpenAIService {
    static let shared = OpenAIService() // Singleton instance

    private let assistantID = "asst_IaUJlsVJkkvtZafdTfPg1iIt" // Replace with your assistant ID
    private let apiKey = "sk-HERP5yBakPelazSNdxZQT3BlbkFJRVdVAnAueH9oRiNHA8M//" //=5 Replace with your API key

    

    func createThread(completion: @escaping (Result<String, Error>) -> Void) {
        let threadURL = URL(string: "https://api.openai.com/v1/threads")!

        var request = URLRequest(url: threadURL)
        request.httpMethod = "POST"
        request.addValue("Bearer \(apiKey)", forHTTPHeaderField: "Authorization")
        request.addValue("OpenAI-Beta: threads=v1", forHTTPHeaderField: "Content-Type")

        let session = URLSession.shared
        session.dataTask(with: request) { data, response, error in
            if let error = error {
                completion(.failure(error))
                return
            }
            guard let data = data else {
                completion(.failure(URLError(.badServerResponse)))
                return
            }
            let responseString = String(data: data, encoding: .utf8)
            completion(.success(responseString ?? ""))
        }.resume()
    }

}
