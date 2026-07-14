import SwiftUI

struct ModuleContainerView: View {
    let module: AppModule

    @EnvironmentObject
    private var favoritesRepository: FavoritesRepository

    @EnvironmentObject
    private var recentModulesRepository: RecentModulesRepository

    @State private var hasRecordedVisit = false

    private var isFavorite: Bool {
        favoritesRepository.contains(module.id)
    }

    var body: some View {
        module.makeDestination()
            .toolbar {
                ToolbarItem(
                    placement: .primaryAction
                ) {
                    Button {
                        favoritesRepository.toggle(
                            module.id
                        )
                    } label: {
                        Image(
                            systemName: isFavorite
                                ? "star.fill"
                                : "star"
                        )
                    }
                    .help(
                        isFavorite
                            ? "Remove from Favorites"
                            : "Add to Favorites"
                    )
                    .accessibilityLabel(
                        isFavorite
                            ? "Remove from Favorites"
                            : "Add to Favorites"
                    )
                }
            }
            .onAppear {
                guard !hasRecordedVisit else {
                    return
                }

                recentModulesRepository.record(
                    module.id
                )

                hasRecordedVisit = true
            }
    }
}
