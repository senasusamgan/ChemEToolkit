import SwiftUI

struct HeatExchangerEffectivenessNTUView: View {

    @State
    private var flowArrangement:
        HeatExchangerNTUArrangement =
            .counterFlow

    @State
    private var hotInletInput = "150"

    @State
    private var coldInletInput = "30"

    @State
    private var hotMassFlowInput = "2"

    @State
    private var coldMassFlowInput = "3"

    @State
    private var hotSpecificHeatInput = "4180"

    @State
    private var coldSpecificHeatInput = "4180"

    @State
    private var overallCoefficientInput = "500"

    @State
    private var areaInput = "20"

    @State
    private var result:
        HeatExchangerEffectivenessNTUResult?

    @State
    private var errorMessage = ""

    private let engine =
        HeatExchangerEffectivenessNTUEngine()

    private let numberFormatter =
        NumberFormatterService.precise

    var body: some View {
        ScrollView {
            VStack(spacing: AppSpacing.xLarge) {
                ModuleHeaderView(
                    symbolName:
                        "chart.line.uptrend.xyaxis",
                    title:
                        "Heat Exchanger Effectiveness–NTU",
                    subtitle:
                        "Predict exchanger duty without known outlet temperatures",
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
            "Effectiveness–NTU"
        )
    }

    private var formulaCard: some View {
        CalculatorInfoCard(tint: .orange) {
            VStack(spacing: AppSpacing.small) {
                Text("Effectiveness–NTU Method")
                    .font(.headline)

                Text(
                    "NTU = UA/Cₘᵢₙ"
                )
                .font(
                    .system(
                        size: 21,
                        weight: .semibold
                    )
                )

                Text(
                    "Q̇ = ε Cₘᵢₙ(Tₕ,ᵢ − T𝚌,ᵢ)"
                )
                .font(
                    .system(
                        size: 19,
                        weight: .semibold
                    )
                )

                Text(
                    """
                    Uses inlet temperatures, stream capacity \
                    rates and exchanger UA to predict duty \
                    and outlet temperatures.
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
            Text("Flow Arrangement")
                .font(.headline)

            Picker(
                "Flow Arrangement",
                selection:
                    $flowArrangement
            ) {
                ForEach(
                    HeatExchangerNTUArrangement
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

            Text("Inlet Temperatures")
                .font(.headline)

            EngineeringInputField(
                title:
                    "Hot Inlet Temperature",
                symbol: "Tₕ,ᵢ",
                unit: "°C",
                placeholder: "Example: 150",
                text: $hotInletInput
            )

            EngineeringInputField(
                title:
                    "Cold Inlet Temperature",
                symbol: "T𝚌,ᵢ",
                unit: "°C",
                placeholder: "Example: 30",
                text: $coldInletInput
            )

            Divider()

            Text("Hot Stream")
                .font(.headline)

            EngineeringInputField(
                title: "Mass Flow Rate",
                symbol: "ṁₕ",
                unit: "kg/s",
                placeholder: "Example: 2",
                text: $hotMassFlowInput
            )

            EngineeringInputField(
                title:
                    "Specific Heat Capacity",
                symbol: "cₚ,ₕ",
                unit: "J/(kg·K)",
                placeholder: "Example: 4180",
                text: $hotSpecificHeatInput
            )

            Divider()

            Text("Cold Stream")
                .font(.headline)

            EngineeringInputField(
                title: "Mass Flow Rate",
                symbol: "ṁ𝚌",
                unit: "kg/s",
                placeholder: "Example: 3",
                text: $coldMassFlowInput
            )

            EngineeringInputField(
                title:
                    "Specific Heat Capacity",
                symbol: "cₚ,𝚌",
                unit: "J/(kg·K)",
                placeholder: "Example: 4180",
                text:
                    $coldSpecificHeatInput
            )

            Divider()

            Text("Exchanger Properties")
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
                text: $areaInput
            )

            actionButtons

            PrimaryActionButton(
                title:
                    "Calculate Effectiveness",
                systemImage:
                    "chart.line.uptrend.xyaxis",
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
            HeatExchangerEffectivenessNTUResult
    ) -> some View {
        VStack(spacing: AppSpacing.large) {
            CalculationResultCard(
                items: [
                    CalculationResultDisplayItem(
                        label: "Effectiveness",
                        value:
                            numberFormatter.format(
                                result.effectiveness
                            ),
                        unit: "—"
                    ),
                    CalculationResultDisplayItem(
                        label: "NTU",
                        value:
                            numberFormatter.format(
                                result
                                    .numberOfTransferUnits
                            ),
                        unit: "—"
                    ),
                    CalculationResultDisplayItem(
                        label:
                            "Heat Transfer Rate",
                        value:
                            numberFormatter.format(
                                result
                                    .actualHeatTransferRate
                            ),
                        unit: "W"
                    ),
                    CalculationResultDisplayItem(
                        label:
                            "Maximum Possible Rate",
                        value:
                            numberFormatter.format(
                                result
                                    .maximumPossibleHeatTransferRate
                            ),
                        unit: "W"
                    )
                ],
                tint: .orange
            )

            CalculationResultCard(
                items: [
                    CalculationResultDisplayItem(
                        label:
                            "Hot Outlet Temperature",
                        value:
                            numberFormatter.format(
                                result
                                    .hotOutletTemperature
                            ),
                        unit: "°C"
                    ),
                    CalculationResultDisplayItem(
                        label:
                            "Cold Outlet Temperature",
                        value:
                            numberFormatter.format(
                                result
                                    .coldOutletTemperature
                            ),
                        unit: "°C"
                    ),
                    CalculationResultDisplayItem(
                        label:
                            "Capacity-Rate Ratio",
                        value:
                            numberFormatter.format(
                                result
                                    .capacityRateRatio
                            ),
                        unit: "—"
                    ),
                    CalculationResultDisplayItem(
                        label:
                            "Minimum Capacity Rate",
                        value:
                            numberFormatter.format(
                                result
                                    .minimumCapacityRate
                            ),
                        unit: "W/K"
                    )
                ],
                tint: .orange
            )
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
        -> HeatExchangerEffectivenessNTUInput {

        HeatExchangerEffectivenessNTUInput(
            flowArrangement:
                flowArrangement,
            hotInletTemperature:
                try InputValidator.parseNumber(
                    hotInletInput,
                    fieldName:
                        "hot inlet temperature"
                ),
            coldInletTemperature:
                try InputValidator.parseNumber(
                    coldInletInput,
                    fieldName:
                        "cold inlet temperature"
                ),
            hotMassFlowRate:
                try InputValidator.parseNumber(
                    hotMassFlowInput,
                    fieldName:
                        "hot-stream mass flow rate"
                ),
            coldMassFlowRate:
                try InputValidator.parseNumber(
                    coldMassFlowInput,
                    fieldName:
                        "cold-stream mass flow rate"
                ),
            hotSpecificHeatCapacity:
                try InputValidator.parseNumber(
                    hotSpecificHeatInput,
                    fieldName:
                        "hot-stream specific heat"
                ),
            coldSpecificHeatCapacity:
                try InputValidator.parseNumber(
                    coldSpecificHeatInput,
                    fieldName:
                        "cold-stream specific heat"
                ),
            overallHeatTransferCoefficient:
                try InputValidator.parseNumber(
                    overallCoefficientInput,
                    fieldName:
                        "overall heat-transfer coefficient"
                ),
            heatTransferArea:
                try InputValidator.parseNumber(
                    areaInput,
                    fieldName:
                        "heat-transfer area"
                )
        )
    }

    private func loadExample() {
        flowArrangement = .counterFlow
        hotInletInput = "150"
        coldInletInput = "30"
        hotMassFlowInput = "2"
        coldMassFlowInput = "3"
        hotSpecificHeatInput = "4180"
        coldSpecificHeatInput = "4180"
        overallCoefficientInput = "500"
        areaInput = "20"
        clearResult()
    }

    private func resetInputs() {
        hotInletInput = ""
        coldInletInput = ""
        hotMassFlowInput = ""
        coldMassFlowInput = ""
        hotSpecificHeatInput = ""
        coldSpecificHeatInput = ""
        overallCoefficientInput = ""
        areaInput = ""
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
        HeatExchangerEffectivenessNTUView()
    }
}
