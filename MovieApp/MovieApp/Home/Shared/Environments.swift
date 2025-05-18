//
//  Environments.swift
//  MovieApp
//
//  Created by Angela Koceva on 18.5.25.
//

import Foundation

enum Environment {
    
    private static let infoDict: [String: Any] = {
        guard let dict = Bundle.main.infoDictionary else {
            fatalError("plist is not found")
        }
        return dict
    }()
    
    static let rootURL: URL = {
        guard let urlString = Environment.infoDict["ROOT_URL"] as? String else {
            fatalError("ROOT_URL is not found")
        }
        
        guard let url = URL(string: urlString) else {
            fatalError("ROOT_URL is invalid")
        }
        return url
    }()
    
    static let apiKey: String = {
        guard let key = Environment.infoDict["API_KEY"] as? String else {
            fatalError("API_KEY is not found")
        }
        
        return key
    }()
    
    static let currentEnvironment: String = {
        guard let key = Environment.infoDict["CURRENT_ENV"] as? String else {
            fatalError("API_KEY is not found")
        }
        
        return key
    }()
}
