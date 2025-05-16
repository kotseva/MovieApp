//
//  NetworkManager.swift
//  MovieApp
//
//  Created by Angela Koceva on 16.5.25.
//

import Foundation

public class NetworkManager {
    
    private let session: URLSession

    init() {
        let config = URLSessionConfiguration.default
        config.requestCachePolicy = .reloadIgnoringLocalCacheData
        config.urlCache = nil
        session = URLSession(configuration: config)
    }
    
    func fetchNowPlaying(page: Int) async throws -> LatestMoviesResponseModel {
        guard var components = URLComponents(string: "https://api.themoviedb.org/3/movie/now_playing") else {
            throw URLError(.badURL)
        }

        components.queryItems = [
            URLQueryItem(name: "api_key", value: "e21adeb0c517150eea2bac95f40cd702"),
            URLQueryItem(name: "language", value: "en-US"),
            URLQueryItem(name: "page", value: "\(page)")
        ]

        guard let url = components.url else {
            throw URLError(.badURL)
        }

        print("URL: \(url.absoluteString)")

        var request = URLRequest(url: url)
        request.httpMethod = "GET"
        request.timeoutInterval = 10
        request.setValue("application/json", forHTTPHeaderField: "accept")

        let (data, response) = try await session.data(for: request)

        guard let httpResponse = response as? HTTPURLResponse else {
            throw URLError(.badServerResponse)
        }

        print("Status code: \(httpResponse.statusCode)")

        guard httpResponse.statusCode == 200 else {
            let errorResponse = String(data: data, encoding: .utf8) ?? "No response body"
            print("Error body: \(errorResponse)")
            throw URLError(.badServerResponse)
        }

        let decoder = JSONDecoder()
        decoder.keyDecodingStrategy = .convertFromSnakeCase

        do {
            let result = try decoder.decode(LatestMoviesResponseModel.self, from: data)
            return result
        } catch {
            let raw = String(data: data, encoding: .utf8) ?? "Unreadable"
            print("Recoding failed: \(error)")
            print("Raw response: \(raw)")
            throw error
        }
    }
}
