import Foundation

struct Campaign: Identifiable, Hashable, Codable {
    let id: UUID
    let title: String
    let description: String
    let discountPercentage: Double
    let isActive: Bool
    let startDate: Date
    let endDate: Date
}