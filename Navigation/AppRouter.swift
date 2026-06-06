//
//  AppRouter.swift
//  ZipCart
//
//  Created by Dawit Chernet on 2026-06-06.
//

import SwiftUI

final class AppRouter: ObservableObject {
    @Published var path = NavigationPath()
    
    func navigate(to route: AppRoute) {
        path.append(route)
    }
    
    func goBack() {
        if !path.isEmpty {
            path.removeLast()
        }
    }
    
    func reset() {
        path.removeLast(path.count)
    }

}


