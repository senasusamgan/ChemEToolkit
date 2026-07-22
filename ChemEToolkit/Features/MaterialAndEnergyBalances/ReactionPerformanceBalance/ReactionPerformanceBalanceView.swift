import SwiftUI

struct ReactionPerformanceBalanceView:
    View {

    @State private var feedInput = "100"
    @State private var outletInput = "20"
    @State private var desiredInput = "60"
    @State private var undesiredInput = "20"

    @State private var result:
        ReactionPerformanceBalanceResult?

    @State private var errorMessage = ""

    private let engine =
        ReactionPerformanceBalanceEngine()

    private let numberFormatter =
        NumberFormatterService.precise

    var body: some View {
        ScrollView {
            VStack(spacing: AppSpacing.xLarge) {
                ModuleHeaderView(
                    symbolName: "chart.bar.xaxis",
                    title: "Conversion–Yield–Selectivity",
                    subtitle: "Evaluate reactant utilization and product distribution",
                    tint: .teal
                )

                CalculatorInfoCard(tint: .teal) {
                    Text("Product amounts must first be normalized to an equivalent reactant-consumption basis.")
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
                            title: "Reactant Feed",
                            symbol: "F_A0",
                            unit: "mol or kmol",
                            placeholder: "100",
                            text: $feedInput
                        )

                        EngineeringInputField(
                            title: "Reactant Outlet",
                            symbol: "F_A",
                            unit: "same unit",
                            placeholder: "20",
                            text: $outletInput
                        )

                        EngineeringInputField(
                            title: "Desired Product",
                            symbol: "P_D",
                            unit: "equivalent amount",
                            placeholder: "60",
                            text: $desiredInput
                        )

                        EngineeringInputField(
                            title: "Undesired Product",
                            symbol: "P_U",
                            unit: "equivalent amount",
                            placeholder: "20",
                            text: $undesiredInput
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
                            systemImage: "chart.bar.xaxis",
                            action: calculate
                        )

                        if let result {
                            CalculationResultCard(
                                items: [
                                    .init(
                                        label: "Reactant Consumed",
                                        value: numberFormatter.format(result.reactantConsumedAmount),
                                        unit: "input amount unit"
                                    ),
.init(
                                        label: "Conversion",
                                        value: numberFormatter.format(100 * result.conversionFraction),
                                        unit: "%"
                                    ),
.init(
                                        label: "Desired Yield on Feed",
                                        value: numberFormatter.format(100 * result.desiredYieldOnFeed),
                                        unit: "%"
                                    ),
.init(
                                        label: "Desired Yield on Reacted Basis",
                                        value: numberFormatter.format(100 * result.desiredYieldOnReactedBasis),
                                        unit: "%"
                                    ),
.init(
                                        label: "Desired/Undesired Selectivity",
                                        value: result.desiredToUndesiredSelectivity.isFinite ? numberFormatter.format(result.desiredToUndesiredSelectivity) : "Infinite",
                                        unit: "—"
                                    ),
.init(
                                        label: "Desired Product Distribution",
                                        value: numberFormatter.format(100 * result.desiredProductDistributionFraction),
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
        .navigationTitle("Conversion–Yield–Selectivity")
    }

    private func calculate() {
        result = nil
        errorMessage = ""

        do {
            result = try engine.calculate(
                .init(
                    reactantFeedAmount:
                        try InputValidator.parseNumber(
                            feedInput,
                            fieldName:
                                "reactant feed"
                        ),
                    reactantOutletAmount:
                        try InputValidator.parseNumber(
                            outletInput,
                            fieldName:
                                "reactant outlet"
                        ),
                    desiredProductAmount:
                        try InputValidator.parseNumber(
                            desiredInput,
                            fieldName:
                                "desired product"
                        ),
                    undesiredProductAmount:
                        try InputValidator.parseNumber(
                            undesiredInput,
                            fieldName:
                                "undesired product"
                        )
                )
            )
        } catch {
            errorMessage =
                error.localizedDescription
        }
    }

    private func loadExample() {
        feedInput = "100"
        outletInput = "20"
        desiredInput = "60"
        undesiredInput = "20"
        result = nil
        errorMessage = ""
    }

    private func resetInputs() {
        feedInput = ""
        outletInput = ""
        desiredInput = ""
        undesiredInput = ""
        result = nil
        errorMessage = ""
    }
}

#Preview {
    NavigationStack {
        ReactionPerformanceBalanceView()
    }
}
