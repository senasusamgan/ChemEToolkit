import SwiftUI

struct ModuleCard: View {
    let metadata: ModuleMetadata

    var body: some View {
        HStack(spacing: AppSpacing.medium) {
            Image(systemName: metadata.symbolName)
                .font(.title2)
                .frame(width: 44, height: 44)
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
                Text(metadata.title)
                    .font(.headline)
                    .foregroundStyle(.primary)

                Text(metadata.subtitle)
                    .font(.subheadline)
                    .foregroundStyle(.secondary)
                    .lineLimit(2)
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
                cornerRadius: AppTheme.Radius.large
            )
            .fill(AppTheme.Colors.surface)
        )
        .overlay(
            RoundedRectangle(
                cornerRadius: AppTheme.Radius.large
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
            "Opens \(metadata.title)"
        )
    }
}
