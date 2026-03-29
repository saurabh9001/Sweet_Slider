import Foundation

@Observable
final class CartStore {
    private(set) var items: [Int: Int] = [:]

    var totalCount: Int {
        items.values.reduce(0, +)
    }

    var totalPrice: Double {
        items.reduce(0.0) { sum, entry in
            let donut = Donut.all[entry.key]
            return sum + donut.price * Double(entry.value)
        }
    }

    func add(donutID: Int, quantity: Int) {
        items[donutID, default: 0] += quantity
    }

    func decrement(donutID: Int) {
        guard let current = items[donutID] else { return }
        if current <= 1 {
            items.removeValue(forKey: donutID)
        } else {
            items[donutID] = current - 1
        }
    }
}
