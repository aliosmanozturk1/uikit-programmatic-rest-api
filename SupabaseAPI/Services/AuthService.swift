//
//  AuthService.swift
//  SupabaseAPI
//
//  Created by Ali Osman Öztürk on 29.09.2025.
//

import Foundation

protocol AuthServiceProtocol {
    func signIn(email: String, password: String) async throws -> SignInResponse
    func signUp(email: String, password: String) async throws -> SignUpResponse
    func refreshSession(refreshToken: String) async throws -> SignInResponse
    func fetchCurrentUser(accessToken: String) async throws -> User
    func resendVerificationEmail(email: String) async throws
}

final class AuthService: AuthServiceProtocol {
    private let networkManager: NetworkManagerProtocol
    private let apiConfig: APIConfig
    
    init(networkManager: NetworkManagerProtocol = NetworkManager(), apiConfig: APIConfig = APIConfig()) {
        self.networkManager = networkManager
        self.apiConfig = apiConfig
    }
    
    func signIn(email: String, password: String) async throws -> SignInResponse {
        let endpoint = apiConfig.baseURL + "/auth/v1/token?grant_type=password"
        
        let body = [
            "email": email,
            "password": password
        ]
        
        let header = [
            HTTPHeaderKey.apiKey.rawValue: apiConfig.apiKey,
            HTTPHeaderKey.contentType.rawValue: HTTPHeaderValue.applicationJSON
        ]
        
        return try await networkManager.request(endpoint: endpoint, method: .post, headers: header, body: body)
    }
    
    func signUp(email: String, password: String) async throws -> SignUpResponse {
        let endpoint = apiConfig.baseURL + "/auth/v1/signup"

        let body = [
            "email": email,
            "password": password
        ]

        let header = [
            HTTPHeaderKey.apiKey.rawValue: apiConfig.apiKey,
            HTTPHeaderKey.contentType.rawValue: HTTPHeaderValue.applicationJSON
        ]

        return try await networkManager.request(endpoint: endpoint, method: .post, headers: header, body: body)
    }

    func refreshSession(refreshToken: String) async throws -> SignInResponse {
        let endpoint = apiConfig.baseURL + "/auth/v1/token?grant_type=refresh_token"

        let body = [
            "refresh_token": refreshToken
        ]

        let header = [
            HTTPHeaderKey.apiKey.rawValue: apiConfig.apiKey,
            HTTPHeaderKey.contentType.rawValue: HTTPHeaderValue.applicationJSON
        ]

        return try await networkManager.request(endpoint: endpoint, method: .post, headers: header, body: body)
    }

    func fetchCurrentUser(accessToken: String) async throws -> User {
        let endpoint = apiConfig.baseURL + "/auth/v1/user"

        let header = [
            HTTPHeaderKey.apiKey.rawValue: apiConfig.apiKey,
            HTTPHeaderKey.authorization.rawValue: HTTPHeaderValue.bearer(accessToken),
            HTTPHeaderKey.contentType.rawValue: HTTPHeaderValue.applicationJSON
        ]

        return try await networkManager.request(endpoint: endpoint, method: .get, headers: header, body: nil)
    }

    func resendVerificationEmail(email: String) async throws {
        let endpoint = apiConfig.baseURL + "/auth/v1/otp"

        let body = [
            "email": email,
            "type": "signup"
        ]

        let header = [
            HTTPHeaderKey.apiKey.rawValue: apiConfig.apiKey,
            HTTPHeaderKey.contentType.rawValue: HTTPHeaderValue.applicationJSON
        ]

        _ = try await networkManager.request(endpoint: endpoint, method: .post, body: body, headers: header)
    }
}
