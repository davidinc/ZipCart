import Foundation
import Combine

// MARK: - CheckoutViewModel
//
// EPIC 6 NEW:
//
// Responsibilities:
// - Manage shipping form
// - Manage payment form
// - Validate checkout
// - Enforce checkout state machine
// - Simulate payment transaction
// - Create final Order
// - Handle errors
//
// Learning:
// Checkout should not be only a button.
// Enterprise checkout needs controlled steps and validation.

@MainActor
final class CheckoutViewModel: ObservableObject {

    // MARK: - Shipping Form

    @Published var street: String = ""
    @Published var city: String = ""
    @Published var province: String = ""
    @Published var postalCode: String = ""
    @Published var country: String = "Canada"

    // MARK: - Payment Form

    @Published var selectedPaymentType: PaymentType = .creditCard
    @Published var lastFourDigits: String = ""
    @Published var holderName: String = ""

    // MARK: - Checkout State

    @Published private(set) var state: CheckoutState = .enteringShipping
    @Published var errorMessage: String?
    @Published var transactionId: String?

    private let appState: AppState
    private let cartViewModel: CartViewModel
    private let transactionService: CheckoutTransactionServiceProtocol

    init(
        appState: AppState,
        cartViewModel: CartViewModel,
        transactionService: CheckoutTransactionServiceProtocol = CheckoutTransactionService()
    ) {
        self.appState = appState
        self.cartViewModel = cartViewModel
        self.transactionService = transactionService
    }

    // MARK: - Shipping Validation

    func continueToPayment() {
        guard isShippingValid else {
            fail("Please complete all shipping fields.")
            return
        }

        errorMessage = nil
        state = .enteringPayment
    }

    // MARK: - Payment Validation

    func continueToReview() {
        guard isPaymentValid else {
            fail("Please enter valid payment information.")
            return
        }

        errorMessage = nil
        state = .reviewingOrder
    }

    // MARK: - Place Order

    func placeOrder() async {

        // Potential issue solved:
        // Prevent invalid checkout state transitions.
        guard case .reviewingOrder = state else {
            fail("Invalid checkout state transition.")
            return
        }

        guard let user = appState.currentUser else {
            fail("You must be logged in to place an order.")
            return
        }

        guard !cartViewModel.items.isEmpty else {
            fail("Your cart is empty.")
            return
        }

        let address = Address(
            id: UUID(),
            street: street,
            city: city,
            province: province,
            postalCode: postalCode,
            country: country,
            isDefault: false
        )

        let paymentMethod = PaymentMethod(
            id: UUID(),
            type: selectedPaymentType,
            lastFourDigits: lastFourDigits,
            holderName: holderName
        )

        state = .processingPayment

        do {
            let txId = try await transactionService.processPayment(
                amount: cartViewModel.total,
                paymentMethod: paymentMethod
            )

            transactionId = txId

            let order = Order(
                id: UUID(),
                userId: user.id,
                items: cartViewModel.items,
                shippingAddress: address,
                paymentMethod: paymentMethod,
                orderDate: Date(),
                status: .confirmed
            )

            cartViewModel.clearCart()
            errorMessage = nil
            state = .confirmed(order)

        } catch {
            fail(error.localizedDescription)
        }
    }

    // MARK: - Navigation Between Steps

    func goBackToShipping() {
        errorMessage = nil
        state = .enteringShipping
    }

    func goBackToPayment() {
        errorMessage = nil
        state = .enteringPayment
    }

    // MARK: - Private Validation

    private var isShippingValid: Bool {
        !street.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty &&
        !city.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty &&
        !province.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty &&
        !postalCode.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty &&
        !country.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty
    }

    private var isPaymentValid: Bool {
        !holderName.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty &&
        lastFourDigits.count == 4 &&
        lastFourDigits.allSatisfy { $0.isNumber }
    }

    private func fail(_ message: String) {
        errorMessage = message
        state = .failed(message)
    }
}