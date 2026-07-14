import SwiftUI

struct ModuleHeaderView: View {
    let symbolName: String
    let title: String
    let subtitle: String

    var tint: Color = AppTheme.Colors.accent

    var body: some View {
        VStack(spacing: AppSpacing.small) {
            Image(systemName: symbolName)
                .font(
                    .system(
                        size: AppTheme.Layout.iconSize,
                        weight: .medium
                    )
                )
                .foregroundStyle(tint)
                .accessibilityHidden(true)

            Text(title)
                .font(.largeTitle.bold())
                .multilineTextAlignment(.center)

            Text(subtitle)
                .font(.title3)
                .foregroundStyle(.secondary)
                .multilineTextAlignment(.center)
        }
        .frame(
            maxWidth: .infinity,
            alignment: .center
        )
        .accessibilityElement(
            children: .combine
        )
    }
}
