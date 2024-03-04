//
//  View+.swift
//  DavidWeeCodeChallenge
//
//  Created by David Wee on 3/4/24.
//

import Foundation
import SwiftUI

extension View {
    /// Removes the keyboard if active
    func resignFirstResponder() {
        UIApplication.shared.sendAction(#selector(UIResponder.resignFirstResponder), to: nil, from: nil, for: nil)
    }
}
