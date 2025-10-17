//
//  Metadata.swift
//  SupabaseAPI
//
//  Created by Ali Osman Öztürk on 27.09.2025.
//

import Foundation

struct AppMetadata: Decodable, Sendable {
    let provider: String
    let providers: [String]
}

struct UserMetadata: Decodable, Sendable {
    let email: String
    let emailVerified: Bool
    let phoneVerified: Bool
    let sub: String
}
