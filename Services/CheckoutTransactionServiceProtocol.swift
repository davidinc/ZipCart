import Foundation

// MARK: - CheckoutTransactionService
//
// EPIC 6 NEW:
//
// Learning:
// This simulates payment processing.
//
// In real enterprise apps, this layer would integrate with:
// - Stripe
// - Apple Pay
// - PayPal
// - Adyen
// - Moneris
// - backend payment API

protocol CheckoutTransactionServiceProtocol {
    func processPayment(
        amount: Double,
        paymentMethod: PaymentMethod
    ) async throws -> String
}

// MARK: - CheckoutTransactionError

enum CheckoutTransactionError: LocalizedError {
    case invalidAmount
    case paymentDeclined
    case networkFailure

    var errorDescription: String? {
        switch self {
        case .invalidAmount:
            return "Invalid payment amount."
        case .paymentDeclined:
            return "Payment was declined."
        case .networkFailure:
            return "Network error while processing payment."
        }
    }
}

// MARK: - CheckoutTransactionService

final class CheckoutTransactionService: CheckoutTransactionServiceProtocol {

    func processPayment(
        amount: Double,
        paymentMethod: PaymentMethod
    ) async throws -> String {

        guard amount > 0 else {
            throw CheckoutTransactionError.invalidAmount
        }

        // Simulated delay like a real payment API call.
        try await Task.sleep(nanoseconds: 800_000_000)

        // Simulated failure rule:
        // Card ending 0000 means payment declined.
        if paymentMethod.lastFourDigits == "0000" {
            throw CheckoutTransactionError.paymentDeclined
        }

        // Return fake transaction ID.
        return UUID().uuidString
    }
}