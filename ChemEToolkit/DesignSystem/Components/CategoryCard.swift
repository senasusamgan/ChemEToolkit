import SwiftUI

struct CategoryCard: View {
    let category: ModuleCategory
    let moduleCount: Int

    var body: some View {
        HStack(spacing: AppSpacing.medium) {
            Image(systemName: category.symbolName)
                .font(.title2)
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
                .foregroundStyle(
                    AppTheme.Colors.accent
                )
                .accessibilityHidden(true)

            VStack(
                alignment: .leading,
                spacing: AppSpacing.xxSmall
            ) {
                Text(category.title)
                    .font(.headline)
                    .foregroundStyle(.primary)

                Text(toolCountText)
                    .font(.subheadline)
                    .foregroundStyle(.secondary)
            }

            Spacer(minLength: AppSpacing.xSmall)

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
        .accessibilityElement(
            children: .combine
        )
        .accessibilityHint(
            "Opens the \(category.title) category"
        )
    }

    private var toolCountText: String {
        moduleCount == 1
            ? "1 tool"
            : "\(moduleCount) tools"
    }
}
