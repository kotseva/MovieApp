//
//  NetworkManager.swift
//  MovieApp
//
//  Created by Angela Koceva on 16.5.25.
//

import Foundation

public class NetworkManager {
    
    private let session: URLSession
    
    /* Initializes the NetworkManager with a custom URLSession configuration.
     The configuration disables local caching to always fetch fresh data. */
    init() {
        let config = URLSessionConfiguration.default
        config.requestCachePolicy = .reloadIgnoringLocalCacheData
        config.urlCache = nil
        session = URLSession(configuration: config)
    }
    
    /* Fetches a list of "Now Playing" movies from the TMDB API.
     
     - Parameter page: The page number for pagination.
     - Returns: A decoded `LatestMoviesResponseModel` object.
     - Throws: An error if the request fails or decoding is unsuccessful. */
    func fetchLatestMovies(page: Int) async throws -> LatestMoviesResponseModel {
        guard
            var components = URLComponents(
                string: "https://api.themoviedb.org/3/movie/now_playing"
            )
        else {
            throw URLError(.badURL)
        }
        
        components.queryItems = [
            URLQueryItem(
                name: "api_key",
                value: "e21adeb0c517150eea2bac95f40cd702"
            ),
            URLQueryItem(name: "language", value: "en-US"),
            URLQueryItem(name: "page", value: "\(page)"),
        ]
        
        guard let url = components.url else {
            throw URLError(.badURL)
        }
        
        print("URL: \(url.absoluteString)")
        
        // Create and configure the URLRequest.
        var request = URLRequest(url: url)
        request.httpMethod = "GET"
        request.timeoutInterval = 10
        request.setValue("application/json", forHTTPHeaderField: "accept")
        
        // Perform the network request using async/await.
        let (data, response) = try await session.data(for: request)
        
        // Validate HTTP response.
        guard let httpResponse = response as? HTTPURLResponse else {
            throw URLError(.badServerResponse)
        }
        
        print("Status code: \(httpResponse.statusCode)")
        
        guard httpResponse.statusCode == 200 else {
            let errorResponse = String(data: data, encoding: .utf8) ?? "No response body"
            print("Error body: \(errorResponse)")
            throw URLError(.badServerResponse)
        }
        
        // Decode the JSON response into a model.
        let decoder = JSONDecoder()
        decoder.keyDecodingStrategy = .convertFromSnakeCase
        
        do {
            let result = try decoder.decode(
                LatestMoviesResponseModel.self,
                from: data
            )
            return result
        } catch {
            let raw = String(data: data, encoding: .utf8) ?? "Unreadable"
            print("Recoding failed: \(error)")
            print("Raw response: \(raw)")
            throw error
        }
    }
}
