import Foundation

// MARK: - UserRoleType
//
// EPIC 7 NEW:
//
// Learning:
// Role is the user's business identity.
// Permission is what the role can do.

enum UserRoleType: String, Codable, CaseIterable, Identifiable {
    case customer
    case admin
    case productManager
    case campaignManager
    case supportAgent

    var id: String {
        rawValue
    }

    var title: String {
        switch self {
        case .customer:
            return "Customer"
        case .admin:
            return "Admin"
        case .productManager:
            return "Product Manager"
        case .campaignManager:
            return "Campaign Manager"
        case .supportAgent:
            return "Support Agent"
        }
    }
}

// MARK: - UserRole

struct UserRole: Identifiable, Hashable, Codable {
    let id: String
    let type: UserRoleType
    let name: String
    let permissions: [Permission]

    init(
        type: UserRoleType,
        permissions: [Permission]
    ) {
        self.id = type.rawValue
        self.type = type
        self.name = type.title
        self.permissions = permissions
    }
}

// MARK: - Default Roles

extension UserRole {

    static let customer = UserRole(
        type: .customer,
        permissions: [
            Permission(code: .productRead, description: "Can browse products."),
            Permission(code: .campaignRead, description: "Can view public campaigns.")
        ]
    )

    static let admin = UserRole(
        type: .admin,
        permissions: PermissionCatalog.allPermissions
    )

    static let productManager = UserRole(
        type: .productManager,
        permissions: [
            Permission(code: .adminAccess, description: "Can access admin area."),
            Permission(code: .productRead, description: "Can view products."),
            Permission(code: .productCreate, description: "Can create products."),
            Permission(code: .productUpdate, description: "Can update products."),
            Permission(code: .productDelete, description: "Can delete products."),
            Permission(code: .reportView, description: "Can view product reports.")
        ]
    )

    static let campaignManager = UserRole(
        type: .campaignManager,
        permissions: [
            Permission(code: .adminAccess, description: "Can access admin area."),
            Permission(code: .campaignRead, description: "Can view campaigns."),
            Permission(code: .campaignCreate, description: "Can create campaigns."),
            Permission(code: .campaignUpdate, description: "Can update campaigns."),
            Permission(code: .campaignDelete, description: "Can delete campaigns.")
        ]
    )

    static let supportAgent = UserRole(
        type: .supportAgent,
        permissions: [
            Permission(code: .adminAccess, description: "Can access admin area."),
            Permission(code: .orderRead, description: "Can view customer orders."),
            Permission(code: .orderUpdateStatus, description: "Can update order status."),
            Permission(code: .userRead, description: "Can view customer profile information.")
        ]
    )
}

// MARK: - PermissionCatalog

enum PermissionCatalog {
    static let allPermissions: [Permission] = [
        Permission(code: .productRead, description: "Can view products."),
        Permission(code: .productCreate, description: "Can create products."),
        Permission(code: .productUpdate, description: "Can update products."),
        Permission(code: .productDelete, description: "Can delete products."),

        Permission(code: .campaignRead, description: "Can view campaigns."),
        Permission(code: .campaignCreate, description: "Can create campaigns."),
        Permission(code: .campaignUpdate, description: "Can update campaigns."),
        Permission(code: .campaignDelete, description: "Can delete campaigns."),

        Permission(code: .orderRead, description: "Can view orders."),
        Permission(code: .orderUpdateStatus, description: "Can update order status."),

        Permission(code: .userRead, description: "Can view users."),
        Permission(code: .userManage, description: "Can manage users."),

        Permission(code: .roleRead, description: "Can view roles."),
        Permission(code: .roleManage, description: "Can manage roles."),

        Permission(code: .reportView, description: "Can view reports."),
        Permission(code: .adminAccess, description: "Can access admin dashboard.")
    ]
}