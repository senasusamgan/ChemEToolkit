import SwiftUI

enum AppTab: Hashable {
    case home
    case explore
    case favorites
    case settings
}

enum AppRoute: Hashable {
    case module(ModuleID)
    case category(ModuleCategory)
    case search
}
