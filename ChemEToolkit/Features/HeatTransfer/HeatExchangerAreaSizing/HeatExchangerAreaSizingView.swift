import SwiftUI

struct HeatExchangerAreaSizingView: View {

    @State
    private var flowArrangement:
        HeatExchangerFlowArrangement =
            .counterFlow

    @State
    private var hotInletInput = "150"

    @State
    private var hotOutletInput = "90"

    @State
    private var coldInletInput = "30"

    @State
    private var coldOutletInput = "70"

    @State
    private var requiredDutyInput = "500000"

    @State
    private var overallCoefficientInput = "500"

    @State
    private var correctionFactorInput = "0.95"

    @State
    private var result:
        HeatExchangerAreaSizingResult?

    @State
    private var errorMessage = ""

    private let engine =
        HeatExchangerAreaSizingEngine()

    private let numberFormatter =
        NumberFormatterService.precise

    var body: some View {
        ScrollView {
            VStack(spacing: AppSpacing.xLarge) {
                ModuleHeaderView(
                    symbolName: "ruler.fill",
                    title:
                        "Heat Exchanger Area Sizing",
                    subtitle:
                        "Determine the required area for a specified exchanger duty",
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
            "Heat Exchanger Area Sizing"
        )
    }

    private var formulaCard: some View {
        CalculatorInfoCard(tint: .orange) {
            VStack(spacing: AppSpacing.small) {
                Text("LMTD Design Equation")
                    .font(.headline)

                Text(
                    "A = Q̇ / (U F ΔTₗₘ)"
                )
                .font(
                    .system(
                        size: 22,
                        weight: .semibold
                    )
                )

                Text(
                    """
                    Calculates the heat-transfer surface area \
                    required to achieve a specified exchanger duty.
                    """
                )
                .foregroundStyle(.secondary)
                .multilineTextAlignment(.center)

                Text(
                    flowArrangement.explanation
                )
                .font(.caption)
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

            Text("Terminal Temperatures")
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
                    "Hot Outlet Temperature",
                symbol: "Tₕ,ₒ",
                unit: "°C",
                placeholder: "Example: 90",
                text: $hotOutletInput
            )

            EngineeringInputField(
                title:
                    "Cold Inlet Temperature",
                symbol: "T𝚌,ᵢ",
                unit: "°C",
                placeholder: "Example: 30",
                text: $coldInletInput
            )

            EngineeringInputField(
                title:
                    "Cold Outlet Temperature",
                symbol: "T𝚌,ₒ",
                unit: "°C",
                placeholder: "Example: 70",
                text: $coldOutletInput
            )

            Divider()

            Text("Design Requirements")
                .font(.headline)

            EngineeringInputField(
                title:
                    "Required Heat-Transfer Rate",
                symbol: "Q̇",
                unit: "W",
                placeholder: "Example: 500000",
                text: $requiredDutyInput
            )

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
                    "Calculate Required Area",
                systemImage: "ruler.fill",
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
            HeatExchangerAreaSizingResult
    ) -> some View {
        VStack(spacing: AppSpacing.large) {
            CalculationResultCard(
                items: [
                    CalculationResultDisplayItem(
                        label: "Required Area",
                        value:
                            numberFormatter.format(
                                result.requiredArea
                            ),
                        unit: "m²"
                    ),
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
                            "Design Heat Flux",
                        value:
                            numberFormatter.format(
                                result.designHeatFlux
                            ),
                        unit: "W/m²"
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
                        "Sizing Summary",
                        systemImage: "ruler.fill"
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
                        title:
                            "Required UA",
                        value:
                            "\(numberFormatter.format(result.requiredOverallConductance)) W/K"
                    )
                }
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
        -> HeatExchangerAreaSizingInput {

        HeatExchangerAreaSizingInput(
            flowArrangement:
                flowArrangement,
            hotInletTemperature:
                try InputValidator.parseNumber(
                    hotInletInput,
                    fieldName:
                        "hot inlet temperature"
                ),
            hotOutletTemperature:
                try InputValidator.parseNumber(
                    hotOutletInput,
                    fieldName:
                        "hot outlet temperature"
                ),
            coldInletTemperature:
                try InputValidator.parseNumber(
                    coldInletInput,
                    fieldName:
                        "cold inlet temperature"
                ),
            coldOutletTemperature:
                try InputValidator.parseNumber(
                    coldOutletInput,
                    fieldName:
                        "cold outlet temperature"
                ),
            requiredHeatTransferRate:
                try InputValidator.parseNumber(
                    requiredDutyInput,
                    fieldName:
                        "required heat-transfer rate"
                ),
            overallHeatTransferCoefficient:
                try InputValidator.parseNumber(
                    overallCoefficientInput,
                    fieldName:
                        "overall heat-transfer coefficient"
                ),
            correctionFactor:
                try InputValidator.parseNumber(
                    correctionFactorInput,
                    fieldName:
                        "LMTD correction factor"
                )
        )
    }

    private func loadExample() {
        flowArrangement = .counterFlow
        hotInletInput = "150"
        hotOutletInput = "90"
        coldInletInput = "30"
        coldOutletInput = "70"
        requiredDutyInput = "500000"
        overallCoefficientInput = "500"
        correctionFactorInput = "0.95"
        clearResult()
    }

    private func resetInputs() {
        hotInletInput = ""
        hotOutletInput = ""
        coldInletInput = ""
        coldOutletInput = ""
        requiredDutyInput = ""
        overallCoefficientInput = ""
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
        HeatExchangerAreaSizingView()
    }
}
