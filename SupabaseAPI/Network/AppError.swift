//
//  AppError.swift
//  SupabaseAPI
//
//  Created by Ali Osman Öztürk on 18.10.2025.
//

import Foundation
import Alamofire

enum AppError: LocalizedError {
    case network(AFError)
    
    case invalidAPIKey
    case invalidCredentials
    case sessionExpired
    
    case unknown(Error?)
    
    var errorDescription: String? {
        switch self {
        case .network(let afError):
            return handleNetworkError(afError)
            
        case .invalidAPIKey:
            return "API anahtarı bulunamadı veya geçersiz"
            
        case .invalidCredentials:
            return "Email veya şifre hatalı"
            
        case .sessionExpired:
            return "Oturumunuzun süresi doldu. Lütfen tekrar giriş yapın."
            
        case .unknown(let error):
            return "Beklenmedik bir hata oluştu: \(error?.localizedDescription ?? "")"
        }
    }
    
    // MARK: - Helper Methods
    
    private func handleNetworkError(_ afError: AFError) -> String {
        // URL Errors (Internet, Timeout, etc.)
        if let urlError = afError.underlyingError as? URLError {
            switch urlError.code {
            case .notConnectedToInternet, .networkConnectionLost:
                return "İnternet bağlantısı yok. Lütfen bağlantınızı kontrol edin."
            case .timedOut:
                return "İstek zaman aşımına uğradı. Lütfen tekrar deneyin."
            case .cannotFindHost, .cannotConnectToHost:
                return "Sunucuya bağlanılamadı. Lütfen daha sonra tekrar deneyin."
            default:
                return "Bağlantı hatası: \(urlError.localizedDescription)"
            }
        }
        
        // HTTP Status Codes
        if let statusCode = afError.responseCode {
            switch statusCode {
            case 400:
                return "Geçersiz istek. Lütfen bilgilerinizi kontrol edin."
            case 401:
                return "Yetkilendirme hatası. Lütfen tekrar giriş yapın."
            case 403:
                return "Bu işlem için yetkiniz yok."
            case 404:
                return "İstenen kaynak bulunamadı."
            case 500...599:
                return "Sunucu hatası (\(statusCode)). Lütfen daha sonra tekrar deneyin."
            default:
                return "Bir hata oluştu (HTTP \(statusCode))"
            }
        }
        
        // Response Serialization Errors
        if afError.isResponseSerializationError {
            return "Sunucudan gelen veri işlenemedi."
        }
        
        // Invalid URL
        if afError.isInvalidURLError {
            return "Geçersiz URL adresi."
        }
        
        // Default
        return afError.localizedDescription
    }
    
    // MARK: - Convenience Properties
    
    var isUnauthorized: Bool {
        if case .network(let afError) = self {
            return afError.responseCode == 401
        }
        return false
    }
    
    var isNoInternet: Bool {
        if case .network(let afError) = self,
           let urlError = afError.underlyingError as? URLError {
            return urlError.code == .notConnectedToInternet || 
                   urlError.code == .networkConnectionLost
        }
        return false
    }
    
    var isServerError: Bool {
        if case .network(let afError) = self,
           let statusCode = afError.responseCode {
            return (500...599).contains(statusCode)
        }
        return false
    }
}
