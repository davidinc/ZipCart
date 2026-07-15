import SwiftUI

struct CampaignManagementView: View {
    @EnvironmentObject private var appState: AppState
    @EnvironmentObject private var router: AppRouter

    @ObservedObject private var campaignStore = CampaignStore.shared

    var body: some View {
        List {
            Section("Actions") {
                if can(.campaignCreate) {
                    Button {
                        router.navigate(to: .createCampaign)
                    } label: {
                        Label("Create Campaign", systemImage: "megaphone")
                    }
                }
            }

            Section("Campaigns") {
                if campaignStore.campaigns.isEmpty {
                    Text("No campaigns yet.")
                        .foregroundStyle(.secondary)
                }

                ForEach(campaignStore.campaigns) { campaign in
                    VStack(alignment: .leading, spacing: 6) {
                        Text(campaign.title)
                            .font(.headline)

                        Text(campaign.description)
                            .foregroundStyle(.secondary)

                        Text("\(campaign.discountPercentage, specifier: "%.0f")% Discount")
                            .fontWeight(.semibold)

                        Text(campaign.isActive ? "Active" : "Inactive")
                            .font(.caption)
                            .foregroundStyle(campaign.isActive ? .green : .red)
                    }
                }
                .onDelete { indexSet in
                    guard can(.campaignDelete) else { return }

                    for index in indexSet {
                        campaignStore.deleteCampaign(campaignStore.campaigns[index])
                    }
                }
            }
        }
        .navigationTitle("Campaigns")
    }

    private func can(_ permission: PermissionCode) -> Bool {
        appState.currentUser?.hasPermission(permission) == true
    }
}