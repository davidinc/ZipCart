import SwiftUI

struct CartView: View {
    @EnvironmentObject private var router: AppRouter
    @EnvironmentObject private var viewModel: CartViewModel

    var body: some View {
        Group {
            if viewModel.isEmpty {
                emptyCartView
            } else {
                cartContent
            }
        }
        .navigationTitle("Cart")
        .toolbar {
            if !viewModel.isEmpty {
                Button("Clear") {
                    viewModel.clearCart()
                }
            }
        }
    }

    private var emptyCartView: some View {
        VStack(spacing: 16) {
            Image(systemName: "cart")
                .font(.system(size: 56))
                .foregroundStyle(.secondary)

            Text("Your cart is empty")
                .font(.title2)
                .fontWeight(.semibold)

            Button {
                router.navigate(to: .home)
            } label: {
                Label("Continue Shopping", systemImage: "bag")
            }
            .buttonStyle(.borderedProminent)
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .padding()
    }

    private var cartContent: some View {
        List {
            Section {
                ForEach(viewModel.items) { item in
                    cartItemRow(item)
                }
                .onDelete(perform: deleteItems)
            }

            Section("Order Summary") {
                summaryRow(title: "Subtotal", amount: viewModel.subtotal)

                if viewModel.discount > 0 {
                    summaryRow(title: "Discount", amount: -viewModel.discount)
                        .foregroundStyle(.green)
                }

                summaryRow(title: "Tax", amount: viewModel.tax)
                summaryRow(title: "Delivery", amount: viewModel.deliveryFee)

                HStack {
                    Text("Total")
                        .fontWeight(.bold)
                    Spacer()
                    Text(formattedPrice(viewModel.total))
                        .fontWeight(.bold)
                }
            }

            Section {
                Button {
                    router.navigate(to: .checkout)
                } label: {
                    Label("Checkout", systemImage: "creditcard")
                        .frame(maxWidth: .infinity)
                }
                .buttonStyle(.borderedProminent)
            }
        }
    }

    private func cartItemRow(_ item: CartItem) -> some View {
        HStack(spacing: 12) {
            CachedAsyncImage(
                url: item.product.imageURL,
                fallbackSystemImage: item.product.imageName
            )
            .frame(width: 56, height: 56)

            VStack(alignment: .leading, spacing: 6) {
                Text(item.product.name)
                    .font(.headline)

                Text(formattedPrice(item.product.price))
                    .foregroundStyle(.secondary)

                Stepper("Qty: \(item.quantity)") {
                    viewModel.increaseQuantity(for: item)
                } onDecrement: {
                    viewModel.decreaseQuantity(for: item)
                }
            }

            Spacer()

            Text(formattedPrice(item.totalPrice))
                .fontWeight(.semibold)
        }
        .padding(.vertical, 4)
    }

    private func summaryRow(title: String, amount: Double) -> some View {
        HStack {
            Text(title)
            Spacer()
            Text(formattedPrice(amount))
        }
    }

    private func deleteItems(at offsets: IndexSet) {
        for index in offsets {
            viewModel.removeItem(viewModel.items[index])
        }
    }

    private func formattedPrice(_ amount: Double) -> String {
        amount.formatted(.currency(code: Locale.current.currency?.identifier ?? "USD"))
    }
}

#Preview {
    let appState = AppState()

    NavigationStack {
        CartView()
    }
    .environmentObject(AppRouter())
    .environmentObject(CartViewModel(appState: appState))
}
