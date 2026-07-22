import SwiftUI

struct EngineeringInputField: View {

    let title: String
    let symbol: String
    let unit: String
    let placeholder: String

    @Binding
    var text: String

    var body: some View {
        VStack(
            alignment: .leading,
            spacing: AppSpacing.xxSmall
        ) {
            HStack(
                alignment: .firstTextBaseline
            ) {
                Text(title)
                    .font(.subheadline)
                    .fontWeight(.medium)

                Spacer()

                Text(symbol)
                    .font(.subheadline)
                    .foregroundStyle(.secondary)
            }

            HStack(
                spacing: AppSpacing.small
            ) {
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

                if !unit.isEmpty {
                    Text(unit)
                        .font(.subheadline)
                        .foregroundStyle(.secondary)
                        .frame(
                            minWidth: 58,
                            alignment: .leading
                        )
                }
            }
        }
    }
}
