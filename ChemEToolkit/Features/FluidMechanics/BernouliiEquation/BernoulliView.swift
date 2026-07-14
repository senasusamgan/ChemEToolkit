import SwiftUI

struct BernoulliView: View {

    @State
    private var densityText = "998"

    @State
    private var gravityText = "9.80665"

    @State
    private var inletPressureText = "250000"

    @State
    private var inletVelocityText = "1.5"

    @State
    private var inletElevationText = "2"

    @State
    private var outletVelocityText = "3"

    @State
    private var outletElevationText = "7"

    @State
    private var pumpHeadText = "12"

    @State
    private var turbineHeadText = "2"

    @State
    private var headLossText = "4"

    @State
    private var inletCorrectionFactorText = "1"

    @State
    private var outletCorrectionFactorText = "1"

    @State
    private var calculationResult:
        BernoulliResult?

    @State
    private var errorMessage = ""

    private let engine =
        BernoulliEngine()

    private let numberFormatter =
        NumberFormatterService.precise

    var body: some View {
        ScrollView {
            VStack(
                spacing: AppSpacing.xLarge
            ) {
                ModuleHeaderView(
                    symbolName:
                        "arrow.left.arrow.right.circle.fill",
                    title:
                        "Bernoulli Equation",
                    subtitle:
                        "Calculate outlet pressure using the extended energy equation",
                    tint:
                        .teal
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
            "Bernoulli Equation"
        )
    }

    private var equationInformationCard:
        some View {

        CalculatorInfoCard(
            tint: .teal
        ) {
            VStack(
                spacing: AppSpacing.small
            ) {
                Text(
                    "Extended Bernoulli Equation"
                )
                .font(.headline)

                Text(
                    "P₁/ρg + α₁v₁²/2g + z₁ + hₚ = P₂/ρg + α₂v₂²/2g + z₂ + hₜ + hₗ"
                )
                .font(
                    .system(
                        size: 19,
                        weight: .semibold
                    )
                )
                .multilineTextAlignment(
                    .center
                )
                .minimumScaleFactor(0.6)

                Text(
                    "Assumes steady, incompressible flow between two locations."
                )
                .foregroundStyle(
                    .secondary
                )
                .multilineTextAlignment(
                    .center
                )

                Text(
                    "Use the same pressure reference at both points, such as gauge pressure."
                )
                .font(.caption)
                .foregroundStyle(
                    .secondary
                )
                .multilineTextAlignment(
                    .center
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
            fluidPropertiesSection

            Divider()

            inletSection

            Divider()

            outletSection

            Divider()

            energySection

            Divider()

            advancedSection

            actionButtons

            PrimaryActionButton(
                title:
                    "Calculate Outlet Pressure",
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

    private var fluidPropertiesSection:
        some View {

        VStack(
            alignment: .leading,
            spacing: AppSpacing.medium
        ) {
            sectionHeader(
                title: "Fluid Properties",
                subtitle:
                    "Density and gravitational acceleration"
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
                    "Gravity",
                symbol:
                    "g",
                unit:
                    "m/s²",
                placeholder:
                    "Example: 9.80665",
                text:
                    $gravityText
            )
        }
    }

    private var inletSection:
        some View {

        VStack(
            alignment: .leading,
            spacing: AppSpacing.medium
        ) {
            sectionHeader(
                title: "Point 1 — Inlet",
                subtitle:
                    "Known pressure, velocity and elevation"
            )

            numberInputField(
                title:
                    "Inlet Pressure",
                symbol:
                    "P₁",
                unit:
                    "Pa",
                placeholder:
                    "Example: 250000",
                text:
                    $inletPressureText
            )

            numberInputField(
                title:
                    "Inlet Velocity",
                symbol:
                    "v₁",
                unit:
                    "m/s",
                placeholder:
                    "Example: 1.5",
                text:
                    $inletVelocityText
            )

            numberInputField(
                title:
                    "Inlet Elevation",
                symbol:
                    "z₁",
                unit:
                    "m",
                placeholder:
                    "Example: 2",
                text:
                    $inletElevationText
            )
        }
    }

    private var outletSection:
        some View {

        VStack(
            alignment: .leading,
            spacing: AppSpacing.medium
        ) {
            sectionHeader(
                title: "Point 2 — Outlet",
                subtitle:
                    "Enter velocity and elevation to solve for pressure"
            )

            numberInputField(
                title:
                    "Outlet Velocity",
                symbol:
                    "v₂",
                unit:
                    "m/s",
                placeholder:
                    "Example: 3",
                text:
                    $outletVelocityText
            )

            numberInputField(
                title:
                    "Outlet Elevation",
                symbol:
                    "z₂",
                unit:
                    "m",
                placeholder:
                    "Example: 7",
                text:
                    $outletElevationText
            )
        }
    }

    private var energySection:
        some View {

        VStack(
            alignment: .leading,
            spacing: AppSpacing.medium
        ) {
            sectionHeader(
                title: "Machines & Losses",
                subtitle:
                    "Enter zero when a term is not present"
            )

            numberInputField(
                title:
                    "Pump Head",
                symbol:
                    "hₚ",
                unit:
                    "m",
                placeholder:
                    "Example: 12",
                text:
                    $pumpHeadText
            )

            numberInputField(
                title:
                    "Turbine Head",
                symbol:
                    "hₜ",
                unit:
                    "m",
                placeholder:
                    "Example: 2",
                text:
                    $turbineHeadText
            )

            numberInputField(
                title:
                    "Head Loss",
                symbol:
                    "hₗ",
                unit:
                    "m",
                placeholder:
                    "Example: 4",
                text:
                    $headLossText
            )
        }
    }

    private var advancedSection:
        some View {

        DisclosureGroup {
            VStack(
                spacing: AppSpacing.medium
            ) {
                numberInputField(
                    title:
                        "Inlet Correction Factor",
                    symbol:
                        "α₁",
                    unit:
                        "",
                    placeholder:
                        "Example: 1",
                    text:
                        $inletCorrectionFactorText
                )

                numberInputField(
                    title:
                        "Outlet Correction Factor",
                    symbol:
                        "α₂",
                    unit:
                        "",
                    placeholder:
                        "Example: 1",
                    text:
                        $outletCorrectionFactorText
                )
            }
            .padding(.top, AppSpacing.medium)
        } label: {
            VStack(
                alignment: .leading,
                spacing: AppSpacing.xxSmall
            ) {
                Text("Advanced Inputs")
                    .font(.headline)

                Text(
                    "Kinetic-energy correction factors default to 1."
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
            HStack(
                alignment: .firstTextBaseline
            ) {
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

                if !unit.isEmpty {
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
        _ result: BernoulliResult
    ) -> some View {

        VStack(
            spacing: AppSpacing.large
        ) {
            CalculationResultCard(
                items: [
                    CalculationResultDisplayItem(
                        label:
                            "Outlet Pressure",
                        value:
                            numberFormatter.format(
                                result.outletPressure
                                / 1_000
                            ),
                        unit:
                            "kPa"
                    ),
                    CalculationResultDisplayItem(
                        label:
                            "Pressure Change",
                        value:
                            numberFormatter.format(
                                result.pressureChange
                                / 1_000
                            ),
                        unit:
                            "kPa"
                    ),
                    CalculationResultDisplayItem(
                        label:
                            "Outlet Pressure Head",
                        value:
                            numberFormatter.format(
                                result
                                    .outletPressureHead
                            ),
                        unit:
                            "m"
                    )
                ]
            )

            headSummaryCard(result)
        }
    }

    private func headSummaryCard(
        _ result: BernoulliResult
    ) -> some View {

        CalculatorInfoCard(
            tint: .teal
        ) {
            VStack(
                spacing: AppSpacing.small
            ) {
                Text("Energy Head Summary")
                    .font(.headline)

                informationRow(
                    title:
                        "Inlet pressure head",
                    value:
                        formattedHead(
                            result
                                .inletPressureHead
                        )
                )

                informationRow(
                    title:
                        "Inlet velocity head",
                    value:
                        formattedHead(
                            result
                                .inletVelocityHead
                        )
                )

                informationRow(
                    title:
                        "Inlet elevation head",
                    value:
                        formattedHead(
                            result
                                .inletElevationHead
                        )
                )

                Divider()

                informationRow(
                    title:
                        "Pump head added",
                    value:
                        formattedHead(
                            result.pumpHead
                        )
                )

                informationRow(
                    title:
                        "Turbine head removed",
                    value:
                        formattedHead(
                            result.turbineHead
                        )
                )

                informationRow(
                    title:
                        "Head loss",
                    value:
                        formattedHead(
                            result.headLoss
                        )
                )

                Divider()

                informationRow(
                    title:
                        "Outlet velocity head",
                    value:
                        formattedHead(
                            result
                                .outletVelocityHead
                        )
                )

                informationRow(
                    title:
                        "Outlet elevation head",
                    value:
                        formattedHead(
                            result
                                .outletElevationHead
                        )
                )

                informationRow(
                    title:
                        "Inlet total head",
                    value:
                        formattedHead(
                            result
                                .inletTotalHead
                        )
                )

                informationRow(
                    title:
                        "Balanced outlet head",
                    value:
                        formattedHead(
                            result
                                .outletTotalHead
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

    private func formattedHead(
        _ value: Double
    ) -> String {

        numberFormatter.format(
            value,
            unit: "m"
        )
    }

    private func calculate() {
        clearResult()

        do {
            let input =
                try makeInput()

            calculationResult =
                try engine.solve(
                    input: input
                )
        } catch let error
            as CalculationError {

            showCalculationError(
                error
            )
        } catch let error
            as BernoulliError {

            errorMessage =
                error.errorDescription
                ?? "The Bernoulli calculation could not be completed."
        } catch {
            errorMessage =
                error.localizedDescription
        }
    }

    private func makeInput() throws
        -> BernoulliInput {

        let density =
            try parsePositive(
                densityText,
                fieldName:
                    "Fluid Density"
            )

        let gravity =
            try parsePositive(
                gravityText,
                fieldName:
                    "Gravity"
            )

        let inletPressure =
            try parseNumber(
                inletPressureText,
                fieldName:
                    "Inlet Pressure"
            )

        let inletVelocity =
            try parseNonNegative(
                inletVelocityText,
                fieldName:
                    "Inlet Velocity"
            )

        let inletElevation =
            try parseNumber(
                inletElevationText,
                fieldName:
                    "Inlet Elevation"
            )

        let outletVelocity =
            try parseNonNegative(
                outletVelocityText,
                fieldName:
                    "Outlet Velocity"
            )

        let outletElevation =
            try parseNumber(
                outletElevationText,
                fieldName:
                    "Outlet Elevation"
            )

        let pumpHead =
            try parseNonNegative(
                pumpHeadText,
                fieldName:
                    "Pump Head"
            )

        let turbineHead =
            try parseNonNegative(
                turbineHeadText,
                fieldName:
                    "Turbine Head"
            )

        let headLoss =
            try parseNonNegative(
                headLossText,
                fieldName:
                    "Head Loss"
            )

        let inletCorrectionFactor =
            try parsePositive(
                inletCorrectionFactorText,
                fieldName:
                    "Inlet Correction Factor"
            )

        let outletCorrectionFactor =
            try parsePositive(
                outletCorrectionFactorText,
                fieldName:
                    "Outlet Correction Factor"
            )

        return BernoulliInput(
            density: density,
            gravity: gravity,
            inlet: BernoulliPoint(
                pressure:
                    inletPressure,
                velocity:
                    inletVelocity,
                elevation:
                    inletElevation,
                kineticEnergyCorrectionFactor:
                    inletCorrectionFactor
            ),
            outletVelocity:
                outletVelocity,
            outletElevation:
                outletElevation,
            outletKineticEnergyCorrectionFactor:
                outletCorrectionFactor,
            pumpHead:
                pumpHead,
            turbineHead:
                turbineHead,
            headLoss:
                headLoss
        )
    }

    private func parseNumber(
        _ text: String,
        fieldName: String
    ) throws -> Double {

        try InputValidator.parseNumber(
            text,
            fieldName: fieldName
        )
    }

    private func parsePositive(
        _ text: String,
        fieldName: String
    ) throws -> Double {

        let value =
            try parseNumber(
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
            try parseNumber(
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
        gravityText = "9.80665"

        inletPressureText = "250000"
        inletVelocityText = "1.5"
        inletElevationText = "2"

        outletVelocityText = "3"
        outletElevationText = "7"

        pumpHeadText = "12"
        turbineHeadText = "2"
        headLossText = "4"

        inletCorrectionFactorText = "1"
        outletCorrectionFactorText = "1"

        clearResult()
    }

    private func resetInputs() {
        densityText = ""
        gravityText = ""

        inletPressureText = ""
        inletVelocityText = ""
        inletElevationText = ""

        outletVelocityText = ""
        outletElevationText = ""

        pumpHeadText = ""
        turbineHeadText = ""
        headLossText = ""

        inletCorrectionFactorText = ""
        outletCorrectionFactorText = ""

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
        BernoulliView()
    }
}
