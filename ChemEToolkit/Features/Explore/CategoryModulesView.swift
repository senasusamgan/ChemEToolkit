import SwiftUI

struct CategoryModulesView: View {
    let category: ModuleCategory
    let registry: ModuleRegistry

    @EnvironmentObject
    private var router: AppRouter

    private var modules: [AppModule] {
        registry.modules(in: category)
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
            VStack(
                alignment: .leading,
                spacing: AppSpacing.xLarge
            ) {
                categoryHeader

                LazyVGrid(
                    columns: columns,
                    alignment: .leading,
                    spacing: AppSpacing.medium
                ) {
                    ForEach(modules) { module in
                        Button {
                            router.openModule(module.id)
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
        .navigationTitle(category.title)
    }

    private var categoryHeader: some View {
        HStack(
            alignment: .top,
            spacing: AppSpacing.medium
        ) {
            Image(systemName: category.symbolName)
                .font(.title2)
                .foregroundStyle(
                    AppTheme.Colors.accent
                )
                .frame(width: 46, height: 46)
                .background(
                    RoundedRectangle(
                        cornerRadius:
                            AppTheme.Radius.medium
                    )
                    .fill(
                        AppTheme.Colors.accent
                            .opacity(0.14)
                    )
                )
                .accessibilityHidden(true)

            VStack(
                alignment: .leading,
                spacing: AppSpacing.xxSmall
            ) {
                Text(category.title)
                    .font(.title2.bold())

                Text(category.subtitle)
                    .foregroundStyle(.secondary)

                Text(
                    modules.count == 1
                        ? "1 available tool"
                        : "\(modules.count) available tools"
                )
                .font(.caption)
                .foregroundStyle(.secondary)
            }
        }
        .accessibilityElement(
            children: .combine
        )
    }
}
