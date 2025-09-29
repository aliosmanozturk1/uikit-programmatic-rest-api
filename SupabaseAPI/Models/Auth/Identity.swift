//
//  Identity.swift
//  SupabaseAPI
//
//  Created by Ali Osman Öztürk on 27.09.2025.
//

import Foundation

struct Identity: Decodable, Sendable {
    let identityId: String
    let id: String
    let userId: String
    let identityData: IdentityData
    let provider: String
    let lastSignInAt: String
    let createdAt: String
    let updatedAt: String
    let email: String
    
    enum CodingKeys: String, CodingKey {
        case id, provider, email
        case identityId = "identity_id"
        case userId = "user_id"
        case identityData = "identity_data"
        case lastSignInAt = "last_sign_in_at"
        case createdAt = "created_at"
        case updatedAt = "updated_at"
    }
}

struct IdentityData: Decodable, Sendable {
    let email: String
    let emailVerified: Bool
    let phoneVerified: Bool
    let sub: String
    
    enum CodingKeys: String, CodingKey {
        case email, sub
        case emailVerified = "email_verified"
        case phoneVerified = "phone_verified"
    }
}
