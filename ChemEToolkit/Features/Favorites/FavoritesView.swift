import SwiftUI

struct FavoritesView: View {
    let registry: ModuleRegistry

    @EnvironmentObject
    private var router: AppRouter

    @EnvironmentObject
    private var favoritesRepository:
        FavoritesRepository

    private var favoriteModules: [AppModule] {
        registry.allModules.filter {
            favoritesRepository.contains($0.id)
        }
    }

    private var columns: [GridItem] {
        [
            GridItem(
                .adaptive(
                    minimum:
                        AppTheme.Layout
                            .moduleCardMinimumWidth,
                    maximum:
                        AppTheme.Layout
                            .moduleCardMaximumWidth
                ),
                spacing: AppSpacing.medium
            )
        ]
    }

    var body: some View {
        Group {
            if favoriteModules.isEmpty {
                EmptyStateView(
                    symbolName: "star",
                    title: "No Favorites Yet",
                    message:
                        "Open a calculator and select the star button to add it here."
                )
                .frame(
                    maxWidth: .infinity,
                    maxHeight: .infinity
                )
            } else {
                ScrollView {
                    VStack(
                        alignment: .leading,
                        spacing: AppSpacing.medium
                    ) {
                        SectionHeaderView(
                            title: "Saved Tools",
                            subtitle:
                                "Your frequently used calculators",
                            actionTitle: "Clear"
                        ) {
                            favoritesRepository
                                .removeAll()
                        }

                        LazyVGrid(
                            columns: columns,
                            alignment: .leading,
                            spacing: AppSpacing.medium
                        ) {
                            ForEach(
                                favoriteModules
                            ) { module in
                                Button {
                                    router.openModule(
                                        module.id
                                    )
                                } label: {
                                    ModuleCard(
                                        metadata:
                                            module.metadata
                                    )
                                }
                                .buttonStyle(.plain)
                                .contextMenu {
                                    Button(
                                        role: .destructive
                                    ) {
                                        favoritesRepository
                                            .remove(
                                                module.id
                                            )
                                    } label: {
                                        Label(
                                            "Remove from Favorites",
                                            systemImage:
                                                "star.slash"
                                        )
                                    }
                                }
                            }
                        }
                    }
                    .frame(
                        maxWidth:
                            AppTheme.Layout
                                .contentMaxWidth,
                        alignment: .leading
                    )
                    .padding(
                        .horizontal,
                        AppTheme.Layout
                            .pageHorizontalPadding
                    )
                    .padding(
                        .vertical,
                        AppTheme.Layout
                            .pageVerticalPadding
                    )
                    .frame(maxWidth: .infinity)
                }
            }
        }
        .navigationTitle("Favorites")
    }
}
