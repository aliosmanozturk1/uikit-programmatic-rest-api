//
//  SignUpResponse.swift
//  SupabaseAPI
//
//  Created by Ali Osman Öztürk on 27.09.2025.
//


import Foundation

struct SignUpResponse: Decodable, Sendable {
    let id: String
    let aud: String
    let role: String
    let email: String
    let phone: String
    let confirmationSentAt: String
    let appMetadata: AppMetadata
    let userMetadata: UserMetadata
    let identities: [Identity]
    let createdAt: String
    let updatedAt: String
    let isAnonymous: Bool

    enum CodingKeys: String, CodingKey {
        case id, aud, role, email, phone
        case confirmationSentAt = "confirmation_sent_at"
        case appMetadata = "app_metadata"
        case userMetadata = "user_metadata"
        case identities
        case createdAt = "created_at"
        case updatedAt = "updated_at"
        case isAnonymous = "is_anonymous"
    }
}
