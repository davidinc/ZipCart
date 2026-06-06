//
//  Product.swift
//  ZipCart
//
//  Created by Dawit Chernet on 2026-06-06.
//

import Foundation

struct Product: Identifiable, Hashable, Codable {
    let id: UUID
    let name: String
    let description: String
    let price: Double
    let imageName: String
    let category: Category
    let stockQuantity: Int
    let rating: Double
    
    var isAvailable: Bool {
        stockQuantity > 0
    }
}
