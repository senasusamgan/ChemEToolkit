import SwiftUI

struct CylindricalWallConductionView: View {

    @State
    private var thermalConductivityInput =
        "15"

    @State private var innerRadiusInput =
        "0.05"

    @State private var outerRadiusInput =
        "0.1"

    @State private var cylinderLengthInput =
        "2"

    @State
    private var innerTemperatureInput =
        "100"

    @State
    private var outerTemperatureInput =
        "20"

    @State
    private var result:
        CylindricalWallConductionResult?

    @State private var errorMessage = ""

    private let engine =
        CylindricalWallConductionEngine()

    private let numberFormatter =
        NumberFormatterService.precise

    var body: some View {
        ScrollView {
            VStack(spacing: AppSpacing.xLarge) {
                ModuleHeaderView(
                    symbolName: "cylinder.fill",
                    title:
                        "Cylindrical Wall Conduction",
                    subtitle:
                        "Radial conduction through pipes and cylindrical walls",
                    tint: .orange
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
        .navigationTitle(
            "Cylindrical Wall Conduction"
        )
    }

    private var formulaCard: some View {
        CalculatorInfoCard(tint: .orange) {
            VStack(spacing: AppSpacing.small) {
                Text(
                    "Radial Fourier Conduction"
                )
                .font(.headline)

                Text(
                    "R = ln(rₒ/rᵢ)/(2πkL)"
                )
                .font(
                    .system(
                        size: 21,
                        weight: .semibold
                    )
                )

                Text(
                    "Q̇ = (Tᵢ − Tₒ)/R"
                )
                .font(
                    .system(
                        size: 19,
                        weight: .semibold
                    )
                )

                Text(
                    """
                    Calculates radial heat transfer through \
                    a homogeneous cylindrical wall.
                    """
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
    }

    private var calculatorContent: some View {
        VStack(
            alignment: .leading,
            spacing: AppSpacing.large
        ) {
            Text("Material and Geometry")
                .font(.headline)

            EngineeringInputField(
                title:
                    "Thermal Conductivity",
                symbol: "k",
                unit: "W/(m·K)",
                placeholder: "Example: 15",
                text:
                    $thermalConductivityInput
            )

            EngineeringInputField(
                title: "Inner Radius",
                symbol: "rᵢ",
                unit: "m",
                placeholder: "Example: 0.05",
                text: $innerRadiusInput
            )

            EngineeringInputField(
                title: "Outer Radius",
                symbol: "rₒ",
                unit: "m",
                placeholder: "Example: 0.1",
                text: $outerRadiusInput
            )

            EngineeringInputField(
                title: "Cylinder Length",
                symbol: "L",
                unit: "m",
                placeholder: "Example: 2",
                text: $cylinderLengthInput
            )

            Divider()

            Text("Surface Temperatures")
                .font(.headline)

            EngineeringInputField(
                title:
                    "Inner-Surface Temperature",
                symbol: "Tᵢ",
                unit: "°C",
                placeholder: "Example: 100",
                text:
                    $innerTemperatureInput
            )

            EngineeringInputField(
                title:
                    "Outer-Surface Temperature",
                symbol: "Tₒ",
                unit: "°C",
                placeholder: "Example: 20",
                text:
                    $outerTemperatureInput
            )

            actionButtons

            PrimaryActionButton(
                title:
                    "Calculate Radial Conduction",
                systemImage: "cylinder.fill",
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
        Button {
            loadExample()
        } label: {
            Label(
                "Load Example",
                systemImage: "doc.text"
            )
            .frame(maxWidth: .infinity)
        }
        .buttonStyle(.bordered)
    }

    private var clearButton: some View {
        Button {
            resetInputs()
        } label: {
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
        _ result:
            CylindricalWallConductionResult
    ) -> some View {
        VStack(spacing: AppSpacing.large) {
            CalculationResultCard(
                items: [
                    CalculationResultDisplayItem(
                        label:
                            "Heat Transfer Rate",
                        value:
                            numberFormatter.format(
                                result
                                    .heatTransferRate
                            ),
                        unit: "W"
                    ),
                    CalculationResultDisplayItem(
                        label:
                            "Thermal Resistance",
                        value:
                            numberFormatter.format(
                                result
                                    .thermalResistance
                            ),
                        unit: "K/W"
                    ),
                    CalculationResultDisplayItem(
                        label:
                            "Inner-Surface Heat Flux",
                        value:
                            numberFormatter.format(
                                result
                                    .innerSurfaceHeatFlux
                            ),
                        unit: "W/m²"
                    ),
                    CalculationResultDisplayItem(
                        label:
                            "Outer-Surface Heat Flux",
                        value:
                            numberFormatter.format(
                                result
                                    .outerSurfaceHeatFlux
                            ),
                        unit: "W/m²"
                    )
                ],
                tint: .orange
            )

            geometryCard(result)
        }
    }

    private func geometryCard(
        _ result:
            CylindricalWallConductionResult
    ) -> some View {
        CalculatorInfoCard(tint: .orange) {
            VStack(
                alignment: .leading,
                spacing: AppSpacing.small
            ) {
                Label(
                    "Cylindrical Geometry",
                    systemImage:
                        "cylinder.fill"
                )
                .font(.headline)

                Divider()

                informationRow(
                    title:
                        "Inner Surface Area",
                    value:
                        "\(numberFormatter.format(result.innerSurfaceArea)) m²"
                )

                informationRow(
                    title:
                        "Outer Surface Area",
                    value:
                        "\(numberFormatter.format(result.outerSurfaceArea)) m²"
                )

                informationRow(
                    title:
                        "Temperature Difference",
                    value:
                        "\(numberFormatter.format(result.temperatureDifference)) K"
                )

                Text(
                    """
                    The same heat-transfer rate passes through \
                    every radius, but heat flux decreases as \
                    cylindrical surface area increases.
                    """
                )
                .font(.caption)
                .foregroundStyle(.secondary)
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

    private func calculate() {
        clearResult()

        do {
            let input =
                try makeInput()

            result =
                try engine.calculate(
                    input: input
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
        -> CylindricalWallConductionInput {

        let thermalConductivity =
            try InputValidator.parseNumber(
                thermalConductivityInput,
                fieldName:
                    "thermal conductivity"
            )

        let innerRadius =
            try InputValidator.parseNumber(
                innerRadiusInput,
                fieldName: "inner radius"
            )

        let outerRadius =
            try InputValidator.parseNumber(
                outerRadiusInput,
                fieldName: "outer radius"
            )

        let cylinderLength =
            try InputValidator.parseNumber(
                cylinderLengthInput,
                fieldName:
                    "cylinder length"
            )

        let innerTemperature =
            try InputValidator.parseNumber(
                innerTemperatureInput,
                fieldName:
                    "inner-surface temperature"
            )

        let outerTemperature =
            try InputValidator.parseNumber(
                outerTemperatureInput,
                fieldName:
                    "outer-surface temperature"
            )

        return CylindricalWallConductionInput(
            thermalConductivity:
                thermalConductivity,
            innerRadius: innerRadius,
            outerRadius: outerRadius,
            cylinderLength: cylinderLength,
            innerSurfaceTemperature:
                innerTemperature,
            outerSurfaceTemperature:
                outerTemperature
        )
    }

    private func loadExample() {
        thermalConductivityInput = "15"
        innerRadiusInput = "0.05"
        outerRadiusInput = "0.1"
        cylinderLengthInput = "2"
        innerTemperatureInput = "100"
        outerTemperatureInput = "20"

        clearResult()
    }

    private func resetInputs() {
        thermalConductivityInput = ""
        innerRadiusInput = ""
        outerRadiusInput = ""
        cylinderLengthInput = ""
        innerTemperatureInput = ""
        outerTemperatureInput = ""

        clearResult()
    }

    private func showCalculationError(
        _ error: CalculationError
    ) {
        let description =
            error.errorDescription ??
            "The entered values could not be processed."

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
        CylindricalWallConductionView()
    }
}
