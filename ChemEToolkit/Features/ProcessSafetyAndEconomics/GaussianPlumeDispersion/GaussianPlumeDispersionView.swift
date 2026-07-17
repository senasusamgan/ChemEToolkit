import SwiftUI

struct GaussianPlumeDispersionView:
    View {

    @State private var sourceInput = "1"
    @State private var windInput = "5"
    @State private var crosswindInput = "0"
    @State private var receptorHeightInput = "1.5"
    @State private var releaseHeightInput = "10"
    @State private var sigmaYInput = "30"
    @State private var sigmaZInput = "15"

    @State private var result:
        GaussianPlumeDispersionResult?

    @State private var errorMessage = ""

    private let engine =
        GaussianPlumeDispersionEngine()

    private let numberFormatter =
        NumberFormatterService.precise

    var body: some View {
        ScrollView {
            VStack(spacing: AppSpacing.xLarge) {
                ModuleHeaderView(
                    symbolName: "wind.circle.fill",
                    title: "Gaussian Plume Dispersion",
                    subtitle: "Estimate continuous-release concentration at a receptor",
                    tint: .orange
                )

                CalculatorInfoCard(tint: .orange) {
                    Text("Enter externally selected horizontal and vertical dispersion coefficients for the receptor location.")
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
                            title: "Source Emission Rate",
                            symbol: "Q",
                            unit: "kg/s",
                            placeholder: "1",
                            text: $sourceInput
                        )

                        EngineeringInputField(
                            title: "Wind Speed",
                            symbol: "u",
                            unit: "m/s",
                            placeholder: "5",
                            text: $windInput
                        )

                        EngineeringInputField(
                            title: "Crosswind Distance",
                            symbol: "y",
                            unit: "m",
                            placeholder: "0",
                            text: $crosswindInput
                        )

                        EngineeringInputField(
                            title: "Receptor Height",
                            symbol: "z",
                            unit: "m",
                            placeholder: "1.5",
                            text: $receptorHeightInput
                        )

                        EngineeringInputField(
                            title: "Effective Release Height",
                            symbol: "H",
                            unit: "m",
                            placeholder: "10",
                            text: $releaseHeightInput
                        )

                        EngineeringInputField(
                            title: "Horizontal Dispersion Coefficient",
                            symbol: "σ_y",
                            unit: "m",
                            placeholder: "30",
                            text: $sigmaYInput
                        )

                        EngineeringInputField(
                            title: "Vertical Dispersion Coefficient",
                            symbol: "σ_z",
                            unit: "m",
                            placeholder: "15",
                            text: $sigmaZInput
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
                            systemImage: "wind.circle.fill",
                            action: calculate
                        )

                        if let result {
                            CalculationResultCard(
                                items: [
                                    .init(
                                        label: "Receptor Concentration",
                                        value: numberFormatter.format(result.receptorConcentration),
                                        unit: "kg/m³"
                                    ),
.init(
                                        label: "Receptor Concentration",
                                        value: numberFormatter.format(result.receptorConcentrationMilligramsPerCubicMeter),
                                        unit: "mg/m³"
                                    ),
.init(
                                        label: "Ground Centerline Concentration",
                                        value: numberFormatter.format(result.groundCenterlineConcentration),
                                        unit: "kg/m³"
                                    ),
.init(
                                        label: "Relative to Ground Centerline",
                                        value: numberFormatter.format(100 * result.relativeToGroundCenterline),
                                        unit: "%"
                                    ),
.init(
                                        label: "Crosswind Attenuation",
                                        value: numberFormatter.format(result.crosswindAttenuation),
                                        unit: "—"
                                    ),
.init(
                                        label: "Reflected Vertical Term",
                                        value: numberFormatter.format(result.reflectedVerticalTerm),
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
        .navigationTitle("Gaussian Plume Dispersion")
    }

    private func calculate() {
        result = nil
        errorMessage = ""

        do {
            result = try engine.calculate(
                .init(
                    sourceEmissionRate:
                        try InputValidator.parseNumber(
                            sourceInput,
                            fieldName:
                                "source emission rate"
                        ),
                    windSpeed:
                        try InputValidator.parseNumber(
                            windInput,
                            fieldName:
                                "wind speed"
                        ),
                    crosswindDistance:
                        try InputValidator.parseNumber(
                            crosswindInput,
                            fieldName:
                                "crosswind distance"
                        ),
                    receptorHeight:
                        try InputValidator.parseNumber(
                            receptorHeightInput,
                            fieldName:
                                "receptor height"
                        ),
                    effectiveReleaseHeight:
                        try InputValidator.parseNumber(
                            releaseHeightInput,
                            fieldName:
                                "effective release height"
                        ),
                    horizontalDispersionCoefficient:
                        try InputValidator.parseNumber(
                            sigmaYInput,
                            fieldName:
                                "horizontal dispersion coefficient"
                        ),
                    verticalDispersionCoefficient:
                        try InputValidator.parseNumber(
                            sigmaZInput,
                            fieldName:
                                "vertical dispersion coefficient"
                        )
                )
            )
        } catch {
            errorMessage =
                error.localizedDescription
        }
    }

    private func loadExample() {
        sourceInput = "1"
        windInput = "5"
        crosswindInput = "0"
        receptorHeightInput = "1.5"
        releaseHeightInput = "10"
        sigmaYInput = "30"
        sigmaZInput = "15"
        result = nil
        errorMessage = ""
    }

    private func resetInputs() {
        sourceInput = ""
        windInput = ""
        crosswindInput = ""
        receptorHeightInput = ""
        releaseHeightInput = ""
        sigmaYInput = ""
        sigmaZInput = ""
        result = nil
        errorMessage = ""
    }
}

#Preview {
    NavigationStack {
        GaussianPlumeDispersionView()
    }
}
