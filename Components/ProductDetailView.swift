import SwiftUI

struct ProductDetailView: View {
    let product: Product

    @EnvironmentObject private var cartViewModel: CartViewModel

    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 16) {
                CachedAsyncImage(
                    url: product.imageURL,
                    fallbackSystemImage: product.imageName
                )
                .frame(height: 220)
                .frame(maxWidth: .infinity)

                Text(product.name)
                    .font(.title)
                    .fontWeight(.bold)

                Text("$\(product.price, specifier: "%.2f")")
                    .font(.title2)
                    .foregroundStyle(.green)

                Text(product.description)
                    .foregroundStyle(.secondary)

                if product.isAvailable {
                    Button {
                        cartViewModel.addToCart(product)
                    } label: {
                        Label("Add to Cart", systemImage: "cart.badge.plus")
                            .frame(maxWidth: .infinity)
                    }
                    .buttonStyle(.borderedProminent)
                } else {
                    Text("Out of Stock")
                        .foregroundStyle(.red)
                        .fontWeight(.semibold)
                }
            }
            .padding()
        }
        .navigationTitle("Product")
        .navigationBarTitleDisplayMode(.inline)
    }
}