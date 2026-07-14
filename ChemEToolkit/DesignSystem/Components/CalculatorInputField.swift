import SwiftUI

struct CalculatorInputField: View {
    let title: String
    let symbol: String
    let unit: String
    let placeholder: String

    @Binding var text: String

    var isCalculated = false

    var calculatedMessage =
        "Calculated automatically"

    var body: some View {
        VStack(
            alignment: .leading,
            spacing: AppSpacing.xSmall
        ) {
            HStack {
                Text(displayTitle)
                    .font(.headline)

                Spacer(minLength: AppSpacing.small)

                Text(unit)
                    .font(.subheadline)
                    .foregroundStyle(.secondary)
            }

            if isCalculated {
                calculatedField
            } else {
                TextField(
                    placeholder,
                    text: $text
                )
                .textFieldStyle(.roundedBorder)
                .engineeringNumberKeyboard()
                .accessibilityLabel(title)
                .accessibilityHint(
                    unit.isEmpty
                        ? placeholder
                        : "\(placeholder). Unit: \(unit)"
                )
            }
        }
    }

    private var displayTitle: String {
        guard !symbol.isEmpty else {
            return title
        }

        return "\(title) (\(symbol))"
    }

    private var calculatedField: some View {
        HStack(spacing: AppSpacing.xSmall) {
            Image(systemName: "function")
                .foregroundStyle(.secondary)
                .accessibilityHidden(true)

            Text(calculatedMessage)
                .foregroundStyle(.secondary)

            Spacer()
        }
        .padding(.horizontal, AppSpacing.small)
        .frame(
            maxWidth: .infinity,
            minHeight: 32,
            alignment: .leading
        )
        .background(
            RoundedRectangle(
                cornerRadius: AppTheme.Radius.small
            )
            .fill(AppTheme.Colors.surface)
        )
        .accessibilityElement(
            children: .combine
        )
    }
}
