//
//  Category.swift
//  ZipCart
//
//  Created by Dawit Chernet on 2026-06-06.
//

import Foundation

struct Category: Identifiable, Hashable, Codable {
    let id: UUID
    let name: String
    let iconName: String
}
