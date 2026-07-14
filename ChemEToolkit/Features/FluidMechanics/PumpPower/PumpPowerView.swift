import SwiftUI

struct PumpPowerView: View {

    @State
    private var densityText = "998"

    @State
    private var flowRateText = "0.02"

    @State
    private var pumpHeadText = "15"

    @State
    private var efficiencyText = "75"

    @State
    private var gravityText = "9.80665"

    @State
    private var calculationResult:
        PumpPowerResult?

    @State
    private var errorMessage = ""

    private let engine =
        PumpPowerEngine()

    private let numberFormatter =
        NumberFormatterService.precise

    var body: some View {
        ScrollView {
            VStack(
                spacing: AppSpacing.xLarge
            ) {
                ModuleHeaderView(
                    symbolName: "bolt.fill",
                    title:
                        "Pump Power & Head",
                    subtitle:
                        "Calculate pressure rise, hydraulic power and required shaft power",
                    tint: .green
                )

                equationInformationCard

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
        .navigationTitle("Pump Power")
    }

    private var equationInformationCard:
        some View {

        CalculatorInfoCard(
            tint: .green
        ) {
            VStack(
                spacing: AppSpacing.small
            ) {
                Text("Pump Energy Relations")
                    .font(.headline)

                Text("ΔP = ρghₚ")
                    .font(
                        .system(
                            size: 22,
                            weight: .semibold
                        )
                    )

                Text("Pₕ = ρgQhₚ")
                    .font(
                        .system(
                            size: 22,
                            weight: .semibold
                        )
                    )

                Text("Pₛ = Pₕ / η")
                    .font(
                        .system(
                            size: 22,
                            weight: .semibold
                        )
                    )

                Text(
                    "Efficiency is entered as a percentage between 0 and 100."
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

    private var calculatorContent:
        some View {

        VStack(
            alignment: .leading,
            spacing: AppSpacing.large
        ) {
            Text("Pump & Flow Properties")
                .font(.headline)

            EngineeringInputField(
                title: "Fluid Density",
                symbol: "ρ",
                unit: "kg/m³",
                placeholder: "Example: 998",
                text: $densityText
            )

            EngineeringInputField(
                title:
                    "Volumetric Flow Rate",
                symbol: "Q",
                unit: "m³/s",
                placeholder: "Example: 0.02",
                text: $flowRateText
            )

            EngineeringInputField(
                title: "Pump Head",
                symbol: "hₚ",
                unit: "m",
                placeholder: "Example: 15",
                text: $pumpHeadText
            )

            EngineeringInputField(
                title: "Pump Efficiency",
                symbol: "η",
                unit: "%",
                placeholder: "Example: 75",
                text: $efficiencyText
            )

            DisclosureGroup(
                "Advanced Inputs"
            ) {
                EngineeringInputField(
                    title:
                        "Gravitational Acceleration",
                    symbol: "g",
                    unit: "m/s²",
                    placeholder:
                        "Example: 9.80665",
                    text: $gravityText
                )
                .padding(
                    .top,
                    AppSpacing.medium
                )
            }
            .font(.headline)

            actionButtons

            PrimaryActionButton(
                title:
                    "Calculate Pump Power",
                systemImage:
                    "equal.circle",
                action:
                    calculate
            )

            if let calculationResult {
                resultSection(
                    calculationResult
                )
            }

            if !errorMessage.isEmpty {
                CalculationErrorCard(
                    message: errorMessage
                )
            }
        }
    }

    private var actionButtons:
        some View {

        ViewThatFits(
            in: .horizontal
        ) {
            HStack(
                spacing: AppSpacing.small
            ) {
                loadExampleButton
                clearButton
            }

            VStack(
                spacing: AppSpacing.small
            ) {
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

    private var clearButton:
        some View {

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
        _ result: PumpPowerResult
    ) -> some View {

        VStack(
            spacing: AppSpacing.large
        ) {
            CalculationResultCard(
                items: [
                    CalculationResultDisplayItem(
                        label:
                            "Required Shaft Power",
                        value:
                            numberFormatter.format(
                                result
                                    .shaftPowerKilowatts
                            ),
                        unit: "kW"
                    ),
                    CalculationResultDisplayItem(
                        label:
                            "Hydraulic Power",
                        value:
                            numberFormatter.format(
                                result
                                    .hydraulicPowerKilowatts
                            ),
                        unit: "kW"
                    ),
                    CalculationResultDisplayItem(
                        label:
                            "Pressure Increase",
                        value:
                            numberFormatter.format(
                                result
                                    .pressureIncreaseKilopascals
                            ),
                        unit: "kPa"
                    )
                ]
            )

            CalculatorInfoCard(
                tint: .green
            ) {
                VStack(
                    spacing:
                        AppSpacing.small
                ) {
                    informationRow(
                        title:
                            "Pump head",
                        value:
                            numberFormatter.format(
                                result.pumpHead,
                                unit: "m"
                            )
                    )

                    informationRow(
                        title:
                            "Efficiency",
                        value:
                            numberFormatter
                                .formatPercentage(
                                    result.efficiency
                                )
                    )

                    informationRow(
                        title:
                            "Volumetric flow",
                        value:
                            numberFormatter.format(
                                result
                                    .volumetricFlowRate,
                                unit: "m³/s"
                            )
                    )

                    informationRow(
                        title:
                            "Power lost",
                        value:
                            numberFormatter.format(
                                result
                                    .powerLossKilowatts,
                                unit: "kW"
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
                .multilineTextAlignment(
                    .trailing
                )
        }
    }

    private func calculate() {
        clearResult()

        do {
            calculationResult =
                try engine.solve(
                    input:
                        try makeInput()
                )
        } catch let error
            as CalculationError {

            showCalculationError(error)
        } catch let error
            as PumpPowerError {

            errorMessage =
                error.errorDescription
                ?? "The pump power could not be calculated."
        } catch {
            errorMessage =
                error.localizedDescription
        }
    }

    private func makeInput() throws
        -> PumpPowerInput {

        let efficiencyPercentage =
            try parsePercentage(
                efficiencyText,
                fieldName:
                    "Pump Efficiency"
            )

        return PumpPowerInput(
            density:
                try parsePositive(
                    densityText,
                    fieldName:
                        "Fluid Density"
                ),
            volumetricFlowRate:
                try parseNonNegative(
                    flowRateText,
                    fieldName:
                        "Volumetric Flow Rate"
                ),
            pumpHead:
                try parseNonNegative(
                    pumpHeadText,
                    fieldName:
                        "Pump Head"
                ),
            efficiency:
                efficiencyPercentage
                / 100,
            gravity:
                try parsePositive(
                    gravityText,
                    fieldName:
                        "Gravitational Acceleration"
                )
        )
    }

    private func parsePositive(
        _ text: String,
        fieldName: String
    ) throws -> Double {

        let value =
            try InputValidator
                .parseNumber(
                    text,
                    fieldName: fieldName
                )

        return try InputValidator
            .requirePositive(
                value,
                fieldName: fieldName
            )
    }

    private func parseNonNegative(
        _ text: String,
        fieldName: String
    ) throws -> Double {

        let value =
            try InputValidator
                .parseNumber(
                    text,
                    fieldName: fieldName
                )

        return try InputValidator
            .requireNonNegative(
                value,
                fieldName: fieldName
            )
    }

    private func parsePercentage(
        _ text: String,
        fieldName: String
    ) throws -> Double {

        let value =
            try InputValidator
                .parseNumber(
                    text,
                    fieldName: fieldName
                )

        let positiveValue =
            try InputValidator
                .requirePositive(
                    value,
                    fieldName: fieldName
                )

        return try InputValidator
            .requirePercentage(
                positiveValue,
                fieldName: fieldName
            )
    }

    private func loadExample() {
        densityText = "998"
        flowRateText = "0.02"
        pumpHeadText = "15"
        efficiencyText = "75"
        gravityText = "9.80665"

        clearResult()
    }

    private func resetInputs() {
        densityText = ""
        flowRateText = ""
        pumpHeadText = ""
        efficiencyText = ""
        gravityText = ""

        clearResult()
    }

    private func showCalculationError(
        _ error: CalculationError
    ) {
        let description =
            error.errorDescription
            ?? "The inputs could not be processed."

        if let suggestion =
            error.recoverySuggestion {
            errorMessage =
                "\(description) \(suggestion)"
        } else {
            errorMessage = description
        }
    }

    private func clearResult() {
        calculationResult = nil
        errorMessage = ""
    }
}

#Preview {
    NavigationStack {
        PumpPowerView()
    }
}
