import SwiftUI

struct CalculationResultDisplayItem:
    Identifiable,
    Equatable {

    let id: UUID
    let label: String
    let value: String
    let unit: String

    init(
        id: UUID = UUID(),
        label: String,
        value: String,
        unit: String
    ) {
        self.id = id
        self.label = label
        self.value = value
        self.unit = unit
    }
}

struct CalculationResultCard: View {
    let items: [CalculationResultDisplayItem]

    var tint: Color = .green

    var body: some View {
        VStack(spacing: AppSpacing.large) {
            ForEach(
                Array(items.enumerated()),
                id: \.element.id
            ) { index, item in
                resultItem(item)

                if index < items.count - 1 {
                    Divider()
                }
            }
        }
        .frame(maxWidth: .infinity)
        .padding(AppSpacing.large)
        .background(
            RoundedRectangle(
                cornerRadius: AppTheme.Radius.large
            )
            .fill(tint.opacity(0.12))
        )
        .overlay(
            RoundedRectangle(
                cornerRadius: AppTheme.Radius.large
            )
            .stroke(
                tint.opacity(0.14),
                lineWidth: 1
            )
        )
        .accessibilityElement(
            children: .contain
        )
    }

    private func resultItem(
        _ item: CalculationResultDisplayItem
    ) -> some View {
        VStack(spacing: AppSpacing.xSmall) {
            Text(item.label)
                .font(.headline)
                .foregroundStyle(.secondary)
                .multilineTextAlignment(.center)

            Text(item.value)
                .font(
                    .system(
                        size: 32,
                        weight: .bold
                    )
                )
                .lineLimit(1)
                .minimumScaleFactor(0.55)

            if !item.unit.isEmpty {
                Text(item.unit)
                    .font(.title3)
                    .foregroundStyle(.secondary)
            }
        }
        .frame(maxWidth: .infinity)
        .accessibilityElement(
            children: .combine
        )
    }
}
