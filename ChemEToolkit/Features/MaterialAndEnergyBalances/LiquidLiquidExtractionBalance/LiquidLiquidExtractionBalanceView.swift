import SwiftUI

struct LiquidLiquidExtractionBalanceView:
    View {

    @State private var feedInput = "100"
    @State private var soluteFractionInput = "0.10"
    @State private var solventInput = "50"
    @State private var distributionInput = "2"

    @State private var result:
        LiquidLiquidExtractionBalanceResult?

    @State private var errorMessage = ""

    private let engine =
        LiquidLiquidExtractionBalanceEngine()

    private let numberFormatter =
        NumberFormatterService.precise

    var body: some View {
        ScrollView {
            VStack(spacing: AppSpacing.xLarge) {
                ModuleHeaderView(
                    symbolName: "square.split.2x1.fill",
                    title: "Liquid–Liquid Extraction Balance",
                    subtitle: "Calculate one ideal equilibrium extraction stage",
                    tint: .teal
                )

                CalculatorInfoCard(tint: .teal) {
                    Text("A constant distribution coefficient partitions dilute solute between immiscible carrier and solvent phases.")
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
                            title: "Feed Solution Mass",
                            symbol: "F",
                            unit: "kg",
                            placeholder: "100",
                            text: $feedInput
                        )

                        EngineeringInputField(
                            title: "Feed Solute Fraction",
                            symbol: "w_F",
                            unit: "—",
                            placeholder: "0.10",
                            text: $soluteFractionInput
                        )

                        EngineeringInputField(
                            title: "Pure Solvent Mass",
                            symbol: "S",
                            unit: "kg",
                            placeholder: "50",
                            text: $solventInput
                        )

                        EngineeringInputField(
                            title: "Distribution Coefficient",
                            symbol: "K_D",
                            unit: "—",
                            placeholder: "2",
                            text: $distributionInput
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
                            systemImage: "square.split.2x1.fill",
                            action: calculate
                        )

                        if let result {
                            CalculationResultCard(
                                items: [
                                    .init(
                                        label: "Initial Solute Mass",
                                        value: numberFormatter.format(result.initialSoluteMass),
                                        unit: "kg"
                                    ),
.init(
                                        label: "Raffinate Solute Mass",
                                        value: numberFormatter.format(result.raffinateSoluteMass),
                                        unit: "kg"
                                    ),
.init(
                                        label: "Extract Solute Mass",
                                        value: numberFormatter.format(result.extractSoluteMass),
                                        unit: "kg"
                                    ),
.init(
                                        label: "Raffinate Total Mass",
                                        value: numberFormatter.format(result.raffinateTotalMass),
                                        unit: "kg"
                                    ),
.init(
                                        label: "Extract Total Mass",
                                        value: numberFormatter.format(result.extractTotalMass),
                                        unit: "kg"
                                    ),
.init(
                                        label: "Single-Stage Extraction",
                                        value: numberFormatter.format(100 * result.extractionFraction),
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
        .navigationTitle("Liquid–Liquid Extraction Balance")
    }

    private func calculate() {
        result = nil
        errorMessage = ""

        do {
            result = try engine.calculate(
                .init(
                    feedSolutionMass:
                        try InputValidator.parseNumber(
                            feedInput,
                            fieldName:
                                "feed solution mass"
                        ),
                    feedSoluteMassFraction:
                        try InputValidator.parseNumber(
                            soluteFractionInput,
                            fieldName:
                                "feed solute fraction"
                        ),
                    pureSolventMass:
                        try InputValidator.parseNumber(
                            solventInput,
                            fieldName:
                                "pure solvent mass"
                        ),
                    distributionCoefficient:
                        try InputValidator.parseNumber(
                            distributionInput,
                            fieldName:
                                "distribution coefficient"
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
        soluteFractionInput = "0.10"
        solventInput = "50"
        distributionInput = "2"
        result = nil
        errorMessage = ""
    }

    private func resetInputs() {
        feedInput = ""
        soluteFractionInput = ""
        solventInput = ""
        distributionInput = ""
        result = nil
        errorMessage = ""
    }
}

#Preview {
    NavigationStack {
        LiquidLiquidExtractionBalanceView()
    }
}
