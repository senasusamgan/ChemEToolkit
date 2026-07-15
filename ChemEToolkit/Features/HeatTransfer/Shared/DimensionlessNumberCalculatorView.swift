import SwiftUI

struct DimensionlessNumberInputFieldConfiguration:
    Identifiable {

    let id: String
    let title: String
    let symbol: String
    let unit: String
    let placeholder: String
    let text: Binding<String>
}

struct DimensionlessNumberInformationRow:
    Identifiable {

    let id: String
    let title: String
    let value: String
}

struct DimensionlessNumberCalculatorView: View {

    let symbolName: String
    let title: String
    let subtitle: String

    let formulaTitle: String
    let formula: String
    let explanation: String

    let fields:
        [DimensionlessNumberInputFieldConfiguration]

    let calculateTitle: String
    let calculateSystemImage: String

    let resultItems:
        [CalculationResultDisplayItem]

    let interpretationTitle: String
    let interpretationSystemImage: String

    let informationRows:
        [DimensionlessNumberInformationRow]

    let interpretationText: String
    let errorMessage: String

    let loadExample: () -> Void
    let clear: () -> Void
    let calculate: () -> Void

    var tint: Color = .orange

    var body: some View {
        ScrollView {
            VStack(spacing: AppSpacing.xLarge) {
                ModuleHeaderView(
                    symbolName: symbolName,
                    title: title,
                    subtitle: subtitle,
                    tint: tint
                )

                formulaCard

                CalculatorCard {
                    calculatorContent
                }
            }
            .frame(
                maxWidth: .infinity,
                alignment: .center
            )
            .padding(
                .horizontal,
                AppTheme.Layout
                    .pageHorizontalPadding
            )
            .padding(
                .vertical,
                AppTheme.Layout
                    .pageVerticalPadding
            )
        }
        .navigationTitle(title)
    }

    private var formulaCard: some View {
        CalculatorInfoCard(tint: tint) {
            VStack(spacing: AppSpacing.small) {
                Text(formulaTitle)
                    .font(.headline)

                Text(formula)
                    .font(
                        .system(
                            size: 22,
                            weight: .semibold
                        )
                    )
                    .multilineTextAlignment(.center)
                    .minimumScaleFactor(0.6)

                Text(explanation)
                    .foregroundStyle(.secondary)
                    .multilineTextAlignment(.center)
            }
            .frame(maxWidth: .infinity)
        }
        .frame(
            maxWidth:
                AppTheme.Layout
                    .calculatorMaxWidth
        )
    }

    private var calculatorContent: some View {
        VStack(
            alignment: .leading,
            spacing: AppSpacing.large
        ) {
            Text("Engineering Inputs")
                .font(.headline)

            ForEach(fields) { field in
                EngineeringInputField(
                    title: field.title,
                    symbol: field.symbol,
                    unit: field.unit,
                    placeholder: field.placeholder,
                    text: field.text
                )
            }

            actionButtons

            PrimaryActionButton(
                title: calculateTitle,
                systemImage: calculateSystemImage,
                action: calculate
            )

            if !resultItems.isEmpty {
                CalculationResultCard(
                    items: resultItems,
                    tint: tint
                )
            }

            if !informationRows.isEmpty
                || !interpretationText.isEmpty {

                interpretationCard
            }

            if !errorMessage.isEmpty {
                CalculationErrorCard(
                    message: errorMessage
                )
            }
        }
    }

    private var actionButtons: some View {
        ViewThatFits(in: .horizontal) {
            HStack(spacing: AppSpacing.small) {
                loadExampleButton
                clearButton
            }

            VStack(spacing: AppSpacing.small) {
                loadExampleButton
                clearButton
            }
        }
    }

    private var loadExampleButton: some View {
        Button(action: loadExample) {
            Label(
                "Load Example",
                systemImage: "doc.text"
            )
            .frame(maxWidth: .infinity)
        }
        .buttonStyle(.bordered)
    }

    private var clearButton: some View {
        Button(action: clear) {
            Label(
                "Clear",
                systemImage:
                    "arrow.counterclockwise"
            )
            .frame(maxWidth: .infinity)
        }
        .buttonStyle(.bordered)
    }

    private var interpretationCard: some View {
        CalculatorInfoCard(tint: tint) {
            VStack(
                alignment: .leading,
                spacing: AppSpacing.small
            ) {
                Label(
                    interpretationTitle,
                    systemImage:
                        interpretationSystemImage
                )
                .font(.headline)

                Divider()

                ForEach(informationRows) { row in
                    informationRow(
                        title: row.title,
                        value: row.value
                    )
                }

                if !interpretationText.isEmpty {
                    Text(interpretationText)
                        .font(.caption)
                        .foregroundStyle(.secondary)
                }
            }
        }
    }

    private func informationRow(
        title: String,
        value: String
    ) -> some View {
        HStack(
            alignment: .firstTextBaseline,
            spacing: AppSpacing.medium
        ) {
            Text(title)
                .foregroundStyle(.secondary)

            Spacer()

            Text(value)
                .fontWeight(.semibold)
                .multilineTextAlignment(.trailing)
        }
    }
}
