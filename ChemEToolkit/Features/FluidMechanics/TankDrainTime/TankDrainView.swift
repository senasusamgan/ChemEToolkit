import SwiftUI

struct TankDrainView: View {

    @State
    private var tankAreaText = "2"

    @State
    private var orificeAreaText = "0.01"

    @State
    private var dischargeCoefficientText =
        "0.62"

    @State
    private var initialHeightText = "2"

    @State
    private var finalHeightText = "0.5"

    @State
    private var gravityText = "9.80665"

    @State
    private var calculationResult:
        TankDrainResult?

    @State
    private var errorMessage = ""

    private let engine =
        TankDrainEngine()

    private let numberFormatter =
        NumberFormatterService.precise

    var body: some View {
        ScrollView {
            VStack(
                spacing: AppSpacing.xLarge
            ) {
                ModuleHeaderView(
                    symbolName: "hourglass",
                    title: "Tank Drain Time",
                    subtitle:
                        "Calculate liquid discharge time through a bottom orifice",
                    tint: .teal
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
        .navigationTitle("Tank Drain Time")
    }

    private var equationInformationCard:
        some View {

        CalculatorInfoCard(
            tint: .teal
        ) {
            VStack(
                spacing: AppSpacing.small
            ) {
                Text("Torricelli Drainage")
                    .font(.headline)

                Text("v = √(2gh)")
                    .font(
                        .system(
                            size: 23,
                            weight: .semibold
                        )
                    )

                Text(
                    "t = 2Aₜ(CᴅAₒ√2g)⁻¹(√h₁ − √h₂)"
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
                    "Assumes a constant-area tank draining through a small bottom orifice."
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
            Text("Tank & Orifice Geometry")
                .font(.headline)

            EngineeringInputField(
                title:
                    "Tank Cross-sectional Area",
                symbol: "Aₜ",
                unit: "m²",
                placeholder: "Example: 2",
                text: $tankAreaText
            )

            EngineeringInputField(
                title: "Orifice Area",
                symbol: "Aₒ",
                unit: "m²",
                placeholder:
                    "Example: 0.01",
                text: $orificeAreaText
            )

            EngineeringInputField(
                title:
                    "Discharge Coefficient",
                symbol: "Cᴅ",
                unit: "",
                placeholder:
                    "Example: 0.62",
                text:
                    $dischargeCoefficientText
            )

            Divider()

            Text("Liquid Levels")
                .font(.headline)

            EngineeringInputField(
                title:
                    "Initial Liquid Height",
                symbol: "h₁",
                unit: "m",
                placeholder: "Example: 2",
                text: $initialHeightText
            )

            EngineeringInputField(
                title:
                    "Final Liquid Height",
                symbol: "h₂",
                unit: "m",
                placeholder:
                    "Example: 0.5",
                text: $finalHeightText
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
                    "Calculate Drain Time",
                systemImage: "equal.circle",
                action: calculate
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
        _ result: TankDrainResult
    ) -> some View {

        VStack(
            spacing: AppSpacing.large
        ) {
            CalculationResultCard(
                items: [
                    CalculationResultDisplayItem(
                        label: "Drain Time",
                        value:
                            numberFormatter.format(
                                result.drainTime
                            ),
                        unit: "s"
                    ),
                    CalculationResultDisplayItem(
                        label:
                            "Drain Time",
                        value:
                            numberFormatter.format(
                                result
                                    .drainTimeMinutes
                            ),
                        unit: "min"
                    ),
                    CalculationResultDisplayItem(
                        label:
                            "Initial Flow Rate",
                        value:
                            numberFormatter.format(
                                result
                                    .initialFlowRateLitresPerSecond
                            ),
                        unit: "L/s"
                    ),
                    CalculationResultDisplayItem(
                        label:
                            "Final Flow Rate",
                        value:
                            numberFormatter.format(
                                result
                                    .finalFlowRateLitresPerSecond
                            ),
                        unit: "L/s"
                    )
                ]
            )

            CalculatorInfoCard(
                tint: .teal
            ) {
                VStack(
                    spacing:
                        AppSpacing.small
                ) {
                    informationRow(
                        title:
                            "Initial exit velocity",
                        value:
                            numberFormatter.format(
                                result
                                    .initialExitVelocity,
                                unit: "m/s"
                            )
                    )

                    informationRow(
                        title:
                            "Final exit velocity",
                        value:
                            numberFormatter.format(
                                result
                                    .finalExitVelocity,
                                unit: "m/s"
                            )
                    )

                    informationRow(
                        title:
                            "Tank-to-orifice area ratio",
                        value:
                            numberFormatter.format(
                                result.areaRatio
                            )
                    )

                    informationRow(
                        title:
                            "Discharge coefficient",
                        value:
                            numberFormatter.format(
                                result
                                    .dischargeCoefficient
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
                    input: try makeInput()
                )
        } catch let error
            as CalculationError {

            showCalculationError(error)
        } catch let error
            as TankDrainError {

            errorMessage =
                error.errorDescription
                ?? "The drain time could not be calculated."
        } catch {
            errorMessage =
                error.localizedDescription
        }
    }

    private func makeInput() throws
        -> TankDrainInput {

        TankDrainInput(
            tankCrossSectionalArea:
                try parsePositive(
                    tankAreaText,
                    fieldName:
                        "Tank Cross-sectional Area"
                ),
            orificeArea:
                try parsePositive(
                    orificeAreaText,
                    fieldName:
                        "Orifice Area"
                ),
            dischargeCoefficient:
                try parseFractionAboveZero(
                    dischargeCoefficientText,
                    fieldName:
                        "Discharge Coefficient"
                ),
            initialLiquidHeight:
                try parseNonNegative(
                    initialHeightText,
                    fieldName:
                        "Initial Liquid Height"
                ),
            finalLiquidHeight:
                try parseNonNegative(
                    finalHeightText,
                    fieldName:
                        "Final Liquid Height"
                ),
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
            try InputValidator.parseNumber(
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
            try InputValidator.parseNumber(
                text,
                fieldName: fieldName
            )

        return try InputValidator
            .requireNonNegative(
                value,
                fieldName: fieldName
            )
    }

    private func parseFractionAboveZero(
        _ text: String,
        fieldName: String
    ) throws -> Double {

        let value =
            try parsePositive(
                text,
                fieldName: fieldName
            )

        return try InputValidator
            .requireFraction(
                value,
                fieldName: fieldName
            )
    }

    private func loadExample() {
        tankAreaText = "2"
        orificeAreaText = "0.01"
        dischargeCoefficientText = "0.62"
        initialHeightText = "2"
        finalHeightText = "0.5"
        gravityText = "9.80665"

        clearResult()
    }

    private func resetInputs() {
        tankAreaText = ""
        orificeAreaText = ""
        dischargeCoefficientText = ""
        initialHeightText = ""
        finalHeightText = ""
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
        TankDrainView()
    }
}
