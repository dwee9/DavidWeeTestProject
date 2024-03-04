//
//  Strings.swift
//  DavidWeeCodeChallenge
//
//  Created by David Wee on 3/1/24.
//

import Foundation

/// Hardcoded Strings used throughout the app
enum Strings {
    enum APIErrors {
        static let generic = "Something went wrong, please try again."
        static let noInternet = "No Network connection."
    }

    enum Search {
        static let title = "Photo Stream"
        static let placeholder = "Search tags"
        static let searchHelp = "Search for tags separated by `,`.\n Egs. \"Apple, Banana, ...\""
        static func noItems(_ search: String) -> String { "No items found for \(search)" }
    }

    enum Errors {
        static let error = "Error"
    }

}
