import SwiftUI

struct ActivationEnergyTwoPointView:
    View {

    @State private var temperatureOneInput = "300"
    @State private var rateConstantOneInput = "0.1"
    @State private var temperatureTwoInput = "350"
    @State private var rateConstantTwoInput = "1.752498367"

    @State private var result:
        ActivationEnergyTwoPointResult?

    @State private var errorMessage = ""

    private let engine =
        ActivationEnergyTwoPointEngine()

    private let numberFormatter =
        NumberFormatterService.precise

    var body: some View {
        ScrollView {
            VStack(spacing: AppSpacing.xLarge) {
                ModuleHeaderView(
                    symbolName: "chart.line.uptrend.xyaxis",
                    title: "Activation Energy from Two Temperatures",
                    subtitle:
                        "Determine Eₐ and A from two rate constants",
                    tint: .orange
                )

                CalculatorInfoCard(tint: .orange) {
                    VStack(spacing: AppSpacing.small) {
                        Text("Two-Point Arrhenius Relation")
                            .font(.headline)

                        Text(
                            "ln(k₂/k₁) = −Eₐ/R (1/T₂ − 1/T₁)"
                        )
                        .font(
                            .system(
                                size: 16,
                                weight: .semibold
                            )
                        )
                        .minimumScaleFactor(0.45)

                        Text(
                            "Both rate constants must correspond to the same reaction and kinetic basis."
                        )
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

                CalculatorCard {
                    VStack(
                        alignment: .leading,
                        spacing: AppSpacing.large
                    ) {
                        Text("Point 1")
                            .font(.headline)

                        EngineeringInputField(
                            title: "Temperature 1",
                            symbol: "T₁",
                            unit: "K",
                            placeholder: "Example: 300",
                            text: $temperatureOneInput
                        )

                        EngineeringInputField(
                            title: "Rate Constant 1",
                            symbol: "k₁",
                            unit: "consistent",
                            placeholder: "Example: 0.1",
                            text: $rateConstantOneInput
                        )

                        Divider()

                        Text("Point 2")
                            .font(.headline)

                        EngineeringInputField(
                            title: "Temperature 2",
                            symbol: "T₂",
                            unit: "K",
                            placeholder: "Example: 350",
                            text: $temperatureTwoInput
                        )

                        EngineeringInputField(
                            title: "Rate Constant 2",
                            symbol: "k₂",
                            unit: "consistent",
                            placeholder: "Example: 1.752498367",
                            text: $rateConstantTwoInput
                        )

                        HStack(spacing: AppSpacing.medium) {
                            Button(action: loadExample) {
                                Label(
                                    "Load Example",
                                    systemImage: "arrow.counterclockwise"
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
                            title: "Calculate Activation Energy",
                            systemImage:
                                "chart.line.uptrend.xyaxis",
                            action: calculate
                        )

                        if let result {
                            VStack(spacing: AppSpacing.large) {
                                CalculationResultCard(
                                    items: [
                                        .init(
                                            label: "Activation Energy",
                                            value: numberFormatter.format(
                                                result.activationEnergyKilojoulesPerMole
                                            ),
                                            unit: "kJ/mol"
                                        ),
                                        .init(
                                            label: "A from Point 1",
                                            value: numberFormatter.format(
                                                result.preExponentialFactorFromPointOne
                                            ),
                                            unit: "same units as k"
                                        ),
                                        .init(
                                            label: "A from Point 2",
                                            value: numberFormatter.format(
                                                result.preExponentialFactorFromPointTwo
                                            ),
                                            unit: "same units as k"
                                        ),
                                        .init(
                                            label: "Average A",
                                            value: numberFormatter.format(
                                                result.averagePreExponentialFactor
                                            ),
                                            unit: "same units as k"
                                        ),
                                        .init(
                                            label: "Relative A Mismatch",
                                            value: numberFormatter.format(
                                                100
                                                * result.relativePreExponentialMismatch
                                            ),
                                            unit: "%"
                                        )
                                    ],
                                    tint: .orange
                                )

                                CalculatorInfoCard(tint: .orange) {
                                    VStack(
                                        alignment: .leading,
                                        spacing: AppSpacing.small
                                    ) {
                                        Text(result.trendDescription)
                                            .font(.headline)

                                        Divider()

                                        Text(result.modelName)
                                            .foregroundStyle(.secondary)
                                    }
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
                AppTheme.Layout.pageHorizontalPadding
            )
            .padding(
                .vertical,
                AppTheme.Layout.pageVerticalPadding
            )
        }
        .navigationTitle("Activation Energy")
    }

    private func calculate() {
        result = nil
        errorMessage = ""

        do {
            result = try engine.calculate(
                .init(
                    temperatureOne:
                        try InputValidator.parseNumber(
                            temperatureOneInput,
                            fieldName: "temperature one"
                        ),
                    rateConstantOne:
                        try InputValidator.parseNumber(
                            rateConstantOneInput,
                            fieldName: "rate constant one"
                        ),
                    temperatureTwo:
                        try InputValidator.parseNumber(
                            temperatureTwoInput,
                            fieldName: "temperature two"
                        ),
                    rateConstantTwo:
                        try InputValidator.parseNumber(
                            rateConstantTwoInput,
                            fieldName: "rate constant two"
                        )
                )
            )
        } catch {
            errorMessage = error.localizedDescription
        }
    }

    private func loadExample() {
        temperatureOneInput = "300"
        rateConstantOneInput = "0.1"
        temperatureTwoInput = "350"
        rateConstantTwoInput = "1.752498367"
        result = nil
        errorMessage = ""
    }

    private func resetInputs() {
        temperatureOneInput = ""
        rateConstantOneInput = ""
        temperatureTwoInput = ""
        rateConstantTwoInput = ""
        result = nil
        errorMessage = ""
    }
}

#Preview {
    NavigationStack {
        ActivationEnergyTwoPointView()
    }
}
