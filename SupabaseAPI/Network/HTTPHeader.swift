//
//  HTTPHeader.swift
//  SupabaseAPI
//
//  Created by Ali Osman Öztürk on 30.09.2025.
//

enum HTTPHeaderKey: String {
    case contentType   = "Content-Type"
    case authorization = "Authorization"
    case apiKey        = "apikey"
}

enum HTTPHeaderValue {
    static let applicationJSON = "application/json"
    
    static func bearer(_ token: String) -> String {
        "Bearer \(token)"
    }
}
