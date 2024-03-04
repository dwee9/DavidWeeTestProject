//
//  Network.swift
//  DavidWeeCodeChallenge
//
//  Created by David Wee on 3/1/24.
//

import Foundation
import Combine

protocol Network {
    func request<T: Decodable>(endpoint: Endpoint, type: T.Type, completion: @escaping (Result<T, APIError>) -> Void)
}

final class DefaultNetwork: Network {

    var session: URLSession {
        let config: URLSessionConfiguration = .ephemeral
        config.waitsForConnectivity = true
        config.timeoutIntervalForRequest = 60
        return URLSession(configuration: config)
    }

    func request<T: Decodable>(endpoint: Endpoint, type: T.Type, completion: @escaping (Result<T, APIError>) -> Void) {
        do {
            let task = session.dataTask(with: try endpoint.request()) { data, response, error in

                guard let response = response as? HTTPURLResponse, let data else {
                    completion(.failure(.invalidResponse(error: error, statusCode: -1)))
                    return
                }

                switch response.statusCode {
                case 200...299:
                    do {
                        let decoder = JSONDecoder()
                        decoder.dateDecodingStrategy = .iso8601
                        let model = try decoder.decode(T.self, from: data)
                        completion(.success(model))
                    } catch let error as DecodingError {
                        completion(.failure(.decodingError(error)))
                    } catch {
                        completion(.failure(.unknown(error)))
                    }
                default:
                    completion(.failure(.invalidResponse(error: error, statusCode: response.statusCode)))
                }
            }

            task.resume()

        } catch let error as APIError {
            completion(.failure(error))
        } catch {
            completion(.failure(.unknown(error)))
        }
    }
}
