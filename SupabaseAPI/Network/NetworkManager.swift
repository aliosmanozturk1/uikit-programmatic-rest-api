//
//  NetworkManagerProtocol.swift
//  SupabaseAPI
//
//  Created by Ali Osman Öztürk on 28.09.2025.
//

import Foundation
import Alamofire

protocol NetworkManagerProtocol {
    func request<T: Decodable>(_ endpoint: APIEndpoint) async throws -> T
    func request(_ endpoint: APIEndpoint) async throws -> Data
}

final class NetworkManager: NetworkManagerProtocol {
    static let shared = NetworkManager()
    
    private let session: Session
    private let decoder: JSONDecoder
    
    private init() {
        // Custom configuration
        let configuration = URLSessionConfiguration.af.default
        configuration.timeoutIntervalForRequest = 30
        configuration.timeoutIntervalForResource = 30

        self.session = Session(
            configuration: configuration
        )
        
        // Configure decoder
        self.decoder = JSONDecoder()
        self.decoder.keyDecodingStrategy = .convertFromSnakeCase
        self.decoder.dateDecodingStrategy = .iso8601
    }
    
    // MARK: - Base Request (Returns Raw Data)
    func request(_ endpoint: APIEndpoint) async throws -> Data {
        do {
            return try await session
                .request(endpoint)
                .validate()
                .serializingData()
                .value
        } catch let afError as AFError {
            throw AppError.network(afError)
        } catch {
            throw AppError.unknown(error)
        }
    }
    
    // MARK: - Generic Request (Decodes Data)
    func request<T: Decodable>(_ endpoint: APIEndpoint) async throws -> T {
        do {
            return try await session
                .request(endpoint)
                .validate()
                .serializingDecodable(T.self, decoder: decoder)
                .value
        } catch let afError as AFError {
            throw AppError.network(afError)
        } catch {
            throw AppError.unknown(error)
        }
    }
}

