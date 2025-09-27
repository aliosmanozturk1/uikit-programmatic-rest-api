//
//  Metadata.swift
//  SupabaseAPI
//
//  Created by Ali Osman Öztürk on 27.09.2025.
//

import Foundation

struct AppMetadata: Codable {
    let provider: String
    let providers: [String]
}

struct UserMetadata: Codable {
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
