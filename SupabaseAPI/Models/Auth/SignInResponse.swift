//
//  SignInResponse.swift
//  SupabaseAPI
//
//  Created by Ali Osman Öztürk on 27.09.2025.
//


import Foundation

struct SignInResponse: Decodable, Sendable {
    let accessToken: String
    let tokenType: String
    let expiresIn: Int
    let expiresAt: Int
    let refreshToken: String
    let user: User
    let weakPassword: String?
}

