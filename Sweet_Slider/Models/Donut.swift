import SwiftUI

struct Donut: Identifiable {
    let id: Int
    let imageName: String
    let title: String
    let displayName: String
    let price: Double
    let color: Color
}

extension Donut {
    static let all: [Donut] = [
        Donut(id: 0, imageName: "strawberry", title: "STRAWBERRY", displayName: "Strawberry Glaze", price: 89, color: Color(red: 0.88, green: 0.55, blue: 0.60)),
        Donut(id: 1, imageName: "blueberry", title: "BLUEBERRY", displayName: "Blueberry Dream", price: 99, color: Color(red: 0.55, green: 0.48, blue: 0.75)),
        Donut(id: 2, imageName: "chocolate", title: "CHOCOLATE", displayName: "Double Chocolate", price: 119, color: Color(red: 0.45, green: 0.32, blue: 0.25)),
        Donut(id: 3, imageName: "coconut", title: "COCONUT", displayName: "Coconut Bliss", price: 95, color: Color(red: 0.85, green: 0.68, blue: 0.45)),
        Donut(id: 4, imageName: "caramel", title: "CARAMEL", displayName: "Salted Caramel", price: 109, color: Color(red: 0.82, green: 0.65, blue: 0.35)),
        Donut(id: 5, imageName: "green-apple", title: "GREEN APPLE", displayName: "Green Apple Twist", price: 99, color: Color(red: 0.45, green: 0.68, blue: 0.50))
    ]
}
