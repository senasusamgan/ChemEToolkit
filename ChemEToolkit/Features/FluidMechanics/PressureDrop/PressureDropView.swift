import SwiftUI

struct PressureDropView: View {

    @State
    private var densityText = "998"

    @State
    private var velocityText = "2"

    @State
    private var diameterText = "0.1"

    @State
    private var lengthText = "50"

    @State
    private var viscosityText = "0.001"

    @State
    private var roughnessText = "0.000045"

    @State
    private var gravityText = "9.80665"

    @State
    private var calculationResult:
        PressureDropResult?

    @State
    private var errorMessage = ""

    private let engine =
        PressureDropEngine()

    private let numberFormatter =
        NumberFormatterService.precise

    var body: some View {
        ScrollView {
            VStack(
                spacing: AppSpacing.xLarge
            ) {
                ModuleHeaderView(
                    symbolName:
                        "drop.fill",
                    title:
                        "Darcy–Weisbach Pressure Drop",
                    subtitle:
                        "Calculate major pressure loss through a straight pipe",
                    tint:
                        .purple
                )

                equationInformationCard

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
            "Pressure Drop"
        )
    }

    private var equationInformationCard:
        some View {

        CalculatorInfoCard(
            tint: .purple
        ) {
            VStack(
                spacing: AppSpacing.small
            ) {
                Text(
                    "Darcy–Weisbach Equation"
                )
                .font(.headline)

                Text(
                    "hₗ = fᴅ (L/D) (v²/2g)"
                )
                .font(
                    .system(
                        size: 22,
                        weight: .semibold
                    )
                )

                Text(
                    "ΔP = ρghₗ"
                )
                .font(
                    .system(
                        size: 22,
                        weight: .semibold
                    )
                )

                Text(
                    "Reynolds number and the Darcy friction factor are calculated automatically."
                )
                .foregroundStyle(
                    .secondary
                )
                .multilineTextAlignment(
                    .center
                )

                Text(
                    "This module includes straight-pipe friction only."
                )
                .font(.caption)
                .foregroundStyle(
                    .secondary
                )
            }
            .frame(
                maxWidth: .infinity
            )
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
            fluidSection

            Divider()

            pipeSection

            Divider()

            advancedSection

            actionButtons

            PrimaryActionButton(
                title:
                    "Calculate Pressure Drop",
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
                    message:
                        errorMessage
                )
            }
        }
    }

    private var fluidSection:
        some View {

        VStack(
            alignment: .leading,
            spacing: AppSpacing.medium
        ) {
            sectionHeader(
                title:
                    "Fluid & Flow Properties",
                subtitle:
                    "Average velocity and fluid properties"
            )

            numberInputField(
                title:
                    "Fluid Density",
                symbol:
                    "ρ",
                unit:
                    "kg/m³",
                placeholder:
                    "Example: 998",
                text:
                    $densityText
            )

            numberInputField(
                title:
                    "Average Flow Velocity",
                symbol:
                    "v",
                unit:
                    "m/s",
                placeholder:
                    "Example: 2",
                text:
                    $velocityText
            )

            numberInputField(
                title:
                    "Dynamic Viscosity",
                symbol:
                    "μ",
                unit:
                    "Pa·s",
                placeholder:
                    "Example: 0.001",
                text:
                    $viscosityText
            )
        }
    }

    private var pipeSection:
        some View {

        VStack(
            alignment: .leading,
            spacing: AppSpacing.medium
        ) {
            sectionHeader(
                title:
                    "Pipe Properties",
                subtitle:
                    "Internal dimensions and surface roughness"
            )

            numberInputField(
                title:
                    "Internal Pipe Diameter",
                symbol:
                    "D",
                unit:
                    "m",
                placeholder:
                    "Example: 0.1",
                text:
                    $diameterText
            )

            numberInputField(
                title:
                    "Pipe Length",
                symbol:
                    "L",
                unit:
                    "m",
                placeholder:
                    "Example: 50",
                text:
                    $lengthText
            )

            numberInputField(
                title:
                    "Absolute Roughness",
                symbol:
                    "ε",
                unit:
                    "m",
                placeholder:
                    "Example: 0.000045",
                text:
                    $roughnessText
            )
        }
    }

    private var advancedSection:
        some View {

        DisclosureGroup {
            numberInputField(
                title:
                    "Gravitational Acceleration",
                symbol:
                    "g",
                unit:
                    "m/s²",
                placeholder:
                    "Example: 9.80665",
                text:
                    $gravityText
            )
            .padding(
                .top,
                AppSpacing.medium
            )
        } label: {
            VStack(
                alignment: .leading,
                spacing: AppSpacing.xxSmall
            ) {
                Text("Advanced Inputs")
                    .font(.headline)

                Text(
                    "Standard gravity is used by default."
                )
                .font(.caption)
                .foregroundStyle(
                    .secondary
                )
            }
        }
    }

    private func sectionHeader(
        title: String,
        subtitle: String
    ) -> some View {

        VStack(
            alignment: .leading,
            spacing: AppSpacing.xxSmall
        ) {
            Text(title)
                .font(.headline)

            Text(subtitle)
                .font(.caption)
                .foregroundStyle(
                    .secondary
                )
        }
    }

    private func numberInputField(
        title: String,
        symbol: String,
        unit: String,
        placeholder: String,
        text: Binding<String>
    ) -> some View {

        VStack(
            alignment: .leading,
            spacing: AppSpacing.xxSmall
        ) {
            HStack {
                Text(title)
                    .font(.subheadline)
                    .fontWeight(.medium)

                Spacer()

                Text(symbol)
                    .foregroundStyle(
                        .secondary
                    )
            }

            HStack(
                spacing: AppSpacing.small
            ) {
                TextField(
                    placeholder,
                    text: text
                )
                .textFieldStyle(
                    .roundedBorder
                )
                .engineeringNumberKeyboard()
                .accessibilityLabel(
                    title
                )

                Text(unit)
                    .font(.subheadline)
                    .foregroundStyle(
                        .secondary
                    )
                    .frame(
                        minWidth: 55,
                        alignment: .leading
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
                systemImage:
                    "doc.text"
            )
            .frame(
                maxWidth: .infinity
            )
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
            .frame(
                maxWidth: .infinity
            )
        }
        .buttonStyle(.bordered)
    }

    private func resultSection(
        _ result: PressureDropResult
    ) -> some View {

        VStack(
            spacing: AppSpacing.large
        ) {
            CalculationResultCard(
                items: [
                    CalculationResultDisplayItem(
                        label:
                            "Pressure Drop",
                        value:
                            numberFormatter.format(
                                result
                                    .pressureDropKilopascals
                            ),
                        unit:
                            "kPa"
                    ),
                    CalculationResultDisplayItem(
                        label:
                            "Head Loss",
                        value:
                            numberFormatter.format(
                                result.headLoss
                            ),
                        unit:
                            "m"
                    ),
                    CalculationResultDisplayItem(
                        label:
                            "Pressure Gradient",
                        value:
                            numberFormatter.format(
                                result
                                    .pressureGradient
                            ),
                        unit:
                            "Pa/m"
                    )
                ]
            )

            calculationSummaryCard(
                result
            )
        }
    }

    private func calculationSummaryCard(
        _ result: PressureDropResult
    ) -> some View {

        CalculatorInfoCard(
            tint: .purple
        ) {
            VStack(
                spacing: AppSpacing.small
            ) {
                Text("Calculation Summary")
                    .font(.headline)

                informationRow(
                    title:
                        "Flow regime",
                    value:
                        regimeTitle(
                            result.flowRegime
                        )
                )

                informationRow(
                    title:
                        "Reynolds number",
                    value:
                        numberFormatter.format(
                            result
                                .reynoldsNumber
                        )
                )

                informationRow(
                    title:
                        "Darcy friction factor",
                    value:
                        numberFormatter.format(
                            result
                                .darcyFrictionFactor
                        )
                )

                informationRow(
                    title:
                        "Fanning friction factor",
                    value:
                        numberFormatter.format(
                            result
                                .fanningFrictionFactor
                        )
                )

                informationRow(
                    title:
                        "Relative roughness",
                    value:
                        numberFormatter.format(
                            result
                                .relativeRoughness
                        )
                )

                Divider()

                informationRow(
                    title:
                        "Velocity head",
                    value:
                        numberFormatter.format(
                            result.velocityHead,
                            unit: "m"
                        )
                )

                informationRow(
                    title:
                        "Head loss per metre",
                    value:
                        numberFormatter.format(
                            result
                                .headLossPerUnitLength,
                            unit: "m/m"
                        )
                )
            }
        }
    }

    private func informationRow(
        title: String,
        value: String
    ) -> some View {

        HStack(
            alignment: .firstTextBaseline
        ) {
            Text(title)
                .foregroundStyle(
                    .secondary
                )

            Spacer()

            Text(value)
                .fontWeight(.semibold)
                .multilineTextAlignment(
                    .trailing
                )
        }
    }

    private func regimeTitle(
        _ regime: FlowRegime
    ) -> String {

        switch regime {
        case .laminar:
            return "Laminar"

        case .transitional:
            return "Transitional"

        case .turbulent:
            return "Turbulent"
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

            showCalculationError(
                error
            )
        } catch let error
            as PressureDropError {

            errorMessage =
                error.errorDescription
                ?? "The pressure drop could not be calculated."
        } catch let error
            as ReynoldsNumberError {

            errorMessage =
                error.errorDescription
                ?? "The Reynolds number could not be calculated."
        } catch let error
            as FrictionFactorError {

            errorMessage =
                error.errorDescription
                ?? "The friction factor could not be calculated."
        } catch {
            errorMessage =
                error.localizedDescription
        }
    }

    private func makeInput() throws
        -> PressureDropInput {

        PressureDropInput(
            density:
                try parsePositive(
                    densityText,
                    fieldName:
                        "Fluid Density"
                ),
            averageVelocity:
                try parsePositive(
                    velocityText,
                    fieldName:
                        "Average Flow Velocity"
                ),
            pipeDiameter:
                try parsePositive(
                    diameterText,
                    fieldName:
                        "Internal Pipe Diameter"
                ),
            pipeLength:
                try parsePositive(
                    lengthText,
                    fieldName:
                        "Pipe Length"
                ),
            dynamicViscosity:
                try parsePositive(
                    viscosityText,
                    fieldName:
                        "Dynamic Viscosity"
                ),
            absoluteRoughness:
                try parseNonNegative(
                    roughnessText,
                    fieldName:
                        "Absolute Roughness"
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
                    fieldName:
                        fieldName
                )

        return try InputValidator
            .requirePositive(
                value,
                fieldName:
                    fieldName
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
                    fieldName:
                        fieldName
                )

        return try InputValidator
            .requireNonNegative(
                value,
                fieldName:
                    fieldName
            )
    }

    private func loadExample() {
        densityText = "998"
        velocityText = "2"
        diameterText = "0.1"
        lengthText = "50"
        viscosityText = "0.001"
        roughnessText = "0.000045"
        gravityText = "9.80665"

        clearResult()
    }

    private func resetInputs() {
        densityText = ""
        velocityText = ""
        diameterText = ""
        lengthText = ""
        viscosityText = ""
        roughnessText = ""
        gravityText = ""

        clearResult()
    }

    private func showCalculationError(
        _ error: CalculationError
    ) {
        let description =
            error.errorDescription
            ?? "The input values could not be processed."

        if let suggestion =
            error.recoverySuggestion {

            errorMessage =
                "\(description) \(suggestion)"
        } else {
            errorMessage =
                description
        }
    }

    private func clearResult() {
        calculationResult = nil
        errorMessage = ""
    }
}

#Preview {
    NavigationStack {
        PressureDropView()
    }
}
