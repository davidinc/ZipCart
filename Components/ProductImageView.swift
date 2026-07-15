import SwiftUI

// MARK: - ProductImageView
//
// RELEASE FIX:
// This component must be used everywhere a product image is displayed.
//
// Why?
// Before, HomeView used CachedAsyncImage,
// but CartView / Add-to-Cart / Checkout sometimes used Image(systemName:)
// or only displayed text.
//
// This caused images to disappear after product selection.
//
// This component keeps the same image behavior everywhere:
// 1. Try remote imageURL
// 2. Use image cache
// 3. Fall back to imageName SF Symbol

struct ProductImageView: View {
    
    let product: Product
    let width: CGFloat
    let height: CGFloat
    
    var body: some View {
        CachedAsyncImage(
            url: product.imageURL,
            fallbackSystemImage: product.imageName
        )
        .frame(width: width, height: height)
        .background(Color(.secondarySystemBackground))
        .clipShape(RoundedRectangle(cornerRadius: 12))
    }
}