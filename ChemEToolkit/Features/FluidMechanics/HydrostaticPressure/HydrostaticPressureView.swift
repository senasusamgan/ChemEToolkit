import SwiftUI

struct HydrostaticPressureView: View {

    @State
    private var densityText = "998"

    @State
    private var depthText = "5"

    @State
    private var surfacePressureText =
        "101325"

    @State
    private var gravityText =
        "9.80665"

    @State
    private var calculationResult:
        HydrostaticPressureResult?

    @State
    private var errorMessage = ""

    private let engine =
        HydrostaticPressureEngine()

    private let numberFormatter =
        NumberFormatterService.precise

    var body: some View {
        ScrollView {
            VStack(
                spacing: AppSpacing.xLarge
            ) {
                ModuleHeaderView(
                    symbolName:
                        "drop.circle.fill",
                    title:
                        "Hydrostatic Pressure",
                    subtitle:
                        "Calculate pressure below a stationary fluid surface",
                    tint:
                        .blue
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
            "Hydrostatic Pressure"
        )
    }

    private var equationInformationCard:
        some View {

        CalculatorInfoCard(
            tint: .blue
        ) {
            VStack(
                spacing: AppSpacing.small
            ) {
                Text(
                    "Hydrostatic Pressure Relation"
                )
                .font(.headline)

                Text(
                    "P = P₀ + ρgh"
                )
                .font(
                    .system(
                        size: 25,
                        weight: .semibold
                    )
                )

                Text(
                    "The pressure increases linearly with fluid density and vertical depth."
                )
                .foregroundStyle(.secondary)
                .multilineTextAlignment(
                    .center
                )

                Text(
                    "Enter absolute surface pressure for an absolute result, or gauge surface pressure for a gauge result."
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
            Text("Fluid & Pressure Inputs")
                .font(.headline)

            EngineeringInputField(
                title: "Fluid Density",
                symbol: "ρ",
                unit: "kg/m³",
                placeholder:
                    "Example: 998",
                text: $densityText
            )

            EngineeringInputField(
                title: "Vertical Depth",
                symbol: "h",
                unit: "m",
                placeholder:
                    "Example: 5",
                text: $depthText
            )

            EngineeringInputField(
                title: "Surface Pressure",
                symbol: "P₀",
                unit: "Pa",
                placeholder:
                    "Example: 101325",
                text:
                    $surfacePressureText
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
                    "Calculate Pressure",
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
        _ result:
            HydrostaticPressureResult
    ) -> some View {

        VStack(
            spacing: AppSpacing.large
        ) {
            CalculationResultCard(
                items: [
                    CalculationResultDisplayItem(
                        label:
                            "Pressure at Depth",
                        value:
                            numberFormatter.format(
                                result
                                    .pressureAtDepthKilopascals
                            ),
                        unit: "kPa"
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
                    ),
                    CalculationResultDisplayItem(
                        label:
                            "Pressure Head",
                        value:
                            numberFormatter.format(
                                result.pressureHead
                            ),
                        unit: "m"
                    )
                ]
            )

            CalculatorInfoCard(
                tint: .blue
            ) {
                VStack(
                    spacing:
                        AppSpacing.small
                ) {
                    informationRow(
                        title:
                            "Surface pressure",
                        value:
                            numberFormatter.format(
                                result
                                    .surfacePressureKilopascals,
                                unit: "kPa"
                            )
                    )

                    informationRow(
                        title:
                            "Vertical depth",
                        value:
                            numberFormatter.format(
                                result.depth,
                                unit: "m"
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
            as HydrostaticPressureError {

            errorMessage =
                error.errorDescription
                ?? "The pressure could not be calculated."
        } catch {
            errorMessage =
                error.localizedDescription
        }
    }

    private func makeInput() throws
        -> HydrostaticPressureInput {

        HydrostaticPressureInput(
            fluidDensity:
                try parsePositive(
                    densityText,
                    fieldName:
                        "Fluid Density"
                ),
            depth:
                try parseNonNegative(
                    depthText,
                    fieldName:
                        "Vertical Depth"
                ),
            surfacePressure:
                try InputValidator
                    .parseNumber(
                        surfacePressureText,
                        fieldName:
                            "Surface Pressure"
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
        densityText = "998"
        depthText = "5"
        surfacePressureText = "101325"
        gravityText = "9.80665"

        clearResult()
    }

    private func resetInputs() {
        densityText = ""
        depthText = ""
        surfacePressureText = ""
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
        HydrostaticPressureView()
    }
}
