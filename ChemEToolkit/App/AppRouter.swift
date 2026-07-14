import SwiftUI
import Combine

@MainActor
final class AppRouter: ObservableObject {
    @Published var selectedTab: AppTab = .home

    @Published var homePath = NavigationPath()
    @Published var explorePath = NavigationPath()
    @Published var favoritesPath = NavigationPath()
    @Published var settingsPath = NavigationPath()

    func navigate(
        to route: AppRoute,
        in tab: AppTab? = nil
    ) {
        let targetTab = tab ?? selectedTab

        if tab != nil {
            selectedTab = targetTab
        }

        switch targetTab {
        case .home:
            homePath.append(route)

        case .explore:
            explorePath.append(route)

        case .favorites:
            favoritesPath.append(route)

        case .settings:
            settingsPath.append(route)
        }
    }

    func openModule(
        _ moduleID: ModuleID,
        in tab: AppTab? = nil
    ) {
        navigate(
            to: .module(moduleID),
            in: tab
        )
    }

    func openCategory(
        _ category: ModuleCategory,
        in tab: AppTab? = nil
    ) {
        navigate(
            to: .category(category),
            in: tab
        )
    }

    func openSearch(
        in tab: AppTab? = nil
    ) {
        navigate(
            to: .search,
            in: tab
        )
    }

    func goBack(
        in tab: AppTab? = nil
    ) {
        let targetTab = tab ?? selectedTab

        switch targetTab {
        case .home:
            guard !homePath.isEmpty else {
                return
            }

            homePath.removeLast()

        case .explore:
            guard !explorePath.isEmpty else {
                return
            }

            explorePath.removeLast()

        case .favorites:
            guard !favoritesPath.isEmpty else {
                return
            }

            favoritesPath.removeLast()

        case .settings:
            guard !settingsPath.isEmpty else {
                return
            }

            settingsPath.removeLast()
        }
    }

    func returnToRoot(
        in tab: AppTab? = nil
    ) {
        let targetTab = tab ?? selectedTab

        switch targetTab {
        case .home:
            homePath = NavigationPath()

        case .explore:
            explorePath = NavigationPath()

        case .favorites:
            favoritesPath = NavigationPath()

        case .settings:
            settingsPath = NavigationPath()
        }
    }

    func returnAllTabsToRoot() {
        homePath = NavigationPath()
        explorePath = NavigationPath()
        favoritesPath = NavigationPath()
        settingsPath = NavigationPath()
    }

    func switchTab(
        to tab: AppTab,
        resetNavigation: Bool = false
    ) {
        selectedTab = tab

        if resetNavigation {
            returnToRoot(in: tab)
        }
    }
}
