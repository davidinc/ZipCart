//
//  Item.swift
//  ZipCart
//
//  Created by Dawit Chernet on 2026-06-06.
//

import Foundation
import SwiftData

@Model
final class Item {
    var timestamp: Date
    
    init(timestamp: Date) {
        self.timestamp = timestamp
    }
}
