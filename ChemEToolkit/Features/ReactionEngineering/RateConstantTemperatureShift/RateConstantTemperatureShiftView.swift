import SwiftUI

struct RateConstantTemperatureShiftView:
    View {

    @State private var referenceRateConstantInput = "0.1"
    @State private var referenceTemperatureInput = "300"
    @State private var targetTemperatureInput = "350"
    @State private var activationEnergyInput = "50000"

    @State private var result:
        RateConstantTemperatureShiftResult?

    @State private var errorMessage = ""

    private let engine =
        RateConstantTemperatureShiftEngine()

    private let numberFormatter =
        NumberFormatterService.precise

    var body: some View {
        ScrollView {
            VStack(spacing: AppSpacing.xLarge) {
                ModuleHeaderView(
                    symbolName: "arrow.up.right.circle.fill",
                    title: "Rate Constant Temperature Shift",
                    subtitle:
                        "Predict k at a new temperature from a reference value",
                    tint: .orange
                )

                CalculatorInfoCard(tint: .orange) {
                    VStack(spacing: AppSpacing.small) {
                        Text("Reference-Temperature Arrhenius Form")
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
                            "No explicit pre-exponential factor is required."
                        )
                        .foregroundStyle(.secondary)
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
                            title: "Reference Rate Constant",
                            symbol: "k₁",
                            unit: "consistent",
                            placeholder: "Example: 0.1",
                            text: $referenceRateConstantInput
                        )

                        EngineeringInputField(
                            title: "Reference Temperature",
                            symbol: "T₁",
                            unit: "K",
                            placeholder: "Example: 300",
                            text: $referenceTemperatureInput
                        )

                        EngineeringInputField(
                            title: "Target Temperature",
                            symbol: "T₂",
                            unit: "K",
                            placeholder: "Example: 350",
                            text: $targetTemperatureInput
                        )

                        EngineeringInputField(
                            title: "Activation Energy",
                            symbol: "Eₐ",
                            unit: "J/mol",
                            placeholder: "Example: 50000",
                            text: $activationEnergyInput
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
                            title: "Predict Target k",
                            systemImage:
                                "arrow.up.right.circle.fill",
                            action: calculate
                        )

                        if let result {
                            VStack(spacing: AppSpacing.large) {
                                CalculationResultCard(
                                    items: [
                                        .init(
                                            label: "Target Rate Constant",
                                            value: numberFormatter.format(
                                                result.targetRateConstant
                                            ),
                                            unit: "same units as k₁"
                                        ),
                                        .init(
                                            label: "k₂ / k₁",
                                            value: numberFormatter.format(
                                                result.rateConstantRatio
                                            ),
                                            unit: "—"
                                        ),
                                        .init(
                                            label: "ln(k₂ / k₁)",
                                            value: numberFormatter.format(
                                                result.naturalLogRateRatio
                                            ),
                                            unit: "—"
                                        ),
                                        .init(
                                            label: "Rate-Constant Change",
                                            value: numberFormatter.format(
                                                result.percentRateConstantChange
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
        .navigationTitle("Temperature Shift")
    }

    private func calculate() {
        result = nil
        errorMessage = ""

        do {
            result = try engine.calculate(
                .init(
                    referenceRateConstant:
                        try InputValidator.parseNumber(
                            referenceRateConstantInput,
                            fieldName: "reference rate constant"
                        ),
                    referenceTemperature:
                        try InputValidator.parseNumber(
                            referenceTemperatureInput,
                            fieldName: "reference temperature"
                        ),
                    targetTemperature:
                        try InputValidator.parseNumber(
                            targetTemperatureInput,
                            fieldName: "target temperature"
                        ),
                    activationEnergy:
                        try InputValidator.parseNumber(
                            activationEnergyInput,
                            fieldName: "activation energy"
                        )
                )
            )
        } catch {
            errorMessage = error.localizedDescription
        }
    }

    private func loadExample() {
        referenceRateConstantInput = "0.1"
        referenceTemperatureInput = "300"
        targetTemperatureInput = "350"
        activationEnergyInput = "50000"
        result = nil
        errorMessage = ""
    }

    private func resetInputs() {
        referenceRateConstantInput = ""
        referenceTemperatureInput = ""
        targetTemperatureInput = ""
        activationEnergyInput = ""
        result = nil
        errorMessage = ""
    }
}

#Preview {
    NavigationStack {
        RateConstantTemperatureShiftView()
    }
}
