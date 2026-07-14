import SwiftUI

struct AppRootView: View {
    let registry: ModuleRegistry

    @StateObject
    private var router = AppRouter()

    @StateObject
    private var favoritesRepository =
        FavoritesRepository()

    @StateObject
    private var recentModulesRepository =
        RecentModulesRepository()

    @StateObject
    private var appSettings =
        AppSettingsStore()

    init(
        registry: ModuleRegistry = .live
    ) {
        self.registry = registry
    }

    var body: some View {
        TabView(
            selection:
                $router.selectedTab
        ) {
            navigationStack(
                path: $router.homePath
            ) {
                HomeView(
                    registry: registry
                )
            }
            .tag(AppTab.home)
            .tabItem {
                Label(
                    "Home",
                    systemImage: "house.fill"
                )
            }

            navigationStack(
                path: $router.explorePath
            ) {
                ExploreView(
                    registry: registry
                )
            }
            .tag(AppTab.explore)
            .tabItem {
                Label(
                    "Explore",
                    systemImage:
                        "square.grid.2x2.fill"
                )
            }

            navigationStack(
                path: $router.favoritesPath
            ) {
                FavoritesView(
                    registry: registry
                )
            }
            .tag(AppTab.favorites)
            .tabItem {
                Label(
                    "Favorites",
                    systemImage: "star.fill"
                )
            }

            navigationStack(
                path: $router.settingsPath
            ) {
                SettingsView()
            }
            .tag(AppTab.settings)
            .tabItem {
                Label(
                    "Settings",
                    systemImage:
                        "gearshape.fill"
                )
            }
        }
        .environmentObject(router)
        .environmentObject(
            favoritesRepository
        )
        .environmentObject(
            recentModulesRepository
        )
        .environmentObject(
            appSettings
        )
        .preferredColorScheme(
            appSettings
                .appearance
                .colorScheme
        )
        .calculatorKeyboardSupport()
    }

    private func navigationStack<
        Content: View
    >(
        path: Binding<NavigationPath>,
        @ViewBuilder
        content: () -> Content
    ) -> some View {
        NavigationStack(path: path) {
            content()
                .navigationDestination(
                    for: AppRoute.self
                ) { route in
                    destination(
                        for: route
                    )
                }
        }
    }

    @ViewBuilder
    private func destination(
        for route: AppRoute
    ) -> some View {
        switch route {
        case .module(
            let moduleID
        ):
            if let module =
                registry.module(
                    for: moduleID
                ) {
                ModuleContainerView(
                    module: module
                )
            } else {
                missingModuleView
            }

        case .category(
            let category
        ):
            CategoryModulesView(
                category: category,
                registry: registry
            )

        case .search:
            SearchView(
                registry: registry
            )
        }
    }

    private var missingModuleView:
        some View {
        VStack(
            spacing: AppSpacing.medium
        ) {
            Image(
                systemName:
                    "exclamationmark.triangle"
            )
            .font(.system(size: 40))
            .foregroundStyle(.secondary)
            .accessibilityHidden(true)

            Text("Module Unavailable")
                .font(.title2.bold())

            Text(
                "This calculator could not be loaded."
            )
            .foregroundStyle(.secondary)
        }
        .padding(AppSpacing.xLarge)
        .accessibilityElement(
            children: .combine
        )
    }
}
