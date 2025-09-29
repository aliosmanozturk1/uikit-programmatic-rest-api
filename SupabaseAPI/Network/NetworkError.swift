//
//  NetworkError.swift
//  SupabaseAPI
//
//  Created by Ali Osman Öztürk on 29.09.2025.
//

import Foundation

enum NetworkError: LocalizedError {
    case invalidURL
    case invalidAPIKey
    case noData
    case decodingError(Error)
    case encodingError(Error)
    case networkError(Error)
    case httpError(statusCode: Int, message: String?)
    case unauthorized
    case serverError
    case unknown(String)

    var errorDescription: String? {
        switch self {
        case .invalidURL:
            return "Geçersiz URL"
        case .invalidAPIKey:
            return "API Key bulunamadı veya geçersiz"
        case .noData:
            return "Sunucudan veri alınamadı"
        case .decodingError(let error):
            return "Veri çözümleme hatası: \(error.localizedDescription)"
        case .encodingError(let error):
            return "Veri kodlama hatası: \(error.localizedDescription)"
        case .networkError(let error):
            return "Ağ hatası: \(error.localizedDescription)"
        case .httpError(let statusCode, let message):
            return message ?? "HTTP Hatası: \(statusCode)"
        case .unauthorized:
            return "Yetkilendirme hatası"
        case .serverError:
            return "Sunucu hatası"
        case .unknown(let message):
            return message
        }
    }
}
