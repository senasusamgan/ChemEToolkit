import SwiftUI

struct SearchView: View {
    let registry: ModuleRegistry

    @EnvironmentObject
    private var router: AppRouter

    @State private var searchText = ""

    private var results: [AppModule] {
        let trimmedText = searchText
            .trimmingCharacters(
                in: .whitespacesAndNewlines
            )

        guard !trimmedText.isEmpty else {
            return registry.allModules
        }

        return registry.search(
            for: trimmedText
        )
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
        ScrollView {
            Group {
                if results.isEmpty {
                    EmptyStateView(
                        symbolName: "magnifyingglass",
                        title: "No Tools Found",
                        message:
                            "Try searching for a different equation, topic or engineering term."
                    )
                    .frame(
                        maxWidth: .infinity,
                        minHeight: 360
                    )
                } else {
                    VStack(
                        alignment: .leading,
                        spacing: AppSpacing.medium
                    ) {
                        Text(resultCountText)
                            .font(.subheadline)
                            .foregroundStyle(.secondary)

                        LazyVGrid(
                            columns: columns,
                            alignment: .leading,
                            spacing: AppSpacing.medium
                        ) {
                            ForEach(results) { module in
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
                            }
                        }
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
        .navigationTitle("Search")
        .searchable(
            text: $searchText,
            prompt: "Search tools and topics"
        )
    }

    private var resultCountText: String {
        results.count == 1
            ? "1 tool"
            : "\(results.count) tools"
    }
}
