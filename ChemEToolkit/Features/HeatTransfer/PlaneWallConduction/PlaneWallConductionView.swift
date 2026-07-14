import SwiftUI

struct PlaneWallConductionView: View {

    @State
    private var thermalConductivityInput = "0.8"

    @State
    private var areaInput = "10"

    @State
    private var wallThicknessInput = "0.2"

    @State
    private var hotSideTemperatureInput = "100"

    @State
    private var coldSideTemperatureInput = "20"

    @State
    private var result:
        PlaneWallConductionResult?

    @State
    private var errorMessage = ""

    private let engine =
        PlaneWallConductionEngine()

    private let numberFormatter =
        NumberFormatterService.precise

    var body: some View {
        ScrollView {
            VStack(spacing: AppSpacing.xLarge) {
                ModuleHeaderView(
                    symbolName:
                        "square.stack.3d.up.fill",
                    title:
                        "Plane Wall Conduction",
                    subtitle:
                        "Steady-state one-dimensional heat conduction",
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
            "Plane Wall Conduction"
        )
    }

    private var formulaCard: some View {
        CalculatorInfoCard(tint: .orange) {
            VStack(spacing: AppSpacing.small) {
                Text("Fourier’s Law")
                    .font(.headline)

                Text(
                    "Q̇ = kA(Tₕ − T𝚌) / L"
                )
                .font(
                    .system(
                        size: 22,
                        weight: .semibold
                    )
                )
                .multilineTextAlignment(.center)
                .minimumScaleFactor(0.7)

                Text(
                    """
                    Calculates steady-state heat transfer \
                    through a homogeneous plane wall.
                    """
                )
                .foregroundStyle(.secondary)
                .multilineTextAlignment(.center)

                Text(
                    """
                    Assumes constant thermal conductivity, \
                    no internal heat generation and \
                    one-dimensional conduction.
                    """
                )
                .font(.caption)
                .foregroundStyle(.secondary)
                .multilineTextAlignment(.center)
            }
            .frame(
                maxWidth: .infinity,
                alignment: .center
            )
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
            Text("Wall Properties")
                .font(.headline)

            EngineeringInputField(
                title: "Thermal Conductivity",
                symbol: "k",
                unit: "W/(m·K)",
                placeholder: "Example: 0.8",
                text:
                    $thermalConductivityInput
            )

            EngineeringInputField(
                title: "Wall Area",
                symbol: "A",
                unit: "m²",
                placeholder: "Example: 10",
                text: $areaInput
            )

            EngineeringInputField(
                title: "Wall Thickness",
                symbol: "L",
                unit: "m",
                placeholder: "Example: 0.2",
                text: $wallThicknessInput
            )

            Divider()

            Text("Boundary Temperatures")
                .font(.headline)

            EngineeringInputField(
                title: "Hot-Side Temperature",
                symbol: "Tₕ",
                unit: "°C",
                placeholder: "Example: 100",
                text:
                    $hotSideTemperatureInput
            )

            EngineeringInputField(
                title: "Cold-Side Temperature",
                symbol: "T𝚌",
                unit: "°C",
                placeholder: "Example: 20",
                text:
                    $coldSideTemperatureInput
            )

            actionButtons

            PrimaryActionButton(
                title: "Calculate Conduction",
                systemImage:
                    "flame.fill",
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

    private var loadExampleButton:
        some View {
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
            PlaneWallConductionResult
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
                        label: "Heat Flux",
                        value:
                            numberFormatter.format(
                                result.heatFlux
                            ),
                        unit: "W/m²"
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
                            "Temperature Difference",
                        value:
                            numberFormatter.format(
                                result
                                    .temperatureDifference
                            ),
                        unit: "K"
                    )
                ],
                tint: .orange
            )

            interpretationCard(result)
        }
    }

    private func interpretationCard(
        _ result:
            PlaneWallConductionResult
    ) -> some View {
        CalculatorInfoCard(tint: .orange) {
            VStack(
                alignment: .leading,
                spacing: AppSpacing.small
            ) {
                Label(
                    "Engineering Interpretation",
                    systemImage:
                        "lightbulb.fill"
                )
                .font(.headline)

                Divider()

                informationRow(
                    title: "Heat-Flow Direction",
                    value:
                        "Hot side → Cold side"
                )

                informationRow(
                    title: "Conduction Equation",
                    value: "Q̇ = ΔT / R"
                )

                informationRow(
                    title: "Wall Resistance",
                    value:
                        "\(numberFormatter.format(result.thermalResistance)) K/W"
                )

                Text(
                    """
                    A lower wall resistance produces a \
                    greater heat-transfer rate for the \
                    same temperature difference.
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
        -> PlaneWallConductionInput {

        let thermalConductivity =
            try InputValidator.parseNumber(
                thermalConductivityInput,
                fieldName:
                    "thermal conductivity"
            )

        let area =
            try InputValidator.parseNumber(
                areaInput,
                fieldName: "wall area"
            )

        let wallThickness =
            try InputValidator.parseNumber(
                wallThicknessInput,
                fieldName:
                    "wall thickness"
            )

        let hotSideTemperature =
            try InputValidator.parseNumber(
                hotSideTemperatureInput,
                fieldName:
                    "hot-side temperature"
            )

        let coldSideTemperature =
            try InputValidator.parseNumber(
                coldSideTemperatureInput,
                fieldName:
                    "cold-side temperature"
            )

        return PlaneWallConductionInput(
            thermalConductivity:
                thermalConductivity,
            area: area,
            wallThickness: wallThickness,
            hotSideTemperature:
                hotSideTemperature,
            coldSideTemperature:
                coldSideTemperature
        )
    }

    private func loadExample() {
        thermalConductivityInput = "0.8"
        areaInput = "10"
        wallThicknessInput = "0.2"
        hotSideTemperatureInput = "100"
        coldSideTemperatureInput = "20"

        clearResult()
    }

    private func resetInputs() {
        thermalConductivityInput = ""
        areaInput = ""
        wallThicknessInput = ""
        hotSideTemperatureInput = ""
        coldSideTemperatureInput = ""

        clearResult()
    }

    private func showCalculationError(
        _ error: CalculationError
    ) {
        let description =
            error.errorDescription ??
            """
            The entered values could not \
            be processed.
            """

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
        PlaneWallConductionView()
    }
}
