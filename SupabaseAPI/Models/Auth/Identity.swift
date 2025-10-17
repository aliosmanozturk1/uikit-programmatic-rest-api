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
}

struct IdentityData: Decodable, Sendable {
    let email: String
    let emailVerified: Bool
    let phoneVerified: Bool
    let sub: String
}
