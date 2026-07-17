import SwiftUI

struct ClausiusClapeyronEstimatorView:
    View {

    @State private var referenceTemperatureInput = "373.15"
    @State private var referencePressureInput = "101.325"
    @State private var targetTemperatureInput = "353.15"
    @State private var latentHeatInput = "40.65"

    @State private var result:
        ClausiusClapeyronEstimatorResult?

    @State private var errorMessage = ""

    private let engine =
        ClausiusClapeyronEstimatorEngine()

    private let numberFormatter =
        NumberFormatterService.precise

    var body: some View {
        ScrollView {
            VStack(spacing: AppSpacing.xLarge) {
                ModuleHeaderView(
                    symbolName: "arrow.up.right.circle",
                    title: "Clausius–Clapeyron Estimator",
                    subtitle: "Estimate saturation pressure at a second temperature",
                    tint: .orange
                )

                CalculatorInfoCard(tint: .orange) {
                    Text("Use kelvin, positive reference pressure and molar latent heat in kJ/mol.")
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
                            title: "Reference Temperature",
                            symbol: "T₁",
                            unit: "K",
                            placeholder: "373.15",
                            text: $referenceTemperatureInput
                        )

                        EngineeringInputField(
                            title: "Reference Pressure",
                            symbol: "P₁",
                            unit: "kPa",
                            placeholder: "101.325",
                            text: $referencePressureInput
                        )

                        EngineeringInputField(
                            title: "Target Temperature",
                            symbol: "T₂",
                            unit: "K",
                            placeholder: "353.15",
                            text: $targetTemperatureInput
                        )

                        EngineeringInputField(
                            title: "Molar Latent Heat",
                            symbol: "ΔH_vap",
                            unit: "kJ/mol",
                            placeholder: "40.65",
                            text: $latentHeatInput
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
                            systemImage: "arrow.up.right.circle",
                            action: calculate
                        )

                        if let result {
                            CalculationResultCard(
                                items: [
                                    .init(
                                        label: "Target Pressure",
                                        value: numberFormatter.format(result.targetPressure),
                                        unit: "reference pressure unit"
                                    ),
.init(
                                        label: "Pressure Ratio, P₂/P₁",
                                        value: numberFormatter.format(result.pressureRatio),
                                        unit: "—"
                                    ),
.init(
                                        label: "ln(P₂/P₁)",
                                        value: numberFormatter.format(result.naturalLogPressureRatio),
                                        unit: "—"
                                    ),
.init(
                                        label: "1/T₂ − 1/T₁",
                                        value: numberFormatter.format(result.inverseTemperatureDifference),
                                        unit: "1/K"
                                    ),
.init(
                                        label: "Trend",
                                        value: result.trendDescription,
                                        unit: "—"
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
        .navigationTitle("Clausius–Clapeyron Estimator")
    }

    private func calculate() {
        result = nil
        errorMessage = ""

        do {
            result = try engine.calculate(
                .init(
                    referenceTemperatureKelvin:
                        try InputValidator.parseNumber(
                            referenceTemperatureInput,
                            fieldName:
                                "reference temperature"
                        ),
                    referencePressure:
                        try InputValidator.parseNumber(
                            referencePressureInput,
                            fieldName:
                                "reference pressure"
                        ),
                    targetTemperatureKelvin:
                        try InputValidator.parseNumber(
                            targetTemperatureInput,
                            fieldName:
                                "target temperature"
                        ),
                    molarLatentHeat:
                        try InputValidator.parseNumber(
                            latentHeatInput,
                            fieldName:
                                "molar latent heat"
                        )
                )
            )
        } catch {
            errorMessage =
                error.localizedDescription
        }
    }

    private func loadExample() {
        referenceTemperatureInput = "373.15"
        referencePressureInput = "101.325"
        targetTemperatureInput = "353.15"
        latentHeatInput = "40.65"
        result = nil
        errorMessage = ""
    }

    private func resetInputs() {
        referenceTemperatureInput = ""
        referencePressureInput = ""
        targetTemperatureInput = ""
        latentHeatInput = ""
        result = nil
        errorMessage = ""
    }
}

#Preview {
    NavigationStack {
        ClausiusClapeyronEstimatorView()
    }
}
