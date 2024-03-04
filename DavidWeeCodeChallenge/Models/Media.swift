//
//  Media.swift
//  DavidWeeCodeChallenge
//
//  Created by David Wee on 3/1/24.
//

import Foundation

struct Media: Decodable, Hashable {
    let url: URL

    enum CodingKeys: String, CodingKey {
        case url = "m"
    }
}
