//
//  APIEndpoint.swift
//  SupabaseAPI
//
//  Created by Ali Osman Öztürk on 18.10.2025.
//

import Alamofire
import Foundation

protocol APIEndpoint: URLRequestConvertible {
    var baseURL: String { get }
    var path: String { get }
    var method: HTTPMethod { get }
    var headers: HTTPHeaders? { get }
    var parameters: Parameters? { get }
    var queryParameters: Parameters? { get }
    var encoding: ParameterEncoding { get }
}

extension APIEndpoint {
    var queryParameters: Parameters? { nil }
    
    func asURLRequest() throws -> URLRequest {
        var urlComponents = URLComponents(string: baseURL + path)!
        
        if let queryParams = queryParameters {
            urlComponents.queryItems = queryParams.map {
                URLQueryItem(name: $0.key, value: "\($0.value)")
            }
        }
        
        guard let url = urlComponents.url else {
            throw AFError.invalidURL(url: baseURL + path)
        }
        
        var request = URLRequest(url: url)
        request.method = method
        
        if let headers = headers {
            request.headers = headers
        }
        
        return try encoding.encode(request, with: parameters)
    }
}
