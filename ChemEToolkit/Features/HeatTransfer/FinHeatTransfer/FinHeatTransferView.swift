import SwiftUI

struct FinHeatTransferView: View {

    @State
    private var heatTransferCoefficientInput =
        "100"

    @State
    private var thermalConductivityInput =
        "100"

    @State private var finLengthInput = "0.1"
    @State private var finWidthInput = "0.01"
    @State private var finThicknessInput = "0.01"

    @State private var baseTemperatureInput = "100"
    @State private var ambientTemperatureInput = "20"

    @State
    private var result:
        FinHeatTransferResult?

    @State private var errorMessage = ""

    private let engine =
        FinHeatTransferEngine()

    private let numberFormatter =
        NumberFormatterService.precise

    var body: some View {
        ScrollView {
            VStack(spacing: AppSpacing.xLarge) {
                ModuleHeaderView(
                    symbolName:
                        "lines.measurement.horizontal",
                    title:
                        "Fin Efficiency & Heat Transfer",
                    subtitle:
                        "Straight rectangular fin with an adiabatic tip",
                    tint: .orange
                )

                formulaCard

                CalculatorCard {
                    calculatorContent
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
        .navigationTitle(
            "Fin Heat Transfer"
        )
    }

    private var formulaCard: some View {
        CalculatorInfoCard(tint: .orange) {
            VStack(spacing: AppSpacing.small) {
                Text("Adiabatic-Tip Straight Fin")
                    .font(.headline)

                Text("m = √(hP/kA𝚌)")
                    .font(
                        .system(
                            size: 20,
                            weight: .semibold
                        )
                    )

                Text(
                    "Q̇𝒇 = √(hPkA𝚌) ΔT tanh(mL)"
                )
                .font(
                    .system(
                        size: 18,
                        weight: .semibold
                    )
                )
                .multilineTextAlignment(.center)

                Text(
                    """
                    Calculates fin heat transfer, efficiency \
                    and effectiveness for a uniform \
                    rectangular cross-section.
                    """
                )
                .foregroundStyle(.secondary)
                .multilineTextAlignment(.center)
            }
            .frame(maxWidth: .infinity)
        }
        .frame(
            maxWidth:
                AppTheme.Layout.calculatorMaxWidth
        )
    }

    private var calculatorContent: some View {
        VStack(
            alignment: .leading,
            spacing: AppSpacing.large
        ) {
            Text("Material and Convection")
                .font(.headline)

            EngineeringInputField(
                title:
                    "Heat-Transfer Coefficient",
                symbol: "h",
                unit: "W/(m²·K)",
                placeholder: "Example: 100",
                text:
                    $heatTransferCoefficientInput
            )

            EngineeringInputField(
                title:
                    "Thermal Conductivity",
                symbol: "k",
                unit: "W/(m·K)",
                placeholder: "Example: 100",
                text:
                    $thermalConductivityInput
            )

            Divider()

            Text("Fin Geometry")
                .font(.headline)

            EngineeringInputField(
                title: "Fin Length",
                symbol: "L",
                unit: "m",
                placeholder: "Example: 0.1",
                text: $finLengthInput
            )

            EngineeringInputField(
                title: "Fin Width",
                symbol: "w",
                unit: "m",
                placeholder: "Example: 0.01",
                text: $finWidthInput
            )

            EngineeringInputField(
                title: "Fin Thickness",
                symbol: "t",
                unit: "m",
                placeholder: "Example: 0.01",
                text: $finThicknessInput
            )

            Divider()

            Text("Temperatures")
                .font(.headline)

            EngineeringInputField(
                title: "Base Temperature",
                symbol: "Tᵦ",
                unit: "°C",
                placeholder: "Example: 100",
                text: $baseTemperatureInput
            )

            EngineeringInputField(
                title: "Ambient Temperature",
                symbol: "T∞",
                unit: "°C",
                placeholder: "Example: 20",
                text:
                    $ambientTemperatureInput
            )

            actionButtons

            PrimaryActionButton(
                title: "Calculate Fin Performance",
                systemImage:
                    "lines.measurement.horizontal",
                action: calculate
            )

            if let result {
                resultSection(result)
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
        Button(action: resetInputs) {
            Label(
                "Clear",
                systemImage:
                    "arrow.counterclockwise"
            )
            .frame(maxWidth: .infinity)
        }
        .buttonStyle(.bordered)
    }

    private func resultSection(
        _ result: FinHeatTransferResult
    ) -> some View {
        VStack(spacing: AppSpacing.large) {
            CalculationResultCard(
                items: [
                    CalculationResultDisplayItem(
                        label:
                            "Fin Heat Transfer",
                        value:
                            numberFormatter.format(
                                result.heatTransferRate
                            ),
                        unit: "W"
                    ),
                    CalculationResultDisplayItem(
                        label: "Fin Efficiency",
                        value:
                            numberFormatter.format(
                                result.finEfficiency
                                * 100
                            ),
                        unit: "%"
                    ),
                    CalculationResultDisplayItem(
                        label:
                            "Fin Effectiveness",
                        value:
                            numberFormatter.format(
                                result.finEffectiveness
                            ),
                        unit: "—"
                    ),
                    CalculationResultDisplayItem(
                        label: "Fin Parameter",
                        value:
                            numberFormatter.format(
                                result.finParameter
                            ),
                        unit: "1/m"
                    )
                ],
                tint: .orange
            )

            CalculatorInfoCard(tint: .orange) {
                VStack(
                    alignment: .leading,
                    spacing: AppSpacing.small
                ) {
                    Label(
                        "Fin Geometry Summary",
                        systemImage:
                            "lines.measurement.horizontal"
                    )
                    .font(.headline)

                    Divider()

                    informationRow(
                        title:
                            "Cross-Sectional Area",
                        value:
                            "\(numberFormatter.format(result.crossSectionalArea)) m²"
                    )

                    informationRow(
                        title: "Perimeter",
                        value:
                            "\(numberFormatter.format(result.perimeter)) m"
                    )

                    informationRow(
                        title:
                            "Convecting Surface Area",
                        value:
                            "\(numberFormatter.format(result.finSurfaceArea)) m²"
                    )

                    informationRow(
                        title: "Dimensionless mL",
                        value:
                            numberFormatter.format(
                                result
                                    .dimensionlessFinParameter
                            )
                    )
                }
            }
        }
    }

    private func informationRow(
        title: String,
        value: String
    ) -> some View {
        HStack {
            Text(title)
                .foregroundStyle(.secondary)

            Spacer()

            Text(value)
                .fontWeight(.semibold)
                .multilineTextAlignment(.trailing)
        }
    }

    private func calculate() {
        clearResult()

        do {
            result =
                try engine.calculate(
                    input: try makeInput()
                )
        } catch let error
            as CalculationError {
            showCalculationError(error)
        } catch {
            errorMessage =
                error.localizedDescription
        }
    }

    private func makeInput() throws
        -> FinHeatTransferInput {

        FinHeatTransferInput(
            heatTransferCoefficient:
                try InputValidator.parseNumber(
                    heatTransferCoefficientInput,
                    fieldName:
                        "heat-transfer coefficient"
                ),
            thermalConductivity:
                try InputValidator.parseNumber(
                    thermalConductivityInput,
                    fieldName:
                        "thermal conductivity"
                ),
            finLength:
                try InputValidator.parseNumber(
                    finLengthInput,
                    fieldName: "fin length"
                ),
            finWidth:
                try InputValidator.parseNumber(
                    finWidthInput,
                    fieldName: "fin width"
                ),
            finThickness:
                try InputValidator.parseNumber(
                    finThicknessInput,
                    fieldName: "fin thickness"
                ),
            baseTemperature:
                try InputValidator.parseNumber(
                    baseTemperatureInput,
                    fieldName:
                        "base temperature"
                ),
            ambientTemperature:
                try InputValidator.parseNumber(
                    ambientTemperatureInput,
                    fieldName:
                        "ambient temperature"
                )
        )
    }

    private func loadExample() {
        heatTransferCoefficientInput = "100"
        thermalConductivityInput = "100"
        finLengthInput = "0.1"
        finWidthInput = "0.01"
        finThicknessInput = "0.01"
        baseTemperatureInput = "100"
        ambientTemperatureInput = "20"

        clearResult()
    }

    private func resetInputs() {
        heatTransferCoefficientInput = ""
        thermalConductivityInput = ""
        finLengthInput = ""
        finWidthInput = ""
        finThicknessInput = ""
        baseTemperatureInput = ""
        ambientTemperatureInput = ""

        clearResult()
    }

    private func showCalculationError(
        _ error: CalculationError
    ) {
        let description =
            error.errorDescription
            ?? "The entered values could not be processed."

        if let suggestion =
            error.recoverySuggestion {
            errorMessage =
                "\(description) \(suggestion)"
        } else {
            errorMessage = description
        }
    }

    private func clearResult() {
        result = nil
        errorMessage = ""
    }
}

#Preview {
    NavigationStack {
        FinHeatTransferView()
    }
}
