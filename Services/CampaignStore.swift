import Foundation
import Combine

@MainActor
final class CampaignStore: ObservableObject {

    static let shared = CampaignStore()

    @Published private(set) var campaigns: [Campaign] = []

    private init() {}

    func addCampaign(_ campaign: Campaign) {
        campaigns.append(campaign)
    }

    func deleteCampaign(_ campaign: Campaign) {
        campaigns.removeAll { $0.id == campaign.id }
    }
}