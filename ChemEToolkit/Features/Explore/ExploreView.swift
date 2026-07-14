import SwiftUI

struct ExploreView: View {
    let registry: ModuleRegistry

    @EnvironmentObject
    private var router: AppRouter

    private var columns: [GridItem] {
        [
            GridItem(
                .adaptive(
                    minimum:
                        AppTheme.Layout
                            .categoryCardMinimumWidth,
                    maximum:
                        AppTheme.Layout
                            .categoryCardMaximumWidth
                ),
                spacing: AppSpacing.medium
            )
        ]
    }

    var body: some View {
        ScrollView {
            VStack(
                alignment: .leading,
                spacing: AppSpacing.xLarge
            ) {
                SectionHeaderView(
                    title: "Engineering Categories",
                    subtitle:
                        "Browse calculators by chemical engineering discipline"
                )

                LazyVGrid(
                    columns: columns,
                    alignment: .leading,
                    spacing: AppSpacing.medium
                ) {
                    ForEach(
                        registry.availableCategories
                    ) { category in
                        Button {
                            router.openCategory(
                                category
                            )
                        } label: {
                            CategoryCard(
                                category: category,
                                moduleCount:
                                    registry
                                        .modules(
                                            in: category
                                        )
                                        .count
                            )
                        }
                        .buttonStyle(.plain)
                    }
                }
            }
            .frame(
                maxWidth:
                    AppTheme.Layout.contentMaxWidth,
                alignment: .leading
            )
            .padding(
                .horizontal,
                AppTheme.Layout.pageHorizontalPadding
            )
            .padding(
                .vertical,
                AppTheme.Layout.pageVerticalPadding
            )
            .frame(maxWidth: .infinity)
        }
        .navigationTitle("Explore")
    }
}
