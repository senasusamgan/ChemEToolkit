import SwiftUI

struct CalculationErrorCard: View {
    let message: String

    var body: some View {
        Label {
            Text(message)
                .fixedSize(
                    horizontal: false,
                    vertical: true
                )
        } icon: {
            Image(
                systemName:
                    "exclamationmark.triangle.fill"
            )
            .accessibilityHidden(true)
        }
        .foregroundStyle(.red)
        .frame(
            maxWidth: .infinity,
            alignment: .leading
        )
        .padding(AppSpacing.medium)
        .background(
            RoundedRectangle(
                cornerRadius: AppTheme.Radius.medium
            )
            .fill(AppTheme.Colors.errorSurface)
        )
        .overlay(
            RoundedRectangle(
                cornerRadius: AppTheme.Radius.medium
            )
            .stroke(
                Color.red.opacity(0.15),
                lineWidth: 1
            )
        )
        .accessibilityElement(
            children: .combine
        )
        .accessibilityLabel(
            "Calculation error. \(message)"
        )
    }
}
