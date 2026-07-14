import SwiftUI

struct CalculatorCard<Content: View>: View {
    private let content: Content

    init(
        @ViewBuilder content: () -> Content
    ) {
        self.content = content()
    }

    var body: some View {
        content
            .padding(AppSpacing.xLarge)
            .frame(
                maxWidth:
                    AppTheme.Layout.calculatorMaxWidth,
                alignment: .leading
            )
            .background(
                RoundedRectangle(
                    cornerRadius:
                        AppTheme.Radius.extraLarge
                )
                .fill(AppTheme.Colors.surface)
            )
            .overlay(
                RoundedRectangle(
                    cornerRadius:
                        AppTheme.Radius.extraLarge
                )
                .stroke(
                    AppTheme.Colors.border,
                    lineWidth: 1
                )
            )
    }
}
