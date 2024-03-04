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
}
