import SwiftUI

struct CompositeWallConductionView: View {

    @State private var areaInput = "2"
    @State private var hotTemperatureInput = "100"
    @State private var coldTemperatureInput = "40"
    @State private var layerCount = 2

    @State private var conductivity1Input = "0.5"
    @State private var thickness1Input = "0.1"

    @State private var conductivity2Input = "1"
    @State private var thickness2Input = "0.2"

    @State private var conductivity3Input = "0.04"
    @State private var thickness3Input = "0.05"

    @State
    private var result:
        CompositeWallConductionResult?

    @State private var errorMessage = ""

    private let engine =
        CompositeWallConductionEngine()

    private let numberFormatter =
        NumberFormatterService.precise

    var body: some View {
        ScrollView {
            VStack(spacing: AppSpacing.xLarge) {
                ModuleHeaderView(
                    symbolName:
                        "square.stack.3d.up.fill",
                    title:
                        "Composite Wall Conduction",
                    subtitle:
                        "Steady-state conduction through multiple wall layers",
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
            "Composite Wall Conduction"
        )
    }

    private var formulaCard: some View {
        CalculatorInfoCard(tint: .orange) {
            VStack(spacing: AppSpacing.small) {
                Text("Series Thermal Resistance")
                    .font(.headline)

                Text(
                    "Rₜ = Σ Lᵢ/(kᵢA)   •   Q̇ = ΔT/Rₜ"
                )
                .font(
                    .system(
                        size: 20,
                        weight: .semibold
                    )
                )
                .multilineTextAlignment(.center)
                .minimumScaleFactor(0.65)

                Text(
                    """
                    Calculates the total resistance, heat-transfer \
                    rate and interface temperatures for up to three \
                    solid wall layers in series.
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
            Text("Wall Configuration")
                .font(.headline)

            EngineeringInputField(
                title: "Wall Area",
                symbol: "A",
                unit: "m²",
                placeholder: "Example: 2",
                text: $areaInput
            )

            VStack(
                alignment: .leading,
                spacing: AppSpacing.small
            ) {
                Text("Number of Layers")
                    .font(.subheadline)
                    .fontWeight(.semibold)

                Picker(
                    "Number of Layers",
                    selection: $layerCount
                ) {
                    ForEach(1...3, id: \.self) {
                        count in

                        Text("\(count)")
                            .tag(count)
                    }
                }
                .pickerStyle(.segmented)
                .labelsHidden()
            }

            Divider()

            layerFields(
                number: 1,
                conductivity:
                    $conductivity1Input,
                thickness:
                    $thickness1Input
            )

            if layerCount >= 2 {
                Divider()

                layerFields(
                    number: 2,
                    conductivity:
                        $conductivity2Input,
                    thickness:
                        $thickness2Input
                )
            }

            if layerCount >= 3 {
                Divider()

                layerFields(
                    number: 3,
                    conductivity:
                        $conductivity3Input,
                    thickness:
                        $thickness3Input
                )
            }

            Divider()

            Text("Boundary Temperatures")
                .font(.headline)

            EngineeringInputField(
                title: "Hot-Side Temperature",
                symbol: "Tₕ",
                unit: "°C",
                placeholder: "Example: 100",
                text:
                    $hotTemperatureInput
            )

            EngineeringInputField(
                title: "Cold-Side Temperature",
                symbol: "T𝚌",
                unit: "°C",
                placeholder: "Example: 40",
                text:
                    $coldTemperatureInput
            )

            actionButtons

            PrimaryActionButton(
                title:
                    "Calculate Composite Wall",
                systemImage:
                    "square.stack.3d.up.fill",
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

    @ViewBuilder
    private func layerFields(
        number: Int,
        conductivity: Binding<String>,
        thickness: Binding<String>
    ) -> some View {
        VStack(
            alignment: .leading,
            spacing: AppSpacing.medium
        ) {
            Text("Layer \(number)")
                .font(.headline)

            EngineeringInputField(
                title:
                    "Thermal Conductivity",
                symbol: "k\(number)",
                unit: "W/(m·K)",
                placeholder:
                    "Layer \(number) conductivity",
                text: conductivity
            )

            EngineeringInputField(
                title: "Thickness",
                symbol: "L\(number)",
                unit: "m",
                placeholder:
                    "Layer \(number) thickness",
                text: thickness
            )
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
            CompositeWallConductionResult
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
                            "Total Resistance",
                        value:
                            numberFormatter.format(
                                result
                                    .totalThermalResistance
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

            ForEach(
                Array(
                    result.layerResults
                        .enumerated()
                ),
                id: \.offset
            ) { index, layer in
                layerResultCard(
                    number: index + 1,
                    result: layer
                )
            }
        }
    }

    private func layerResultCard(
        number: Int,
        result:
            CompositeWallLayerResult
    ) -> some View {
        CalculatorInfoCard(tint: .orange) {
            VStack(
                alignment: .leading,
                spacing: AppSpacing.small
            ) {
                Label(
                    "Layer \(number) Results",
                    systemImage:
                        "square.3.layers.3d"
                )
                .font(.headline)

                Divider()

                informationRow(
                    title: "Resistance",
                    value:
                        "\(numberFormatter.format(result.thermalResistance)) K/W"
                )

                informationRow(
                    title: "Temperature Drop",
                    value:
                        "\(numberFormatter.format(result.temperatureDrop)) K"
                )

                informationRow(
                    title: "Hot Boundary",
                    value:
                        "\(numberFormatter.format(result.hotSideTemperature)) °C"
                )

                informationRow(
                    title: "Cold Boundary",
                    value:
                        "\(numberFormatter.format(result.coldSideTemperature)) °C"
                )
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
        -> CompositeWallConductionInput {

        let area =
            try InputValidator.parseNumber(
                areaInput,
                fieldName: "wall area"
            )

        let hotTemperature =
            try InputValidator.parseNumber(
                hotTemperatureInput,
                fieldName:
                    "hot-side temperature"
            )

        let coldTemperature =
            try InputValidator.parseNumber(
                coldTemperatureInput,
                fieldName:
                    "cold-side temperature"
            )

        let rawLayers = [
            (
                conductivity1Input,
                thickness1Input
            ),
            (
                conductivity2Input,
                thickness2Input
            ),
            (
                conductivity3Input,
                thickness3Input
            )
        ]

        var layers:
            [CompositeWallLayer] = []

        for index in 0..<layerCount {
            let conductivity =
                try InputValidator.parseNumber(
                    rawLayers[index].0,
                    fieldName:
                        "layer \(index + 1) thermal conductivity"
                )

            let thickness =
                try InputValidator.parseNumber(
                    rawLayers[index].1,
                    fieldName:
                        "layer \(index + 1) thickness"
                )

            layers.append(
                CompositeWallLayer(
                    name: "Layer \(index + 1)",
                    thermalConductivity:
                        conductivity,
                    thickness: thickness
                )
            )
        }

        return CompositeWallConductionInput(
            area: area,
            hotSideTemperature:
                hotTemperature,
            coldSideTemperature:
                coldTemperature,
            layers: layers
        )
    }

    private func loadExample() {
        areaInput = "2"
        hotTemperatureInput = "100"
        coldTemperatureInput = "40"
        layerCount = 2

        conductivity1Input = "0.5"
        thickness1Input = "0.1"

        conductivity2Input = "1"
        thickness2Input = "0.2"

        conductivity3Input = "0.04"
        thickness3Input = "0.05"

        clearResult()
    }

    private func resetInputs() {
        areaInput = ""
        hotTemperatureInput = ""
        coldTemperatureInput = ""

        conductivity1Input = ""
        thickness1Input = ""

        conductivity2Input = ""
        thickness2Input = ""

        conductivity3Input = ""
        thickness3Input = ""

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
        CompositeWallConductionView()
    }
}
