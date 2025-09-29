//
//  AuthService.swift
//  SupabaseAPI
//
//  Created by Ali Osman Öztürk on 29.09.2025.
//

import Foundation

protocol AuthServiceProtocol {
    func signIn(email: String, password: String) async throws -> SignInResponse
}

final class AuthService: AuthServiceProtocol {
    private let networkManager: NetworkManagerProtocol
    
    init(networkManager: NetworkManagerProtocol = NetworkManager()) {
        self.networkManager = networkManager
    }
    
    func signIn(email: String, password: String) async throws -> SignInResponse {
        guard let baseURL = Bundle.main.infoDictionary?["API_URL"] as? String else {
            fatalError("API_URL not found in Info.plist")
        }
        
        guard let apiKey = Bundle.main.infoDictionary?["API_KEY"] as? String else {
            fatalError("API_KEY not found in Info.plist")
        }
        
        let endpoint = baseURL + "/auth/v1/token?grant_type=password"
        let method = "POST"
        
        let body = [
            "email": email,
            "password": password
        ]
        
        let header = [
            "apikey": apiKey,
            "Content-Type": "application/json"
        ]
        
        return try await networkManager.request(endpoint: endpoint, method: method, headers: header, body: body)
    }
}
