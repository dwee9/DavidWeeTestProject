//
//  SearchImage.swift
//  DavidWeeCodeChallenge
//
//  Created by David Wee on 3/1/24.
//

import Foundation

extension String {
    func ranges(of string: String, options: CompareOptions = .literal) -> [Range<Index>] {
        var result: [Range<Index>] = []
        var start = startIndex
        while let range = range(of: string, options: options, range: start..<endIndex) {
            result.append(range)
            start = range.lowerBound < range.upperBound ? range.upperBound : index(range.lowerBound, offsetBy: 1, limitedBy: endIndex) ?? endIndex
        }
        return result
    }
    
    func slices(from: String, to: String) -> [Substring] {
        let pattern = "(?<=" + from + ").*?(?=" + to + ")"
        return ranges(of: pattern, options: .regularExpression)
            .map{ self[$0] }

    }
}

struct SearchImage: Decodable, Hashable {
    let title: String
    let dateTaken: Date
    let media: Media
    let description: String
    let publishedDate: Date
    let author: String
    let tags: String
    
    var width: CGFloat {
        guard let width = description.slices(from: "width=\"", to: "\"").first,
        let width =  Int(width)else {
            return .zero
        }
        return CGFloat(width)
    }

    var height: CGFloat {
        guard let width = description.slices(from: "height=\"", to: "\"").first,
        let width = Int(width)else {
            return .zero
        }
        return CGFloat(width)
    }

    private enum CodingKeys: String, CodingKey {
        case title
        case dateTaken = "date_taken"
        case media
        case description
        case publishedDate = "published"
        case author
        case tags
    }

    /// Gets the height of the image with a set width
    /// - Parameter width: The width to use to calculate the height
    /// - returns: Height as `CGFloat`
    func getHeight(from width: CGFloat) -> CGFloat {
        let aspectRatio: CGFloat = self.height / self.width
        return width * aspectRatio
    }
}

struct SearchImagesResponse: Decodable {
    let title: String
    let items: [SearchImage]

    enum CodingKeys: CodingKey {
        case title
        case items
    }

    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        self.title = try container.decode(String.self, forKey: .title)
        self.items = try container.decode(FailableCodableArray<SearchImage>.self, forKey: .items).elements
    }
}
