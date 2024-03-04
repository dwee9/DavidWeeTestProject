//
//  ImageEndpoint.swift
//  DavidWeeCodeChallenge
//
//  Created by David Wee on 3/1/24.
//

import Foundation
enum ImageEndpoint: Endpoint {

    case search(tag: String)

    var path: String {
        switch self {
        case .search:
            return "/services/feeds/photos_public.gne"
        }
    }

    var method: RequestMethod { .get }

    var parameters: [URLQueryItem]? {
        switch self {
        case .search(let tags):
            return [
                URLQueryItem(name: "format", value: "json"),
                URLQueryItem(name: "nojsoncallback", value: "1"),
                URLQueryItem(name: "tags", value: tags)
            ]
        }
    }
}
