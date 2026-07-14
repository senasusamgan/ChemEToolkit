import SwiftUI

struct HomeView: View {
    let registry: ModuleRegistry

    @EnvironmentObject
    private var router: AppRouter

    @EnvironmentObject
    private var recentModulesRepository:
        RecentModulesRepository

    private var moduleColumns: [GridItem] {
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

    private var categoryColumns: [GridItem] {
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

    private var recentModules: [AppModule] {
        recentModulesRepository
            .recentModuleIDs
            .compactMap {
                registry.module(for: $0)
            }
    }

    var body: some View {
        ScrollView {
            LazyVStack(
                alignment: .leading,
                spacing: AppSpacing.xxLarge
            ) {
                header
                searchButton

                if !recentModules.isEmpty {
                    recentSection
                }

                featuredSection
                categoriesSection
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
        .navigationTitle("ChemE Toolkit")
    }

    private var header: some View {
        VStack(
            alignment: .leading,
            spacing: AppSpacing.xSmall
        ) {
            Text("Chemical Engineering Tools")
                .font(.largeTitle.bold())

            Text(
                "Calculators and engineering utilities designed for students and professionals."
            )
            .font(.body)
            .foregroundStyle(.secondary)
            .fixedSize(
                horizontal: false,
                vertical: true
            )
        }
        .frame(
            maxWidth: 720,
            alignment: .leading
        )
    }

    private var searchButton: some View {
        Button {
            router.openSearch()
        } label: {
            HStack(spacing: AppSpacing.small) {
                Image(systemName: "magnifyingglass")
                    .foregroundStyle(.secondary)
                    .accessibilityHidden(true)

                Text("Search calculators and topics")
                    .foregroundStyle(.secondary)

                Spacer()

                Image(systemName: "chevron.right")
                    .font(.caption.weight(.semibold))
                    .foregroundStyle(.tertiary)
                    .accessibilityHidden(true)
            }
            .padding(AppSpacing.medium)
            .background(
                RoundedRectangle(
                    cornerRadius:
                        AppTheme.Radius.large
                )
                .fill(AppTheme.Colors.surface)
            )
            .overlay(
                RoundedRectangle(
                    cornerRadius:
                        AppTheme.Radius.large
                )
                .stroke(
                    AppTheme.Colors.border,
                    lineWidth: 1
                )
            )
            .contentShape(Rectangle())
        }
        .buttonStyle(.plain)
        .accessibilityLabel(
            "Search calculators and topics"
        )
    }

    private var recentSection: some View {
        VStack(
            alignment: .leading,
            spacing: AppSpacing.medium
        ) {
            SectionHeaderView(
                title: "Recent Tools",
                subtitle:
                    "Continue where you left off",
                actionTitle: "Clear"
            ) {
                recentModulesRepository.removeAll()
            }

            LazyVGrid(
                columns: moduleColumns,
                alignment: .leading,
                spacing: AppSpacing.medium
            ) {
                ForEach(recentModules) { module in
                    moduleButton(module)
                }
            }
        }
    }

    private var featuredSection: some View {
        VStack(
            alignment: .leading,
            spacing: AppSpacing.medium
        ) {
            SectionHeaderView(
                title: "Featured Tools",
                subtitle:
                    "Quick access to commonly used calculators"
            )

            LazyVGrid(
                columns: moduleColumns,
                alignment: .leading,
                spacing: AppSpacing.medium
            ) {
                ForEach(
                    registry.featuredModules
                ) { module in
                    moduleButton(module)
                }
            }
        }
    }

    private var categoriesSection: some View {
        VStack(
            alignment: .leading,
            spacing: AppSpacing.medium
        ) {
            SectionHeaderView(
                title: "Categories",
                subtitle:
                    "Browse tools by engineering discipline"
            )

            LazyVGrid(
                columns: categoryColumns,
                alignment: .leading,
                spacing: AppSpacing.medium
            ) {
                ForEach(
                    registry.availableCategories
                ) { category in
                    Button {
                        router.openCategory(category)
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
    }

    private func moduleButton(
        _ module: AppModule
    ) -> some View {
        Button {
            router.openModule(module.id)
        } label: {
            ModuleCard(
                metadata: module.metadata
            )
        }
        .buttonStyle(.plain)
    }
}
