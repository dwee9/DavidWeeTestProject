//
//  NetworkMock.swift
//  DavidWeeCodeChallengeTests
//
//  Created by David Wee on 3/4/24.
//

import Foundation
@testable import DavidWeeCodeChallenge

final class NetworkMock: Network {

    private lazy var mocks: [String: String] = happyPaths

    func request<T>(endpoint: Endpoint, type: T.Type, completion: @escaping (Result<T, APIError>) -> Void) where T : Decodable {
        guard let response = mocks[endpoint.path] else {
            completion(.failure(.invalidResponse(error: nil, statusCode: -1)))
            return
        }

        completion(loadJSON(response, type: type))
    }

    func mock(endpoint: Endpoint, with responseFile: String) {
        mocks[endpoint.path] = responseFile
    }

    private func loadJSON<T: Decodable>(_ fileName: String, type: T.Type) -> Result<T, APIError> {
        guard let path = Bundle(for: NetworkMock.self).url(forResource: fileName, withExtension: "json") else {
            return .failure(.invalidURL)
        }

        do {
            let data = try Data(contentsOf: path)
            let decoder = JSONDecoder()
            decoder.dateDecodingStrategy = .iso8601
            let object = try decoder.decode(type, from: data)
            return .success(object)
        } catch let error as DecodingError {
            return .failure(.decodingError(error))
        } catch {
            return .failure(.unknown(error))
        }
    }
}

// MARK: - Happy Path
private extension NetworkMock {

    var happyPaths: [String: String] {
        [
            ImageEndpoint.search(tag: "image_list_success").path: "image_list_success"
        ]
    }
}
