//
//  APIConfig.swift
//  SupabaseAPI
//
//  Created by Ali Osman Öztürk on 30.09.2025.
//

import Foundation

struct APIConfig {
    let baseURL: String
    let apiKey: String
    
    init() {
        guard let baseURL = Bundle.main.infoDictionary?["API_URL"] as? String else {
            fatalError("API_URL not found in Info.plist")
        }
        
        guard let apiKey = Bundle.main.infoDictionary?["API_KEY"] as? String else {
            fatalError("API_KEY not found in Info.plist")
        }
        
        self.baseURL = baseURL
        self.apiKey = apiKey
    }
    
    // Test veya farklı ortamlar için convenience init
    init(baseURL: String, apiKey: String) {
        self.baseURL = baseURL
        self.apiKey = apiKey
    }
}
