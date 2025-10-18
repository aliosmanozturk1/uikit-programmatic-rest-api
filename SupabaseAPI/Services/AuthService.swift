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
    
    init(networkManager: NetworkManagerProtocol = NetworkManager.shared) {
        self.networkManager = networkManager
    }
    
    func signIn(email: String, password: String) async throws -> SignInResponse {
        let endpoint = AuthEndpoint.signIn(email: email, password: password)
        return try await networkManager.request(endpoint)
    }
    
    func signUp(email: String, password: String) async throws -> SignUpResponse {
        let endpoint = AuthEndpoint.signUp(email: email, password: password)
        return try await networkManager.request(endpoint)
    }
    
    func refreshSession(refreshToken: String) async throws -> SignInResponse {
        let endpoint = AuthEndpoint.refreshSession(refreshToken: refreshToken)
        return try await networkManager.request(endpoint)
    }
    
    func fetchCurrentUser(accessToken: String) async throws -> User {
        let endpoint = AuthEndpoint.currentUser(accessToken: accessToken)
        return try await networkManager.request(endpoint)
    }
    
    func resendVerificationEmail(email: String) async throws {
        let endpoint = AuthEndpoint.resendVerification(email: email)
        _ = try await networkManager.request(endpoint)
    }
}
