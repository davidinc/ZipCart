//
//  ZipCartApp.swift
//  ZipCart
//
//  Created by Dawit Chernet on 2026-06-06.
//

import SwiftUI
import SwiftData

@main
struct ZipCartApp: App {
    @StateObject private var router = AppRouter()

    var body: some Scene {
        WindowGroup {
            RootView()
                .environmentObject(router)
        }
    }
}
