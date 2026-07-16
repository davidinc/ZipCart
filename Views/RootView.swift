//
//  RootView.swift
//  ZipCart
//
//  Created by Dawit Chernet on 2026-06-08.
//

import SwiftUI

struct RootView: View {

    @EnvironmentObject private var router: AppRouter
    @EnvironmentObject private var appState: AppState

    var body: some View {
        NavigationStack(path: $router.path) {
            Group {
                if appState.isAuthenticated {
                    HomeView()
                        .navigationBarBackButtonHidden(true)
                } else {
                    LoginView()
                        .navigationBarBackButtonHidden(true)
                }
            }
            .navigationDestination(for: AppRoute.self) { route in
                destination(for: route)
            }
            .onChange(of: appState.isAuthenticated) {
                router.reset()
            }
        }
    }

    @ViewBuilder
    private func destination(for route: AppRoute) -> some View {
        // RootView is the single navigation map for the app. AppRouter pushes
        // AppRoute values, and this method decides which screen each route opens.
        switch route {
        case .splash, .login:
            LoginView()

        case .register:
            RegisterView()

        case .home:
            HomeView()

        case .productDetail(let product):
            ProductDetailView(product: product)

        case .cart:
            CartView()

        case .checkout:
            CheckoutView()

        case .profile:
            ProfileView()

        case .orderHistory:
            OrderHistoryView()

        case .deliveryTracking(let order):
            DeliveryTrackingView(order: order)

        case .adminDashboard:
            AdminDashboardView()

        case .productManagement:
            ProductManagementView()

        case .createProduct:
            CreateProductView()

        case .editProduct(let product):
            EditProductView(product: product)

        case .campaignManagement:
            CampaignManagementView()

        case .createCampaign:
            CreateCampaignView()
        }
    }
}
