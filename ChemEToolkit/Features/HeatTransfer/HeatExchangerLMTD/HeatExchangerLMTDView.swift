import SwiftUI

struct HeatExchangerLMTDView: View {

    @State
    private var flowArrangement:
        HeatExchangerFlowArrangement =
            .counterFlow

    @State
    private var hotInletTemperatureInput = "150"

    @State
    private var hotOutletTemperatureInput = "90"

    @State
    private var coldInletTemperatureInput = "30"

    @State
    private var coldOutletTemperatureInput = "70"

    @State
    private var overallCoefficientInput = "500"

    @State
    private var heatTransferAreaInput = "20"

    @State
    private var correctionFactorInput = "0.95"

    @State
    private var result:
        HeatExchangerLMTDResult?

    @State
    private var errorMessage = ""

    private let engine =
        HeatExchangerLMTDEngine()

    private let numberFormatter =
        NumberFormatterService.precise

    var body: some View {
        ScrollView {
            VStack(spacing: AppSpacing.xLarge) {
                ModuleHeaderView(
                    symbolName:
                        "arrow.left.arrow.right",
                    title:
                        "Heat Exchanger — LMTD",
                    subtitle:
                        "Calculate exchanger duty using terminal temperatures",
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
                AppTheme.Layout.pageHorizontalPadding
            )
            .padding(
                .vertical,
                AppTheme.Layout.pageVerticalPadding
            )
        }
        .navigationTitle(
            "Heat Exchanger — LMTD"
        )
    }

    private var formulaCard: some View {
        CalculatorInfoCard(tint: .orange) {
            VStack(spacing: AppSpacing.small) {
                Text(
                    "Log-Mean Temperature Difference"
                )
                .font(.headline)

                Text(
                    "ΔTₗₘ = (ΔT₁ − ΔT₂) / ln(ΔT₁/ΔT₂)"
                )
                .font(
                    .system(
                        size: 18,
                        weight: .semibold
                    )
                )
                .multilineTextAlignment(.center)
                .minimumScaleFactor(0.6)

                Text("Q̇ = U A F ΔTₗₘ")
                    .font(
                        .system(
                            size: 20,
                            weight: .semibold
                        )
                    )

                Text(terminalDifferenceDescription)
                    .font(.caption)
                    .foregroundStyle(.secondary)
                    .multilineTextAlignment(.center)

                Text(
                    flowArrangement.explanation
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
            Text("Flow Arrangement")
                .font(.headline)

            Picker(
                "Flow Arrangement",
                selection: $flowArrangement
            ) {
                ForEach(
                    HeatExchangerFlowArrangement
                        .allCases
                ) { arrangement in
                    Text(arrangement.title)
                        .tag(arrangement)
                }
            }
            .pickerStyle(.segmented)
            .labelsHidden()
            .onChange(of: flowArrangement) {
                clearResult()
            }

            Divider()

            Text("Hot Stream")
                .font(.headline)

            EngineeringInputField(
                title:
                    "Hot Inlet Temperature",
                symbol: "Tₕ,ᵢ",
                unit: "°C",
                placeholder: "Example: 150",
                text:
                    $hotInletTemperatureInput
            )

            EngineeringInputField(
                title:
                    "Hot Outlet Temperature",
                symbol: "Tₕ,ₒ",
                unit: "°C",
                placeholder: "Example: 90",
                text:
                    $hotOutletTemperatureInput
            )

            Divider()

            Text("Cold Stream")
                .font(.headline)

            EngineeringInputField(
                title:
                    "Cold Inlet Temperature",
                symbol: "T𝚌,ᵢ",
                unit: "°C",
                placeholder: "Example: 30",
                text:
                    $coldInletTemperatureInput
            )

            EngineeringInputField(
                title:
                    "Cold Outlet Temperature",
                symbol: "T𝚌,ₒ",
                unit: "°C",
                placeholder: "Example: 70",
                text:
                    $coldOutletTemperatureInput
            )

            Divider()

            Text("Heat Exchanger Properties")
                .font(.headline)

            EngineeringInputField(
                title:
                    "Overall Heat-Transfer Coefficient",
                symbol: "U",
                unit: "W/(m²·K)",
                placeholder: "Example: 500",
                text:
                    $overallCoefficientInput
            )

            EngineeringInputField(
                title:
                    "Heat-Transfer Area",
                symbol: "A",
                unit: "m²",
                placeholder: "Example: 20",
                text:
                    $heatTransferAreaInput
            )

            EngineeringInputField(
                title:
                    "LMTD Correction Factor",
                symbol: "F",
                unit: "—",
                placeholder: "Example: 0.95",
                text:
                    $correctionFactorInput
            )

            actionButtons

            PrimaryActionButton(
                title:
                    "Calculate Heat Exchanger",
                systemImage:
                    "arrow.left.arrow.right",
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

    private var terminalDifferenceDescription:
        String {
        switch flowArrangement {
        case .parallelFlow:
            return """
            Parallel flow: ΔT₁ = Tₕ,ᵢ − T𝚌,ᵢ and \
            ΔT₂ = Tₕ,ₒ − T𝚌,ₒ.
            """

        case .counterFlow:
            return """
            Counter flow: ΔT₁ = Tₕ,ᵢ − T𝚌,ₒ and \
            ΔT₂ = Tₕ,ₒ − T𝚌,ᵢ.
            """
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
            HeatExchangerLMTDResult
    ) -> some View {
        VStack(spacing: AppSpacing.large) {
            CalculationResultCard(
                items: [
                    CalculationResultDisplayItem(
                        label: "LMTD",
                        value:
                            numberFormatter.format(
                                result
                                    .logMeanTemperatureDifference
                            ),
                        unit: "K"
                    ),
                    CalculationResultDisplayItem(
                        label:
                            "Corrected LMTD",
                        value:
                            numberFormatter.format(
                                result
                                    .correctedLogMeanTemperatureDifference
                            ),
                        unit: "K"
                    ),
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
                    )
                ],
                tint: .orange
            )

            interpretationCard(result)
        }
    }

    private func interpretationCard(
        _ result:
            HeatExchangerLMTDResult
    ) -> some View {
        CalculatorInfoCard(tint: .orange) {
            VStack(
                alignment: .leading,
                spacing: AppSpacing.small
            ) {
                Label(
                    "Heat Exchanger Summary",
                    systemImage:
                        "arrow.left.arrow.right"
                )
                .font(.headline)

                Divider()

                informationRow(
                    title: "Arrangement",
                    value:
                        result
                            .flowArrangement
                            .title
                )

                informationRow(
                    title: "Terminal ΔT₁",
                    value:
                        "\(numberFormatter.format(result.terminalTemperatureDifferenceOne)) K"
                )

                informationRow(
                    title: "Terminal ΔT₂",
                    value:
                        "\(numberFormatter.format(result.terminalTemperatureDifferenceTwo)) K"
                )

                informationRow(
                    title: "Correction Factor",
                    value:
                        numberFormatter.format(
                            result.correctionFactor
                        )
                )

                informationRow(
                    title: "Overall Conductance",
                    value:
                        "\(numberFormatter.format(result.overallConductance)) W/K"
                )

                Text(
                    """
                    The calculated duty is based on the \
                    supplied terminal temperatures, overall \
                    coefficient, area and correction factor.
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
            let input = try makeInput()

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
        -> HeatExchangerLMTDInput {

        let hotInletTemperature =
            try InputValidator.parseNumber(
                hotInletTemperatureInput,
                fieldName:
                    "hot inlet temperature"
            )

        let hotOutletTemperature =
            try InputValidator.parseNumber(
                hotOutletTemperatureInput,
                fieldName:
                    "hot outlet temperature"
            )

        let coldInletTemperature =
            try InputValidator.parseNumber(
                coldInletTemperatureInput,
                fieldName:
                    "cold inlet temperature"
            )

        let coldOutletTemperature =
            try InputValidator.parseNumber(
                coldOutletTemperatureInput,
                fieldName:
                    "cold outlet temperature"
            )

        let overallCoefficient =
            try InputValidator.parseNumber(
                overallCoefficientInput,
                fieldName:
                    "overall heat-transfer coefficient"
            )

        let heatTransferArea =
            try InputValidator.parseNumber(
                heatTransferAreaInput,
                fieldName:
                    "heat-transfer area"
            )

        let correctionFactor =
            try InputValidator.parseNumber(
                correctionFactorInput,
                fieldName:
                    "LMTD correction factor"
            )

        return HeatExchangerLMTDInput(
            flowArrangement:
                flowArrangement,
            hotInletTemperature:
                hotInletTemperature,
            hotOutletTemperature:
                hotOutletTemperature,
            coldInletTemperature:
                coldInletTemperature,
            coldOutletTemperature:
                coldOutletTemperature,
            overallHeatTransferCoefficient:
                overallCoefficient,
            heatTransferArea:
                heatTransferArea,
            correctionFactor:
                correctionFactor
        )
    }

    private func loadExample() {
        flowArrangement = .counterFlow
        hotInletTemperatureInput = "150"
        hotOutletTemperatureInput = "90"
        coldInletTemperatureInput = "30"
        coldOutletTemperatureInput = "70"
        overallCoefficientInput = "500"
        heatTransferAreaInput = "20"
        correctionFactorInput = "0.95"

        clearResult()
    }

    private func resetInputs() {
        flowArrangement = .counterFlow
        hotInletTemperatureInput = ""
        hotOutletTemperatureInput = ""
        coldInletTemperatureInput = ""
        coldOutletTemperatureInput = ""
        overallCoefficientInput = ""
        heatTransferAreaInput = ""
        correctionFactorInput = ""

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
        HeatExchangerLMTDView()
    }
}
