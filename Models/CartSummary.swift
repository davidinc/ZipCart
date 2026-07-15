import Foundation

// MARK: - CartSummary
//
// EPIC 5 NEW:
//
// Learning:
// Instead of passing subtotal, discount, tax, and total separately,
// we group them into one model.
//
// This is cleaner for enterprise apps because CartSummary can later be sent
// to checkout, analytics, or backend order APIs.

struct CartSummary: Hashable, Codable {
    let subtotal: Double
    let discount: Double
    let tax: Double
    let deliveryFee: Double
    let total: Double
    let itemCount: Int
}