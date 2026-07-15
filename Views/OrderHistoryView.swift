//
//  OrderHistoryView.swift
//  ZipCart
//
//  Created by Dawit Chernet on 2026-07-03.
//

import SwiftUI

struct OrderHistoryView: View {
    var body: some View {
        VStack(spacing: 16) {
            Image(systemName: "shippingbox")
                .font(.system(size: 56))
                .foregroundStyle(.secondary)

            Text("Order History")
                .font(.title)
                .fontWeight(.bold)

            Text("Your completed orders will appear here.")
                .foregroundStyle(.secondary)
                .multilineTextAlignment(.center)
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .padding()
        .navigationTitle("Order History")
    }
}
