//
//  ViewModifiers.swift
//  DavidWeeCodeChallenge
//
//  Created by David Wee on 3/1/24.
//

import Foundation
import SDWebImageSwiftUI
import SwiftUI

extension View {
    /// Modifies a `View` to show a loading indicator if condition is met
    @ViewBuilder func loading(_ conditional: Bool) -> some View {
        if conditional {
            ActivityIndicator(.constant(true), style: .large)
        } else {
            self
        }
    }
}
