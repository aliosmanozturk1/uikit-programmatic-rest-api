//
//  APIConfig.swift
//  SupabaseAPI
//
//  Created by Ali Osman Öztürk on 30.09.2025.
//

import Foundation

final class APIConfig {
    static let shared = APIConfig()
    
    let baseURL: String
    let apiKey: String
    
    private init() {
        guard let baseURL = Bundle.main.infoDictionary?["API_URL"] as? String,
              !baseURL.isEmpty else {
            fatalError("❌ API_URL not found in Secrets.xcconfig")
        }
        
        guard let apiKey = Bundle.main.infoDictionary?["API_KEY"] as? String,
              !apiKey.isEmpty else {
            fatalError("❌ API_KEY not found in Secrets.xcconfig")
        }
        
        self.baseURL = baseURL
        self.apiKey = apiKey
    }
    
    // For testing purposes
    init(baseURL: String, apiKey: String) {
        self.baseURL = baseURL
        self.apiKey = apiKey
    }
}
