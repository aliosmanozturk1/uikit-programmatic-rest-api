//
//  SignInResponse.swift
//  SupabaseAPI
//
//  Created by Ali Osman Öztürk on 27.09.2025.
//


import Foundation

struct SignInResponse: Codable {
    let accessToken: String
    let tokenType: String
    let expiresIn: Int
    let expiresAt: Int
    let refreshToken: String
    let user: User
    let weakPassword: String?

    enum CodingKeys: String, CodingKey {
        case accessToken = "access_token"
        case tokenType = "token_type"
        case expiresIn = "expires_in"
        case expiresAt = "expires_at"
        case refreshToken = "refresh_token"
        case user
        case weakPassword = "weak_password"
    }
}

