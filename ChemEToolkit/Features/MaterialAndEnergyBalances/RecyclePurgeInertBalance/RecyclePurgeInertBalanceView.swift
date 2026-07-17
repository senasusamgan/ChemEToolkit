import SwiftUI

struct RecyclePurgeInertBalanceView:
    View {

    @State private var freshFeedInput = "100"
    @State private var inertFractionInput = "0.10"
    @State private var conversionInput = "0.60"
    @State private var purgeInput = "0.20"

    @State private var result:
        RecyclePurgeInertBalanceResult?

    @State private var errorMessage = ""

    private let engine =
        RecyclePurgeInertBalanceEngine()

    private let numberFormatter =
        NumberFormatterService.precise

    var body: some View {
        ScrollView {
            VStack(spacing: AppSpacing.xLarge) {
                ModuleHeaderView(
                    symbolName: "arrow.triangle.2.circlepath",
                    title: "Recycle–Purge Inert Balance",
                    subtitle: "Solve steady recycle buildup and purge losses",
                    tint: .teal
                )

                CalculatorInfoCard(tint: .teal) {
                    Text("The model tracks one reactant and one inert around a reactor, product separator and purge splitter.")
                        .foregroundStyle(.secondary)
                        .multilineTextAlignment(.center)
                        .frame(maxWidth: .infinity)
                }
                .frame(
                    maxWidth:
                        AppTheme.Layout
                            .calculatorMaxWidth
                )

                CalculatorCard {
                    VStack(
                        alignment: .leading,
                        spacing: AppSpacing.large
                    ) {
                        EngineeringInputField(
                            title: "Fresh Feed Mass Flow",
                            symbol: "F",
                            unit: "kg/h",
                            placeholder: "100",
                            text: $freshFeedInput
                        )

                        EngineeringInputField(
                            title: "Fresh Feed Inert Fraction",
                            symbol: "z_I",
                            unit: "—",
                            placeholder: "0.10",
                            text: $inertFractionInput
                        )

                        EngineeringInputField(
                            title: "Single-Pass Conversion",
                            symbol: "X",
                            unit: "—",
                            placeholder: "0.60",
                            text: $conversionInput
                        )

                        EngineeringInputField(
                            title: "Purge Fraction",
                            symbol: "p",
                            unit: "—",
                            placeholder: "0.20",
                            text: $purgeInput
                        )

                        HStack(spacing: AppSpacing.medium) {
                            Button(action: loadExample) {
                                Label(
                                    "Load Example",
                                    systemImage:
                                        "arrow.counterclockwise"
                                )
                            }

                            Spacer()

                            Button(
                                role: .destructive,
                                action: resetInputs
                            ) {
                                Label(
                                    "Clear",
                                    systemImage: "trash"
                                )
                            }
                        }
                        .buttonStyle(.bordered)

                        PrimaryActionButton(
                            title: "Calculate",
                            systemImage: "arrow.triangle.2.circlepath",
                            action: calculate
                        )

                        if let result {
                            CalculationResultCard(
                                items: [
                                    .init(
                                        label: "Total Recycle Flow",
                                        value: numberFormatter.format(result.totalRecycleFlow),
                                        unit: "kg/h"
                                    ),
.init(
                                        label: "Recycle Reactant Flow",
                                        value: numberFormatter.format(result.recycleReactantFlow),
                                        unit: "kg/h"
                                    ),
.init(
                                        label: "Recycle Inert Flow",
                                        value: numberFormatter.format(result.recycleInertFlow),
                                        unit: "kg/h"
                                    ),
.init(
                                        label: "Reactor Feed Flow",
                                        value: numberFormatter.format(result.reactorFeedFlow),
                                        unit: "kg/h"
                                    ),
.init(
                                        label: "Reactor Feed Inert Fraction",
                                        value: numberFormatter.format(result.reactorFeedInertMassFraction),
                                        unit: "—"
                                    ),
.init(
                                        label: "Purge Flow",
                                        value: numberFormatter.format(result.purgeFlow),
                                        unit: "kg/h"
                                    ),
.init(
                                        label: "Overall Reactant Conversion",
                                        value: numberFormatter.format(100 * result.overallReactantConversion),
                                        unit: "%"
                                    )
                                ],
                                tint: .teal
                            )

                            CalculatorInfoCard(tint: .teal) {
                                VStack(
                                    alignment: .leading,
                                    spacing: AppSpacing.small
                                ) {
                                    Text(result.modelName)
                                        .font(.headline)

                                    Divider()

                                    Text(
                                        result
                                            .limitationDescription
                                    )
                                    .foregroundStyle(.secondary)
                                }
                            }
                        }

                        if !errorMessage.isEmpty {
                            CalculationErrorCard(
                                message: errorMessage
                            )
                        }
                    }
                }
            }
            .frame(maxWidth: .infinity)
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
        .navigationTitle("Recycle–Purge Inert Balance")
    }

    private func calculate() {
        result = nil
        errorMessage = ""

        do {
            result = try engine.calculate(
                .init(
                    freshFeedMassFlow:
                        try InputValidator.parseNumber(
                            freshFeedInput,
                            fieldName:
                                "fresh feed mass flow"
                        ),
                    freshFeedInertMassFraction:
                        try InputValidator.parseNumber(
                            inertFractionInput,
                            fieldName:
                                "fresh feed inert fraction"
                        ),
                    singlePassReactantConversion:
                        try InputValidator.parseNumber(
                            conversionInput,
                            fieldName:
                                "single-pass conversion"
                        ),
                    purgeFraction:
                        try InputValidator.parseNumber(
                            purgeInput,
                            fieldName:
                                "purge fraction"
                        )
                )
            )
        } catch {
            errorMessage =
                error.localizedDescription
        }
    }

    private func loadExample() {
        freshFeedInput = "100"
        inertFractionInput = "0.10"
        conversionInput = "0.60"
        purgeInput = "0.20"
        result = nil
        errorMessage = ""
    }

    private func resetInputs() {
        freshFeedInput = ""
        inertFractionInput = ""
        conversionInput = ""
        purgeInput = ""
        result = nil
        errorMessage = ""
    }
}

#Preview {
    NavigationStack {
        RecyclePurgeInertBalanceView()
    }
}
