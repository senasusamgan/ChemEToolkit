import SwiftUI

struct ArrheniusRateConstantView:
    View {

    @State private var preExponentialInput = "10000000"
    @State private var activationEnergyInput = "50000"
    @State private var temperatureInput = "350"

    @State private var result:
        ArrheniusRateConstantResult?

    @State private var errorMessage = ""

    private let engine =
        ArrheniusRateConstantEngine()

    private let numberFormatter =
        NumberFormatterService.precise

    var body: some View {
        ScrollView {
            VStack(spacing: AppSpacing.xLarge) {
                ModuleHeaderView(
                    symbolName: "thermometer.medium",
                    title: "Arrhenius Rate Constant",
                    subtitle:
                        "Calculate k from A, activation energy and temperature",
                    tint: .orange
                )

                CalculatorInfoCard(tint: .orange) {
                    VStack(spacing: AppSpacing.small) {
                        Text("Arrhenius Equation")
                            .font(.headline)

                        Text("k = A exp(−Eₐ/RT)")
                            .font(
                                .system(
                                    size: 21,
                                    weight: .semibold
                                )
                            )

                        Text(
                            "Activation energy is entered in J/mol and temperature in kelvin."
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
                        EngineeringInputField(
                            title: "Pre-Exponential Factor",
                            symbol: "A",
                            unit: "same units as k",
                            placeholder: "Example: 10000000",
                            text: $preExponentialInput
                        )

                        EngineeringInputField(
                            title: "Activation Energy",
                            symbol: "Eₐ",
                            unit: "J/mol",
                            placeholder: "Example: 50000",
                            text: $activationEnergyInput
                        )

                        EngineeringInputField(
                            title: "Temperature",
                            symbol: "T",
                            unit: "K",
                            placeholder: "Example: 350",
                            text: $temperatureInput
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
                            title: "Calculate Rate Constant",
                            systemImage: "thermometer.medium",
                            action: calculate
                        )

                        if let result {
                            VStack(spacing: AppSpacing.large) {
                                CalculationResultCard(
                                    items: [
                                        .init(
                                            label: "Rate Constant",
                                            value: numberFormatter.format(
                                                result.rateConstant
                                            ),
                                            unit: "same units as A"
                                        ),
                                        .init(
                                            label: "Exponential Factor",
                                            value: numberFormatter.format(
                                                result.exponentialFactor
                                            ),
                                            unit: "—"
                                        ),
                                        .init(
                                            label: "Eₐ / RT",
                                            value: numberFormatter.format(
                                                result.activationEnergyOverRT
                                            ),
                                            unit: "—"
                                        ),
                                        .init(
                                            label: "ln(k)",
                                            value: numberFormatter.format(
                                                result.naturalLogRateConstant
                                            ),
                                            unit: "—"
                                        ),
                                        .init(
                                            label: "d ln(k) / dT",
                                            value: numberFormatter.format(
                                                result.temperatureSensitivity
                                            ),
                                            unit: "1/K"
                                        ),
                                        .init(
                                            label: "Temperature for 2× k",
                                            value: numberFormatter.format(
                                                result.temperatureForDoubleRateApproximation
                                            ),
                                            unit: "K"
                                        )
                                    ],
                                    tint: .orange
                                )

                                CalculatorInfoCard(tint: .orange) {
                                    VStack(
                                        alignment: .leading,
                                        spacing: AppSpacing.small
                                    ) {
                                        Text(result.modelName)
                                            .font(.headline)

                                        Divider()

                                        Text(
                                            result.limitationDescription
                                        )
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
        .navigationTitle("Arrhenius Equation")
    }

    private func calculate() {
        result = nil
        errorMessage = ""

        do {
            result = try engine.calculate(
                .init(
                    preExponentialFactor:
                        try InputValidator.parseNumber(
                            preExponentialInput,
                            fieldName: "pre-exponential factor"
                        ),
                    activationEnergy:
                        try InputValidator.parseNumber(
                            activationEnergyInput,
                            fieldName: "activation energy"
                        ),
                    temperature:
                        try InputValidator.parseNumber(
                            temperatureInput,
                            fieldName: "temperature"
                        )
                )
            )
        } catch {
            errorMessage = error.localizedDescription
        }
    }

    private func loadExample() {
        preExponentialInput = "10000000"
        activationEnergyInput = "50000"
        temperatureInput = "350"
        result = nil
        errorMessage = ""
    }

    private func resetInputs() {
        preExponentialInput = ""
        activationEnergyInput = ""
        temperatureInput = ""
        result = nil
        errorMessage = ""
    }
}

#Preview {
    NavigationStack {
        ArrheniusRateConstantView()
    }
}
