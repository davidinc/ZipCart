import Foundation

// MARK: - UserPermission
//
// EPIC 7 NEW:
//
// Learning:
// This model represents direct permission assignment to a user.
//
// In this version, we mainly use role permissions.
// Later, UserPermission can support custom extra permissions per user.
//
// Example:
// A customer may temporarily receive campaign:create permission for testing.

struct UserPermission: Identifiable, Hashable, Codable {
    let id: UUID
    let userId: UUID
    let permission: Permission
    let grantedAt: Date

    init(
        id: UUID = UUID(),
        userId: UUID,
        permission: Permission,
        grantedAt: Date = Date()
    ) {
        self.id = id
        self.userId = userId
        self.permission = permission
        self.grantedAt = grantedAt
    }
}