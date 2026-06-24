//
//  CheckoutView.swift
//  ZipCart
//
//  Created by Dawit Chernet on 2026-06-08.
//

import SwiftUI

struct CheckoutView: View {
    @EnvironmentObject private var appState: AppState
    @EnvironmentObject private var viewModel: CartViewModel

    @State private var street = ""
    @State private var city = ""
    @State private var province = ""
    @State private var postalCode = ""
    @State private var country = "Canada"

    @State private var selectedPaymentType: PaymentType = .creditCard
    @State private var lastFourDigits = ""
    @State private var holderName = ""
    @State private var errorMessage: String?
    @State private var confirmedOrder: Order?

    var body: some View {
        Form {
            Section("Shipping Address") {
                TextField("Street", text: $street)
                TextField("City", text: $city)
                TextField("Province", text: $province)
                TextField("Postal Code", text: $postalCode)
                TextField("Country", text: $country)
            }

            Section("Payment Method") {
                Picker("Type", selection: $selectedPaymentType) {
                    Text("Credit Card").tag(PaymentType.creditCard)
                    Text("Debit Card").tag(PaymentType.debitCard)
                    Text("Apple Pay").tag(PaymentType.applePay)
                    Text("PayPal").tag(PaymentType.paypal)
                }

                TextField("Last Four Digits", text: $lastFourDigits)
                    .keyboardType(.numberPad)

                TextField("Card Holder Name", text: $holderName)
            }

            Section("Order Summary") {
                HStack {
                    Text("Subtotal")
                    Spacer()
                    Text("$\(viewModel.subtotal, specifier: "%.2f")")
                }

                HStack {
                    Text("Tax")
                    Spacer()
                    Text("$\(viewModel.tax, specifier: "%.2f")")
                }

                HStack {
                    Text("Delivery")
                    Spacer()
                    Text("$\(viewModel.deliveryFee, specifier: "%.2f")")
                }

                HStack {
                    Text("Total")
                        .fontWeight(.bold)
                    Spacer()
                    Text("$\(viewModel.total, specifier: "%.2f")")
                        .fontWeight(.bold)
                }
            }

            if let errorMessage {
                Section {
                    Text(errorMessage)
                        .foregroundStyle(.red)
                }
            }

            Section {
                Button("Place Order") {
                    placeOrder()
                }
            }
        }
        .navigationTitle("Checkout")
        .navigationDestination(item: $confirmedOrder) { order in
            OrderConfirmationView(order: order)
        }
    }

    private func placeOrder() {
        guard let user = appState.currentUser else {
            errorMessage = "Please sign in before placing your order."
            return
        }

        guard !viewModel.items.isEmpty else {
            errorMessage = "Your cart is empty."
            return
        }

        let address = Address(
            fullName: user.fullName,
            street: street,
            city: city,
            province: province,
            postalCode: postalCode,
            country: country
        )

        guard address.isValid else {
            errorMessage = "Please complete the shipping address."
            return
        }

        let digits = lastFourDigits.filter(\.isNumber)
        guard digits.count == 4, !holderName.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty else {
            errorMessage = "Enter the last four digits and card holder name."
            return
        }

        let order = Order(
            id: UUID(),
            userId: user.id,
            items: viewModel.items,
            shippingAddress: address,
            paymentMethod: PaymentMethod(
                id: UUID(),
                type: selectedPaymentType,
                lasFourDigits: digits,
                holderName: holderName
            ),
            orderDate: Date(),
            status: .confirmed
        )

        errorMessage = nil
        confirmedOrder = order
        viewModel.clearCart()
    }
}

private struct OrderConfirmationView: View {
    let order: Order

    var body: some View {
        VStack(spacing: 16) {
            Image(systemName: "checkmark.circle.fill")
                .font(.system(size: 64))
                .foregroundStyle(.green)

            Text("Order Confirmed")
                .font(.title)
                .fontWeight(.bold)

            Text("Order #\(order.id.uuidString.prefix(8))")
                .foregroundStyle(.secondary)

            Text("$\(order.totalAmount, specifier: "%.2f")")
                .font(.title2)
                .fontWeight(.semibold)
        }
        .padding()
        .navigationBarBackButtonHidden()
    }
}
