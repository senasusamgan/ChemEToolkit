import SwiftUI

struct ManometerView: View {

    @State
    private var processDensityText =
        "998"

    @State
    private var manometerDensityText =
        "13600"

    @State
    private var heightDifferenceText =
        "0.15"

    @State
    private var gravityText =
        "9.80665"

    @State
    private var lowerLevelSide:
        ManometerSide = .left

    @State
    private var calculationResult:
        ManometerResult?

    @State
    private var errorMessage = ""

    private let engine =
        ManometerEngine()

    private let numberFormatter =
        NumberFormatterService.precise

    var body: some View {
        ScrollView {
            VStack(
                spacing: AppSpacing.xLarge
            ) {
                ModuleHeaderView(
                    symbolName:
                        "gauge.medium",
                    title:
                        "U-Tube Manometer",
                    subtitle:
                        "Calculate pressure difference from liquid-column displacement",
                    tint:
                        .cyan
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
        .navigationTitle(
            "U-Tube Manometer"
        )
        .onChange(
            of: lowerLevelSide
        ) { _, _ in
            clearResult()
        }
    }

    private var equationInformationCard:
        some View {

        CalculatorInfoCard(
            tint: .cyan
        ) {
            VStack(
                spacing: AppSpacing.small
            ) {
                Text(
                    "Differential Manometer"
                )
                .font(.headline)

                Text(
                    "ΔP = (ρₘ − ρ𝒇)gΔh"
                )
                .font(
                    .system(
                        size: 24,
                        weight: .semibold
                    )
                )

                Text(
                    "The lower manometer-fluid level is located on the higher-pressure side."
                )
                .foregroundStyle(.secondary)
                .multilineTextAlignment(
                    .center
                )

                Text(
                    "Assumes identical process fluid above both legs and pressure taps at equal elevation."
                )
                .font(.caption)
                .foregroundStyle(.secondary)
                .multilineTextAlignment(
                    .center
                )
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
            Text("Fluid Properties")
                .font(.headline)

            EngineeringInputField(
                title:
                    "Process Fluid Density",
                symbol: "ρ𝒇",
                unit: "kg/m³",
                placeholder:
                    "Example: 998",
                text:
                    $processDensityText
            )

            EngineeringInputField(
                title:
                    "Manometer Fluid Density",
                symbol: "ρₘ",
                unit: "kg/m³",
                placeholder:
                    "Example: 13600",
                text:
                    $manometerDensityText
            )

            Divider()

            Text("Column Displacement")
                .font(.headline)

            EngineeringInputField(
                title:
                    "Vertical Height Difference",
                symbol: "Δh",
                unit: "m",
                placeholder:
                    "Example: 0.15",
                text:
                    $heightDifferenceText
            )

            VStack(
                alignment: .leading,
                spacing: AppSpacing.small
            ) {
                Text(
                    "Side with Lower Manometer Level"
                )
                .font(.subheadline)
                .fontWeight(.medium)

                Picker(
                    "Lower Manometer Level",
                    selection:
                        $lowerLevelSide
                ) {
                    ForEach(
                        ManometerSide.allCases
                    ) { side in
                        Text(side.title)
                            .tag(side)
                    }
                }
                .pickerStyle(.segmented)
            }

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
                    "Calculate Pressure Difference",
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
        _ result: ManometerResult
    ) -> some View {

        VStack(
            spacing: AppSpacing.large
        ) {
            CalculationResultCard(
                items: [
                    CalculationResultDisplayItem(
                        label:
                            "Pressure Difference",
                        value:
                            numberFormatter.format(
                                result
                                    .pressureDifferenceKilopascals
                            ),
                        unit: "kPa"
                    ),
                    CalculationResultDisplayItem(
                        label:
                            "Pressure Difference",
                        value:
                            numberFormatter.format(
                                result
                                    .pressureDifference
                            ),
                        unit: "Pa"
                    ),
                    CalculationResultDisplayItem(
                        label:
                            "Pressure Relationship",
                        value:
                            relationshipTitle(
                                result
                            ),
                        unit: ""
                    )
                ]
            )

            CalculatorInfoCard(
                tint: .cyan
            ) {
                VStack(
                    spacing:
                        AppSpacing.small
                ) {
                    informationRow(
                        title:
                            "Density difference",
                        value:
                            numberFormatter.format(
                                result
                                    .densityDifference,
                                unit: "kg/m³"
                            )
                    )

                    informationRow(
                        title:
                            "Height difference",
                        value:
                            numberFormatter.format(
                                result
                                    .heightDifference,
                                unit: "m"
                            )
                    )

                    Divider()

                    Text(
                        relationshipExplanation(
                            result
                        )
                    )
                    .foregroundStyle(.secondary)
                    .multilineTextAlignment(
                        .center
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
        }
    }

    private func relationshipTitle(
        _ result: ManometerResult
    ) -> String {

        guard let higherSide =
                result.higherPressureSide
        else {
            return "Equal Pressure"
        }

        return
            "\(higherSide.title) Side Higher"
    }

    private func relationshipExplanation(
        _ result: ManometerResult
    ) -> String {

        guard
            let higherSide =
                result.higherPressureSide,
            let lowerSide =
                result.lowerPressureSide
        else {
            return
                "Both sides are at the same pressure because the height difference is zero."
        }

        return
            "The \(higherSide.title.lowercased()) side pressure exceeds the \(lowerSide.title.lowercased()) side pressure by \(numberFormatter.format(result.pressureDifferenceKilopascals, unit: "kPa"))."
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
            as ManometerError {

            errorMessage =
                error.errorDescription
                ?? "The pressure difference could not be calculated."
        } catch {
            errorMessage =
                error.localizedDescription
        }
    }

    private func makeInput() throws
        -> ManometerInput {

        ManometerInput(
            processFluidDensity:
                try parsePositive(
                    processDensityText,
                    fieldName:
                        "Process Fluid Density"
                ),
            manometerFluidDensity:
                try parsePositive(
                    manometerDensityText,
                    fieldName:
                        "Manometer Fluid Density"
                ),
            heightDifference:
                try parseNonNegative(
                    heightDifferenceText,
                    fieldName:
                        "Vertical Height Difference"
                ),
            lowerLevelSide:
                lowerLevelSide,
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

    private func loadExample() {
        processDensityText = "998"
        manometerDensityText = "13600"
        heightDifferenceText = "0.15"
        gravityText = "9.80665"
        lowerLevelSide = .left

        clearResult()
    }

    private func resetInputs() {
        processDensityText = ""
        manometerDensityText = ""
        heightDifferenceText = ""
        gravityText = ""
        lowerLevelSide = .left

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
        ManometerView()
    }
}
