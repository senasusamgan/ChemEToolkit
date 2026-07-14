import SwiftUI

struct ConvectionHeatTransferView: View {

    @State
    private var heatTransferCoefficientInput =
        "25"

    @State
    private var areaInput = "4"

    @State
    private var surfaceTemperatureInput = "80"

    @State
    private var fluidTemperatureInput = "20"

    @State
    private var result:
        ConvectionHeatTransferResult?

    @State
    private var errorMessage = ""

    private let engine =
        ConvectionHeatTransferEngine()

    private let numberFormatter =
        NumberFormatterService.precise

    var body: some View {
        ScrollView {
            VStack(spacing: AppSpacing.xLarge) {
                ModuleHeaderView(
                    symbolName: "wind",
                    title:
                        "Convection Heat Transfer",
                    subtitle:
                        "Heat transfer between a surface and a moving fluid",
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
            "Convection Heat Transfer"
        )
    }

    private var formulaCard: some View {
        CalculatorInfoCard(tint: .orange) {
            VStack(spacing: AppSpacing.small) {
                Text(
                    "Newton’s Law of Cooling"
                )
                .font(.headline)

                Text(
                    "Q̇ = hA(Tₛ − T∞)"
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
                    Calculates convection heat transfer \
                    between a surface and the surrounding \
                    fluid.
                    """
                )
                .foregroundStyle(.secondary)
                .multilineTextAlignment(.center)

                Text(
                    """
                    A positive result represents heat flow \
                    from the surface to the fluid.
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
            Text("Convection Properties")
                .font(.headline)

            EngineeringInputField(
                title:
                    "Heat-Transfer Coefficient",
                symbol: "h",
                unit: "W/(m²·K)",
                placeholder: "Example: 25",
                text:
                    $heatTransferCoefficientInput
            )

            EngineeringInputField(
                title:
                    "Heat-Transfer Area",
                symbol: "A",
                unit: "m²",
                placeholder: "Example: 4",
                text: $areaInput
            )

            Divider()

            Text("Temperatures")
                .font(.headline)

            EngineeringInputField(
                title: "Surface Temperature",
                symbol: "Tₛ",
                unit: "°C",
                placeholder: "Example: 80",
                text:
                    $surfaceTemperatureInput
            )

            EngineeringInputField(
                title: "Fluid Temperature",
                symbol: "T∞",
                unit: "°C",
                placeholder: "Example: 20",
                text:
                    $fluidTemperatureInput
            )

            actionButtons

            PrimaryActionButton(
                title:
                    "Calculate Convection",
                systemImage: "wind",
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
            ConvectionHeatTransferResult
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
                            "Heat Transfer Magnitude",
                        value:
                            numberFormatter.format(
                                result
                                    .heatTransferRateMagnitude
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
                            "Convection Resistance",
                        value:
                            numberFormatter.format(
                                result
                                    .thermalResistance
                            ),
                        unit: "K/W"
                    )
                ],
                tint:
                    resultColor(
                        for: result.direction
                    )
            )

            interpretationCard(result)
        }
    }

    private func interpretationCard(
        _ result:
            ConvectionHeatTransferResult
    ) -> some View {
        CalculatorInfoCard(
            tint:
                resultColor(
                    for: result.direction
                )
        ) {
            VStack(
                alignment: .leading,
                spacing: AppSpacing.small
            ) {
                Label(
                    "Heat-Flow Interpretation",
                    systemImage:
                        directionSymbol(
                            for: result.direction
                        )
                )
                .font(.headline)

                Divider()

                informationRow(
                    title: "Direction",
                    value:
                        result.direction.description
                )

                informationRow(
                    title:
                        "Temperature Difference",
                    value:
                        "\(numberFormatter.format(result.temperatureDifference)) K"
                )

                informationRow(
                    title:
                        "Sign Convention",
                    value:
                        signDescription(
                            for: result
                        )
                )

                Text(
                    interpretationText(
                        for: result.direction
                    )
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

    private func resultColor(
        for direction:
            ConvectionHeatFlowDirection
    ) -> Color {
        switch direction {
        case .surfaceToFluid:
            return .orange

        case .fluidToSurface:
            return .blue

        case .equilibrium:
            return .green
        }
    }

    private func directionSymbol(
        for direction:
            ConvectionHeatFlowDirection
    ) -> String {
        switch direction {
        case .surfaceToFluid:
            return "arrow.right"

        case .fluidToSurface:
            return "arrow.left"

        case .equilibrium:
            return "equal"
        }
    }

    private func signDescription(
        for result:
            ConvectionHeatTransferResult
    ) -> String {
        if result.heatTransferRate > 0 {
            return "Positive heat rate"
        }

        if result.heatTransferRate < 0 {
            return "Negative heat rate"
        }

        return "Zero heat rate"
    }

    private func interpretationText(
        for direction:
            ConvectionHeatFlowDirection
    ) -> String {
        switch direction {
        case .surfaceToFluid:
            return """
            The surface is hotter than the fluid, \
            so thermal energy is transferred from \
            the surface into the fluid.
            """

        case .fluidToSurface:
            return """
            The fluid is hotter than the surface, \
            so thermal energy is transferred from \
            the fluid into the surface.
            """

        case .equilibrium:
            return """
            The surface and fluid temperatures are \
            equal, so there is no net convection \
            heat transfer.
            """
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
        -> ConvectionHeatTransferInput {

        let heatTransferCoefficient =
            try InputValidator.parseNumber(
                heatTransferCoefficientInput,
                fieldName:
                    "heat-transfer coefficient"
            )

        let area =
            try InputValidator.parseNumber(
                areaInput,
                fieldName:
                    "heat-transfer area"
            )

        let surfaceTemperature =
            try InputValidator.parseNumber(
                surfaceTemperatureInput,
                fieldName:
                    "surface temperature"
            )

        let fluidTemperature =
            try InputValidator.parseNumber(
                fluidTemperatureInput,
                fieldName:
                    "fluid temperature"
            )

        return ConvectionHeatTransferInput(
            heatTransferCoefficient:
                heatTransferCoefficient,
            area: area,
            surfaceTemperature:
                surfaceTemperature,
            fluidTemperature:
                fluidTemperature
        )
    }

    private func loadExample() {
        heatTransferCoefficientInput = "25"
        areaInput = "4"
        surfaceTemperatureInput = "80"
        fluidTemperatureInput = "20"

        clearResult()
    }

    private func resetInputs() {
        heatTransferCoefficientInput = ""
        areaInput = ""
        surfaceTemperatureInput = ""
        fluidTemperatureInput = ""

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
        ConvectionHeatTransferView()
    }
}
