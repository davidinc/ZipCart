import Foundation
import Combine

// MARK: - ProductCatalogStore
//
// EPIC 7 NEW:
//
// Learning:
// ProductService gives initial mock products.
// ProductCatalogStore keeps the editable in-memory product catalog.
//
// Later this should be replaced by:
// - SQLite
// - SwiftData
// - Backend API

@MainActor
final class ProductCatalogStore: ObservableObject {

    static let shared = ProductCatalogStore()

    @Published private(set) var products: [Product] = []

    private let productService: ProductServiceProtocol

    private init(productService: ProductServiceProtocol = ProductService()) {
        self.productService = productService
        self.products = productService.getMockProducts()
    }

    func addProduct(_ product: Product) {
        products.append(product)
    }

    func updateProduct(_ product: Product) {
        guard let index = products.firstIndex(where: { $0.id == product.id }) else {
            return
        }

        products[index] = product
    }

    func deleteProduct(_ product: Product) {
        products.removeAll { $0.id == product.id }
    }
}