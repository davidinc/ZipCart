//
//  DiscountEngine.swift
//  ZipCart
//
//  Created by Dawit Chernet on 2026-06-26.
//


import Foundation

// MARK: - DiscountEngine
//
// EPIC 5 NEW:
//
// Learning:
// Discount logic should not be inside the View.
// It also should not be mixed deeply inside CartViewModel.
//
// TODO: - In enterprise eCommerce, discount logic can become very complex:
// - promo codes
// - loyalty discounts
// - seasonal campaigns
// - bulk discounts
// - first-time customer discount

enum DiscountEngine {

    static func calculateDiscount(subtotal: Double, itemCount: Int) -> Double {

        // Rule 1:
        // No discount for empty cart.
        guard subtotal > 0 else {
            return 0
        }

        // Rule 2:
        // Bulk discount:
        // If user buys 5 or more items, apply 10%.
        if itemCount >= 5 {
            return subtotal * 0.10
        }

        return 0
    }
}
