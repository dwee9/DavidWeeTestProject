//
//  Endpoint.swift
//  DavidWeeCodeChallenge
//
//  Created by David Wee on 3/1/24.
//

import Foundation

enum APIError: Error {
    case invalidURL
    case invalidEncoding
    case decodingError(DecodingError)
    case invalidResponse(error:Error?, statusCode: Int)
    case unknown(Error)

    var displayError: String {
        switch self {
        default: return Strings.APIErrors.generic
        }
    }
}

enum RequestMethod: String {
    case get = "GET"
}

protocol Endpoint {
    var scheme: String { get }
    var host: String { get }
    var path: String { get }
    var parameters: [URLQueryItem]? { get }
    var method: RequestMethod { get }
    var body: Encodable? { get }
}


extension Endpoint {

    var scheme: String { "https" }

    var host: String { "api.flickr.com" }

    var parameters: [URLQueryItem]? { nil }

    var body: Encodable? { nil }

    func request() throws -> URLRequest {
        var components = URLComponents()
        components.scheme = scheme
        components.host = host
        components.path = path
        components.queryItems = parameters

        guard let url = components.url else {
            throw APIError.invalidURL
        }

        var request = URLRequest(url: url)
        request.httpMethod = method.rawValue
        request.addValue("application/json", forHTTPHeaderField: "Accept")
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")

        if let body {
            do {
                let encoder = JSONEncoder()
                let data = try encoder.encode(body)
                request.httpBody = data
            } catch {
                throw APIError.invalidEncoding
            }
        }
        return request
    }
}

