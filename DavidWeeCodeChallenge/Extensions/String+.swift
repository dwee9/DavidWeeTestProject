//
//  String+.swift
//  DavidWeeCodeChallenge
//
//  Created by David Wee on 3/4/24.
//

import Foundation

extension String {

    /// Remove all HTML elemetns from a HTML String
    /// - returns: String
    var convertFromHTML: String {
        let str = self.replacingOccurrences(of: "<[^>]+>", with: "", options: .regularExpression)
        guard let data = str.data(using: .utf8) else { return "" }

        let options: [NSAttributedString.DocumentReadingOptionKey: Any] = [
            .documentType: NSAttributedString.DocumentType.html,
            .characterEncoding: String.Encoding.utf8.rawValue
        ]

        guard let attribString = try? NSAttributedString(data: data, options: options, documentAttributes: nil) else { return "" }
        return attribString.string
    }
    
    private func ranges(of string: String, options: CompareOptions = .literal) -> [Range<Index>] {
        var result: [Range<Index>] = []
        var start = startIndex
        while let range = range(of: string, options: options, range: start..<endIndex) {
            result.append(range)
            start = range.lowerBound < range.upperBound ? range.upperBound : index(range.lowerBound, offsetBy: 1, limitedBy: endIndex) ?? endIndex
        }
        return result
    }

    /// Separates a string based on a start and an end
    /// - Parameters:
    ///  - from: The start string
    ///  - to: The end string
    ///  - returns: Array of substrings matching the given start and end
    func slices(from: String, to: String) -> [Substring] {
        let pattern = "(?<=" + from + ").*?(?=" + to + ")"
        return ranges(of: pattern, options: .regularExpression)
            .map{ self[$0] }

    }
}
