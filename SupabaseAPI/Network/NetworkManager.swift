//
//  NetworkManagerProtocol.swift
//  SupabaseAPI
//
//  Created by Ali Osman Öztürk on 28.09.2025.
//

import Foundation

protocol NetworkManagerProtocol {
    func request<T: Decodable & Sendable>(
        endpoint: String,
        method: String,
        headers: [String: String],
        body: [String: Any]?,
        responseType: T.Type
    ) async throws -> T
    
    func request(
        endpoint: String,
        method: String,
        body: [String: Any]?,
        headers: [String: String]?
    ) async throws -> Data
}

final class NetworkManager: NetworkManagerProtocol {
    func request<T: Decodable & Sendable>(
        endpoint: String,
        method: String,
        headers: [String: String],
        body: [String: Any]?,
        responseType: T.Type
    ) async throws -> T {
        let data = try await request(endpoint: endpoint, method: method, body: body, headers: headers)
        
        do {
            return try JSONDecoder().decode(responseType.self, from: data)
        } catch {
            throw NetworkError.decodingError(error)
        }
    }
    
    func request(
        endpoint: String,
        method: String,
        body: [String: Any]?,
        headers: [String: String]?
    ) async throws -> Data {
        // Create URL
        guard let url = URL(string: endpoint) else {
            fatalError("Invalid URL")
        }
        
        // Create Request
        var request = URLRequest(url: url)
        request.httpMethod = method
        
        // Add custom headers
        headers?.forEach { key, value in
            request.setValue(value, forHTTPHeaderField: key)
        }
        
        // Add body if provided
        if let body = body {
            do {
                request.httpBody = try JSONSerialization.data(withJSONObject: body)
            } catch {
                throw NetworkError.encodingError(error)
            }
        }
        
        // Perform request
        do {
            let (data, response) = try await URLSession.shared.data(for: request)
            
            guard let httpResponse = response as? HTTPURLResponse else {
                throw NetworkError.unknown("Invalid Response Type")
            }
            
            switch httpResponse.statusCode {
            case 200...299:
                return data
            case 401:
                throw NetworkError.unauthorized
            case 400...499:
                let errorMessage = parseErrorMessage(from: data)
                throw NetworkError.httpError(statusCode: httpResponse.statusCode, message: errorMessage)
            case 500...599:
                throw NetworkError.serverError
            default:
                throw NetworkError.httpError(statusCode: httpResponse.statusCode, message: nil)
            }
    
        } catch let error as NetworkError {
            throw error
        } catch {
            throw NetworkError.networkError(error)
        }
    }
    
    private func parseErrorMessage(from data: Data) -> String? {
        guard let json = try? JSONSerialization.jsonObject(with: data, options: []) as? [String: Any] else {
            return nil
        }
        
        // Try common error message keys
        if let message = json["msg"] as? String {
            return message
        }
        
        if let message = json["error_description"] as? String {
            return message
        }
        
        if let message = json["message"] as? String {
            return message
        }
        
        if let error = json["error"] as? String {
            return error
        }
        
        return nil
    }
}
    
