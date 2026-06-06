//
//  AppRoute.swift
//  ZipCart
//
//  Created by Dawit Chernet on 2026-06-06.
//

import Foundation

enum AppRoute: Hashable {
    case splash
    case home
    case productDetail(Product)
    case cart
    case checkout
    case profile
}
