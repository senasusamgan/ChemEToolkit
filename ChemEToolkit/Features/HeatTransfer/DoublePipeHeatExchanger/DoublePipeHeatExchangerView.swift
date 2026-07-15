import SwiftUI

struct DoublePipeHeatExchangerView: View {

    @State
    private var flowArrangement:
        HeatExchangerFlowArrangement =
            .counterFlow

    @State private var hotInletInput = "150"
    @State private var hotOutletInput = "90"

    @State private var coldInletInput = "30"
    @State private var coldOutletInput = "70"

    @State private var requiredDutyInput = "500000"
    @State private var overallCoefficientInput = "500"
    @State private var tubeDiameterInput = "0.05"
    @State private var correctionFactorInput = "0.95"

    @State
    private var numberOfParallelTubes = 2

    @State
    private var result:
        DoublePipeHeatExchangerResult?

    @State private var errorMessage = ""

    private let engine =
        DoublePipeHeatExchangerEngine()

    private let numberFormatter =
        NumberFormatterService.precise

    var body: some View {
        ScrollView {
            VStack(spacing: AppSpacing.xLarge) {
                ModuleHeaderView(
                    symbolName:
                        "arrow.left.arrow.right",
                    title:
                        "Double-Pipe Heat Exchanger",
                    subtitle:
                        "Calculate required heat-transfer area and tube length",
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
            "Double-Pipe Heat Exchanger"
        )
    }

    private var formulaCard: some View {
        CalculatorInfoCard(tint: .orange) {
            VStack(spacing: AppSpacing.small) {
                Text("Double-Pipe Sizing")
                    .font(.headline)

                Text("A = Q̇ / (UFΔTₗₘ)")
                    .font(
                        .system(
                            size: 21,
                            weight: .semibold
                        )
                    )

                Text("L = A / (NπDₒ)")
                    .font(
                        .system(
                            size: 19,
                            weight: .semibold
                        )
                    )

                Text(
                    """
                    Calculates the required length per \
                    parallel tube using the outside \
                    heat-transfer surface.
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

            Divider()

            Text("Terminal Temperatures")
                .font(.headline)

            EngineeringInputField(
                title: "Hot Inlet Temperature",
                symbol: "Tₕ,ᵢ",
                unit: "°C",
                placeholder: "Example: 150",
                text: $hotInletInput
            )

            EngineeringInputField(
                title: "Hot Outlet Temperature",
                symbol: "Tₕ,ₒ",
                unit: "°C",
                placeholder: "Example: 90",
                text: $hotOutletInput
            )

            EngineeringInputField(
                title: "Cold Inlet Temperature",
                symbol: "T𝚌,ᵢ",
                unit: "°C",
                placeholder: "Example: 30",
                text: $coldInletInput
            )

            EngineeringInputField(
                title: "Cold Outlet Temperature",
                symbol: "T𝚌,ₒ",
                unit: "°C",
                placeholder: "Example: 70",
                text: $coldOutletInput
            )

            Divider()

            Text("Design Inputs")
                .font(.headline)

            EngineeringInputField(
                title: "Required Duty",
                symbol: "Q̇",
                unit: "W",
                placeholder: "Example: 500000",
                text: $requiredDutyInput
            )

            EngineeringInputField(
                title: "Overall Coefficient",
                symbol: "U",
                unit: "W/(m²·K)",
                placeholder: "Example: 500",
                text:
                    $overallCoefficientInput
            )

            EngineeringInputField(
                title: "Tube Outer Diameter",
                symbol: "Dₒ",
                unit: "m",
                placeholder: "Example: 0.05",
                text: $tubeDiameterInput
            )

            EngineeringInputField(
                title: "Correction Factor",
                symbol: "F",
                unit: "—",
                placeholder: "Example: 0.95",
                text:
                    $correctionFactorInput
            )

            VStack(
                alignment: .leading,
                spacing: AppSpacing.small
            ) {
                Text("Parallel Tube Count")
                    .font(.subheadline)
                    .fontWeight(.semibold)

                Picker(
                    "Parallel Tube Count",
                    selection:
                        $numberOfParallelTubes
                ) {
                    ForEach(1...8, id: \.self) {
                        count in

                        Text("\(count)")
                            .tag(count)
                    }
                }
                .pickerStyle(.segmented)
                .labelsHidden()
            }

            actionButtons

            PrimaryActionButton(
                title:
                    "Calculate Double-Pipe Size",
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
        _ result:
            DoublePipeHeatExchangerResult
    ) -> some View {
        VStack(spacing: AppSpacing.large) {
            CalculationResultCard(
                items: [
                    CalculationResultDisplayItem(
                        label: "Required Area",
                        value:
                            numberFormatter.format(
                                result
                                    .requiredHeatTransferArea
                            ),
                        unit: "m²"
                    ),
                    CalculationResultDisplayItem(
                        label:
                            "Length per Tube",
                        value:
                            numberFormatter.format(
                                result
                                    .requiredLengthPerTube
                            ),
                        unit: "m"
                    ),
                    CalculationResultDisplayItem(
                        label:
                            "Total Tube Length",
                        value:
                            numberFormatter.format(
                                result.totalTubeLength
                            ),
                        unit: "m"
                    ),
                    CalculationResultDisplayItem(
                        label: "Corrected LMTD",
                        value:
                            numberFormatter.format(
                                result
                                    .correctedLogMeanTemperatureDifference
                            ),
                        unit: "K"
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
                        "Design Summary",
                        systemImage: "ruler.fill"
                    )
                    .font(.headline)

                    Divider()

                    informationRow(
                        title: "Arrangement",
                        value:
                            result
                                .flowArrangement.title
                    )

                    informationRow(
                        title: "Parallel Tubes",
                        value:
                            "\(result.numberOfParallelTubes)"
                    )

                    informationRow(
                        title: "Required UA",
                        value:
                            "\(numberFormatter.format(result.requiredOverallConductance)) W/K"
                    )

                    informationRow(
                        title: "Design Heat Flux",
                        value:
                            "\(numberFormatter.format(result.designHeatFlux)) W/m²"
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
        -> DoublePipeHeatExchangerInput {

        DoublePipeHeatExchangerInput(
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
                        "required exchanger duty"
                ),
            overallHeatTransferCoefficient:
                try InputValidator.parseNumber(
                    overallCoefficientInput,
                    fieldName:
                        "overall coefficient"
                ),
            tubeOuterDiameter:
                try InputValidator.parseNumber(
                    tubeDiameterInput,
                    fieldName:
                        "tube outer diameter"
                ),
            numberOfParallelTubes:
                numberOfParallelTubes,
            correctionFactor:
                try InputValidator.parseNumber(
                    correctionFactorInput,
                    fieldName:
                        "correction factor"
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
        tubeDiameterInput = "0.05"
        correctionFactorInput = "0.95"
        numberOfParallelTubes = 2

        clearResult()
    }

    private func resetInputs() {
        hotInletInput = ""
        hotOutletInput = ""
        coldInletInput = ""
        coldOutletInput = ""
        requiredDutyInput = ""
        overallCoefficientInput = ""
        tubeDiameterInput = ""
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
        DoublePipeHeatExchangerView()
    }
}
