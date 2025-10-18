//
//  AuthEndpoint.swift
//  SupabaseAPI
//
//  Created by Ali Osman Öztürk on 18.10.2025.
//

import Foundation
import Alamofire

enum AuthEndpoint: APIEndpoint {
    case signIn(email: String, password: String)
    case signUp(email: String, password: String)
    case refreshSession(refreshToken: String)
    case currentUser
    case resendVerification(email: String)
    
    var baseURL: String {
        APIConfig.shared.baseURL
    }
    
    var path: String {
        switch self {
        case .signIn, .refreshSession:
            return "/auth/v1/token"
        case .signUp:
            return "/auth/v1/signup"
        case .currentUser:
            return "/auth/v1/user"
        case .resendVerification:
            return "/auth/v1/otp"
        }
    }
    
    var method: HTTPMethod {
        switch self {
        case .signIn, .signUp, .refreshSession, .resendVerification:
            return .post
        case .currentUser:
            return .get
        }
    }
    
    var headers: HTTPHeaders? {
        var headers: HTTPHeaders = [
            .contentType("application/json"),
            .init(name: "apikey", value: APIConfig.shared.apiKey)
        ]
        

        
        return headers
    }
    
    var parameters: Parameters? {
        switch self {
        case .signIn(let email, let password):
            return [
                "email": email,
                "password": password
            ]
        case .signUp(let email, let password):
            return [
                "email": email,
                "password": password
            ]
        case .refreshSession(let refreshToken):
            return [
                "refresh_token": refreshToken
            ]
        case .resendVerification(let email):
            return [
                "email": email,
                "type": "signup"
            ]
        case .currentUser:
            return nil
        }
    }
    
    var queryParameters: Parameters? {
        switch self {
        case .signIn:
            return ["grant_type": "password"]
        case .refreshSession:
            return ["grant_type": "refresh_token"]
        default:
            return nil
        }
    }
    
    var encoding: ParameterEncoding {
        switch self {
        case .currentUser:
            return URLEncoding.default
        default:
            return JSONEncoding.default
        }
    }
    
    var requiresAuth: Bool {
        switch self {
        case .signIn, .signUp, .refreshSession:
            return false
        default:
            return true
        }
    }
}
