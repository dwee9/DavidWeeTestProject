//
//  DavidWeeCodeChallengeApp.swift
//  DavidWeeCodeChallenge
//
//  Created by David Wee on 3/1/24.
//

import SwiftUI

@main
struct DavidWeeCodeChallengeApp: App {
    var body: some Scene {
        WindowGroup {
            SearchImageView(viewModel: SearchImageViewModel())
        }
    }
}
