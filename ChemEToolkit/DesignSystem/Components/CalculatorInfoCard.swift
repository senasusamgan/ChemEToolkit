import SwiftUI

struct CalculatorInfoCard<Content: View>: View {
    let tint: Color

    private let content: Content

    init(
        tint: Color = AppTheme.Colors.accent,
        @ViewBuilder content: () -> Content
    ) {
        self.tint = tint
        self.content = content()
    }

    var body: some View {
        content
            .padding(AppSpacing.medium)
            .frame(
                maxWidth: .infinity,
                alignment: .leading
            )
            .background(
                RoundedRectangle(
                    cornerRadius:
                        AppTheme.Radius.medium
                )
                .fill(tint.opacity(0.08))
            )
            .overlay(
                RoundedRectangle(
                    cornerRadius:
                        AppTheme.Radius.medium
                )
                .stroke(
                    tint.opacity(0.12),
                    lineWidth: 1
                )
            )
    }
}
