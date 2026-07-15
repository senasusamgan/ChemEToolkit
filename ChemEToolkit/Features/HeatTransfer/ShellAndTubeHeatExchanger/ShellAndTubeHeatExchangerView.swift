import SwiftUI

struct ShellAndTubeHeatExchangerView: View {

    @State private var hotInletInput = "150"
    @State private var hotOutletInput = "90"

    @State private var coldInletInput = "30"
    @State private var coldOutletInput = "70"

    @State private var requiredDutyInput = "500000"
    @State private var overallCoefficientInput = "500"
    @State private var correctionFactorInput = "0.95"

    @State private var tubeDiameterInput = "0.025"
    @State private var tubeLengthInput = "5"

    @State private var numberOfTubePasses = 4

    @State
    private var result:
        ShellAndTubeHeatExchangerResult?

    @State private var errorMessage = ""

    private let engine =
        ShellAndTubeHeatExchangerEngine()

    private let numberFormatter =
        NumberFormatterService.precise

    private let passOptions = [
        1,
        2,
        4,
        6,
        8
    ]

    var body: some View {
        ScrollView {
            VStack(spacing: AppSpacing.xLarge) {
                ModuleHeaderView(
                    symbolName:
                        "square.grid.3x3.fill",
                    title:
                        "Shell-and-Tube Heat Exchanger",
                    subtitle:
                        "Preliminary tube-bundle sizing using corrected LMTD",
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
            "Shell-and-Tube Heat Exchanger"
        )
    }

    private var formulaCard: some View {
        CalculatorInfoCard(tint: .orange) {
            VStack(spacing: AppSpacing.small) {
                Text("Preliminary Tube-Bundle Sizing")
                    .font(.headline)

                Text("A = Q̇ / (UFΔTₗₘ)")
                    .font(
                        .system(
                            size: 20,
                            weight: .semibold
                        )
                    )

                Text("Nₜ = A / (πDₒLₜ)")
                    .font(
                        .system(
                            size: 19,
                            weight: .semibold
                        )
                    )

                Text(
                    """
                    The calculated tube count is rounded up \
                    to a complete multiple of the selected \
                    number of tube passes.
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

            Text("Design Requirements")
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
                title: "Correction Factor",
                symbol: "F",
                unit: "—",
                placeholder: "Example: 0.95",
                text:
                    $correctionFactorInput
            )

            Divider()

            Text("Tube Geometry")
                .font(.headline)

            EngineeringInputField(
                title: "Tube Outer Diameter",
                symbol: "Dₒ",
                unit: "m",
                placeholder: "Example: 0.025",
                text: $tubeDiameterInput
            )

            EngineeringInputField(
                title: "Tube Length",
                symbol: "Lₜ",
                unit: "m",
                placeholder: "Example: 5",
                text: $tubeLengthInput
            )

            VStack(
                alignment: .leading,
                spacing: AppSpacing.small
            ) {
                Text("Number of Tube Passes")
                    .font(.subheadline)
                    .fontWeight(.semibold)

                Picker(
                    "Number of Tube Passes",
                    selection:
                        $numberOfTubePasses
                ) {
                    ForEach(
                        passOptions,
                        id: \.self
                    ) { count in
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
                    "Calculate Tube Bundle",
                systemImage:
                    "square.grid.3x3.fill",
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
            ShellAndTubeHeatExchangerResult
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
                        label: "Selected Tubes",
                        value:
                            "\(result.selectedTubeCount)",
                        unit: "tubes"
                    ),
                    CalculationResultDisplayItem(
                        label: "Provided Area",
                        value:
                            numberFormatter.format(
                                result
                                    .providedHeatTransferArea
                            ),
                        unit: "m²"
                    ),
                    CalculationResultDisplayItem(
                        label: "Area Margin",
                        value:
                            numberFormatter.format(
                                result
                                    .areaDesignMarginPercentage
                            ),
                        unit: "%"
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
                        "Tube-Bundle Summary",
                        systemImage:
                            "square.grid.3x3.fill"
                    )
                    .font(.headline)

                    Divider()

                    informationRow(
                        title: "Exact Tube Count",
                        value:
                            numberFormatter.format(
                                result.exactTubeCount
                            )
                    )

                    informationRow(
                        title: "Tube Passes",
                        value:
                            "\(result.numberOfTubePasses)"
                    )

                    informationRow(
                        title: "Tubes per Pass",
                        value:
                            "\(result.tubesPerPass)"
                    )

                    informationRow(
                        title: "Area per Tube",
                        value:
                            "\(numberFormatter.format(result.heatTransferAreaPerTube)) m²"
                    )

                    informationRow(
                        title: "Provided Duty",
                        value:
                            "\(numberFormatter.format(result.providedHeatTransferRate)) W"
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
        -> ShellAndTubeHeatExchangerInput {

        ShellAndTubeHeatExchangerInput(
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
                        "required duty"
                ),
            overallHeatTransferCoefficient:
                try InputValidator.parseNumber(
                    overallCoefficientInput,
                    fieldName:
                        "overall coefficient"
                ),
            correctionFactor:
                try InputValidator.parseNumber(
                    correctionFactorInput,
                    fieldName:
                        "correction factor"
                ),
            tubeOuterDiameter:
                try InputValidator.parseNumber(
                    tubeDiameterInput,
                    fieldName:
                        "tube outer diameter"
                ),
            tubeLength:
                try InputValidator.parseNumber(
                    tubeLengthInput,
                    fieldName:
                        "tube length"
                ),
            numberOfTubePasses:
                numberOfTubePasses
        )
    }

    private func loadExample() {
        hotInletInput = "150"
        hotOutletInput = "90"
        coldInletInput = "30"
        coldOutletInput = "70"
        requiredDutyInput = "500000"
        overallCoefficientInput = "500"
        correctionFactorInput = "0.95"
        tubeDiameterInput = "0.025"
        tubeLengthInput = "5"
        numberOfTubePasses = 4

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
        tubeDiameterInput = ""
        tubeLengthInput = ""

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
        ShellAndTubeHeatExchangerView()
    }
}
