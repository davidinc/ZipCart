import SwiftUI

struct CreateCampaignView: View {
    @EnvironmentObject private var router: AppRouter
    @EnvironmentObject private var appState: AppState

    @ObservedObject private var campaignStore = CampaignStore.shared

    @State private var title = ""
    @State private var description = ""
    @State private var discountPercentage = ""
    @State private var isActive = true
    @State private var errorMessage: String?

    var body: some View {
        Form {
            Section("Campaign Details") {
                TextField("Title", text: $title)
                TextField("Description", text: $description)

                TextField("Discount Percentage", text: $discountPercentage)
                    .keyboardType(.decimalPad)

                Toggle("Active", isOn: $isActive)
            }

            if let errorMessage {
                Section {
                    Text(errorMessage)
                        .foregroundStyle(.red)
                }
            }

            Section {
                Button("Create Campaign") {
                    createCampaign()
                }
                .disabled(appState.currentUser?.hasPermission(.campaignCreate) != true)
            }
        }
        .navigationTitle("Create Campaign")
    }

    private func createCampaign() {
        guard !title.isEmpty,
              !description.isEmpty,
              let discountValue = Double(discountPercentage) else {
            errorMessage = "Please enter valid campaign information."
            return
        }

        let campaign = Campaign(
            id: UUID(),
            title: title,
            description: description,
            discountPercentage: discountValue,
            isActive: isActive,
            startDate: Date(),
            endDate: Calendar.current.date(byAdding: .day, value: 30, to: Date()) ?? Date()
        )

        campaignStore.addCampaign(campaign)
        router.goBack()
    }
}