import SwiftUI

enum Springs {
    static let slow = Animation.spring(response: 1.1, dampingFraction: 0.82)
    static let medium = Animation.spring(response: 0.85, dampingFraction: 0.80)
    static let gentle = Animation.spring(response: 1.4, dampingFraction: 0.88)
    static let quick = Animation.spring(response: 0.65, dampingFraction: 0.78)
    static let swipe = Animation.interactiveSpring(response: 0.80, dampingFraction: 0.88)
    static let rotate = Animation.easeInOut(duration: 1.6)
}

enum Timings {
    static let swipeSettle: Double = 0.90
    static let selectionBounceBackDelay: Double = 0.36
    static let pricePop: Double = 0.52
    static let bannerShowDuration: Double = 3.0
    static let bannerHideDuration: Double = 1.0
}
