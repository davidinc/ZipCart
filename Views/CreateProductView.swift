//
//  CreateProductView.swift
//  ZipCart
//
//  Created by Dawit Chernet on 2026-07-03.
//

import PhotosUI
import SwiftUI

struct CreateProductView: View {

    @EnvironmentObject private var router: AppRouter
    @EnvironmentObject private var appState: AppState

    @ObservedObject private var catalogStore = ProductCatalogStore.shared

    @State private var name = ""
    @State private var description = ""
    @State private var price = ""
    @State private var imageName = "shippingbox"
    @State private var imageURL = ""
    @State private var stockQuantity = ""
    @State private var rating = "4.5"
    @State private var selectedCategory: ProductCategoryType = .electronics
    @State private var errorMessage: String?

    @State private var selectedPhotoItem: PhotosPickerItem?
    @State private var selectedImageData: Data?

    var body: some View {
        Form {
            Section("Product Information") {
                TextField("Name", text: $name)
                TextField("Description", text: $description)

                TextField("Price", text: $price)
                    .keyboardType(.decimalPad)

                TextField("SF Symbol Fallback", text: $imageName)

                TextField("Optional Image URL", text: $imageURL)
                    .keyboardType(.URL)
                    .textInputAutocapitalization(.never)
                    .autocorrectionDisabled()

                TextField("Stock Quantity", text: $stockQuantity)
                    .keyboardType(.numberPad)

                TextField("Rating", text: $rating)
                    .keyboardType(.decimalPad)
            }

            Section("Product Image") {
                PhotosPicker(
                    selection: $selectedPhotoItem,
                    matching: .images
                ) {
                    Label("Select Product Image", systemImage: "photo")
                }

                ProductImageView(
                    product: previewProduct,
                    width: 120,
                    height: 120
                )
            }

            Section("Category") {
                Picker("Category", selection: $selectedCategory) {
                    ForEach(ProductCategoryType.allCases) { category in
                        Text(category.displayName)
                            .tag(category)
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
                Button("Create Product") {
                    createProduct()
                }
                .disabled(appState.currentUser?.hasPermission(.productCreate) != true)
            }
        }
        .navigationTitle("Create Product")
        .onChange(of: selectedPhotoItem) { _, newItem in
            Task {
                selectedImageData = try? await newItem?.loadTransferable(type: Data.self)
            }
        }
    }

    private var previewProduct: Product {
        Product(
            id: UUID(),
            name: name.isEmpty ? "New Product" : name,
            description: description.isEmpty ? "Product description" : description,
            price: Double(price) ?? 0,
            imageName: imageName.isEmpty ? "shippingbox" : imageName,
            imageURL: URL(string: imageURL),
            localImageData: selectedImageData,
            category: selectedCategory.category,
            stockQuantity: Int(stockQuantity) ?? 0,
            rating: Double(rating) ?? 0
        )
    }

    private func createProduct() {
        guard appState.currentUser?.hasPermission(.productCreate) == true else {
            errorMessage = "You do not have permission to create products."
            return
        }

        guard !name.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty,
              !description.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty,
              let priceValue = Double(price),
              let stockValue = Int(stockQuantity),
              let ratingValue = Double(rating) else {
            errorMessage = "Please enter valid product information."
            return
        }

        let product = Product(
            id: UUID(),
            name: name,
            description: description,
            price: priceValue,
            imageName: imageName.isEmpty ? "shippingbox" : imageName,
            imageURL: URL(string: imageURL),
            localImageData: selectedImageData,
            category: selectedCategory.category,
            stockQuantity: stockValue,
            rating: ratingValue
        )

        catalogStore.addProduct(product)
        router.goBack()
    }
}

#Preview {
    CreateProductView()
        .environmentObject(AppRouter())
        .environmentObject(AppState())
}
