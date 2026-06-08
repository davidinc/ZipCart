//
//  File.swift
//  ZipCart
//
//  Created by Dawit Chernet on 2026-06-08.
//

import SwiftUI

struct ProductCartView: View {
    let product: Product
    let onTop: () -> Void
    
    var body: some View {
        Button(action: onTap) {
            HStack(spacing: 16) {
                Image(systemName: product.imageName)
                    .font(.system(size: 36))
                    .frame(width: 60, height: 60)
                
                VStack(alignment: .leading, spacing: 6) {
                    Text(product.name)
                        .font(.headline)
                    
                    Text(product.description)
                        .font(.subheadline)
                        .foregroundStyle(.secondary)
                        .lineLimit(2)
                    Text("$\(product.price, specifier: "%.2f")")
                        .fontWeight(.semibold)
                }
                Spacer()
            }
            .padding(.vertical, 8)
        }
        .buttonStyle(.plain)
    }
}
