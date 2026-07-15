import SwiftUI

struct EditProductView: View {
    let product: Product

    @EnvironmentObject private var router: AppRouter
    @EnvironmentObject private var appState: AppState

    @ObservedObject private var catalogStore = ProductCatalogStore.shared

    @State private var name: String
    @State private var description: String
    @State private var price: String
    @State private var imageName: String
    @State private var imageURL: String
    @State private var stockQuantity: String
    @State private var rating: String
    @State private var selectedCategory: ProductCategoryType
    @State private var errorMessage: String?

    init(product: Product) {
        self.product = product

        _name = State(initialValue: product.name)
        _description = State(initialValue: product.description)
        _price = State(initialValue: "\(product.price)")
        _imageName = State(initialValue: product.imageName)
        _imageURL = State(initialValue: product.imageURL?.absoluteString ?? "")
        _stockQuantity = State(initialValue: "\(product.stockQuantity)")
        _rating = State(initialValue: "\(product.rating)")

        let matchedCategory = ProductCategoryType.allCases.first {
            $0.displayName == product.category.name
        } ?? .electronics

        _selectedCategory = State(initialValue: matchedCategory)
    }

    var body: some View {
        Form {
            Section("Edit Product") {
                TextField("Name", text: $name)
                TextField("Description", text: $description)
                TextField("Price", text: $price)
                    .keyboardType(.decimalPad)
                TextField("SF Symbol Fallback", text: $imageName)
                TextField("Image URL", text: $imageURL)
                    .keyboardType(.URL)
                    .textInputAutocapitalization(.never)
                TextField("Stock Quantity", text: $stockQuantity)
                    .keyboardType(.numberPad)
                TextField("Rating", text: $rating)
                    .keyboardType(.decimalPad)
            }

            Section("Category") {
                Picker("Category", selection: $selectedCategory) {
                    ForEach(ProductCategoryType.allCases) { category in
                        Text(category.displayName).tag(category)
                    }
                }
            }

            if let errorMessage {
                Section {
                    Text(errorMessage)
                        .foregroundStyle(.red)
                }
            }

            Section {
                Button("Save Changes") {
                    saveChanges()
                }
                .disabled(appState.currentUser?.hasPermission(.productUpdate) != true)
            }
        }
        .navigationTitle("Edit Product")
    }

    private func saveChanges() {
        guard !name.isEmpty,
              !description.isEmpty,
              let priceValue = Double(price),
              let stockValue = Int(stockQuantity),
              let ratingValue = Double(rating) else {
            errorMessage = "Please enter valid product information."
            return
        }

        let updatedProduct = Product(
            id: product.id,
            name: name,
            description: description,
            price: priceValue,
            imageName: imageName,
            imageURL: URL(string: imageURL),
            category: selectedCategory.category,
            stockQuantity: stockValue,
            rating: ratingValue
        )

        catalogStore.updateProduct(updatedProduct)
        router.goBack()
    }
}