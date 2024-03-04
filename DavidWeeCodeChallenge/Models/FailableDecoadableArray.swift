//
//  FailableDecoadableArray.swift
//  DavidWeeCodeChallenge
//
//  Created by David Wee on 3/1/24.
//

import Foundation

/// Decodes an Element that is allowed to fail
struct FailableDecodable<Element: Decodable>: Decodable {
    let element: Element?

    init(from decoder: Decoder) throws {
        let container = try decoder.singleValueContainer()
        self.element = try? container.decode(Element.self)
    }
}

/// Decodes a List of Elements where an invalid Decodable is not included in the return List.
/// - note: Instead of a Decoding failure, invalid Elements will be removed from the list.
struct FailableCodableArray<Element: Decodable>: Decodable {

    var elements: [Element]

    init(from decoder: Decoder) throws {
        var container = try decoder.unkeyedContainer()
        var elements = [Element]()

        if let count = container.count {
            elements.reserveCapacity(count)
        }

        while !container.isAtEnd {
            if let element = try container.decode(FailableDecodable<Element>.self).element {
                elements.append(element)
            }
        }
        self.elements = elements
    }
}
