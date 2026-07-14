import SwiftUI

struct EmptyStateView: View {
    let symbolName: String
    let title: String
    let message: String

    var body: some View {
        VStack(spacing: AppSpacing.medium) {
            Image(systemName: symbolName)
                .font(
                    .system(
                        size: 44,
                        weight: .medium
                    )
                )
                .foregroundStyle(.secondary)
                .accessibilityHidden(true)

            Text(title)
                .font(.title2.bold())
                .multilineTextAlignment(.center)

            Text(message)
                .foregroundStyle(.secondary)
                .multilineTextAlignment(.center)
                .fixedSize(
                    horizontal: false,
                    vertical: true
                )
        }
        .frame(
            maxWidth: 460,
            maxHeight: .infinity
        )
        .padding(AppSpacing.xLarge)
        .accessibilityElement(
            children: .combine
        )
    }
}
