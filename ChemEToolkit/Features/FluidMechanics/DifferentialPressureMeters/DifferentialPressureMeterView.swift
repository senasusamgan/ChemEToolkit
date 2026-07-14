import SwiftUI

struct DifferentialPressureMeterView:
    View {

    let meterType:
        DifferentialPressureMeterType

    @State
    private var densityText = "998"

    @State
    private var upstreamDiameterText =
        "0.1"

    @State
    private var restrictionDiameterText:
        String

    @State
    private var pressureDifferenceText:
        String

    @State
    private var dischargeCoefficientText:
        String

    @State
    private var calculationResult:
        DifferentialPressureFlowResult?

    @State
    private var errorMessage = ""

    private let engine =
        DifferentialPressureFlowEngine()

    private let numberFormatter =
        NumberFormatterService.precise

    init(
        meterType:
            DifferentialPressureMeterType
    ) {
        self.meterType = meterType

        _restrictionDiameterText =
            State(
                initialValue:
                    meterType
                        .exampleRestrictionDiameter
            )

        _pressureDifferenceText =
            State(
                initialValue:
                    meterType
                        .examplePressureDifference
            )

        _dischargeCoefficientText =
            State(
                initialValue:
                    meterType
                        .exampleDischargeCoefficient
            )
    }

    var body: some View {
        ScrollView {
            VStack(
                spacing: AppSpacing.xLarge
            ) {
                ModuleHeaderView(
                    symbolName:
                        meterType.symbolName,
                    title:
                        meterType.title,
                    subtitle:
                        meterType.subtitle,
                    tint:
                        meterType.tint
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
            meterType.title
        )
    }

    private var equationInformationCard:
        some View {

        CalculatorInfoCard(
            tint: meterType.tint
        ) {
            VStack(
                spacing: AppSpacing.small
            ) {
                Text(
                    meterType.equationTitle
                )
                .font(.headline)

                Text(
                    "Q = CᴅA₂√[2ΔP / ρ(1 − β⁴)]"
                )
                .font(
                    .system(
                        size: 21,
                        weight: .semibold
                    )
                )
                .multilineTextAlignment(.center)
                .minimumScaleFactor(0.65)

                Text("β = d₂ / D₁")
                    .font(
                        .system(
                            size: 19,
                            weight: .semibold
                        )
                    )

                Text(
                    meterType.explanation
                )
                .foregroundStyle(.secondary)
                .multilineTextAlignment(.center)

                Text(
                    "Assumes steady, incompressible flow and pressure taps at approximately equal elevation."
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

    private var calculatorContent:
        some View {

        VStack(
            alignment: .leading,
            spacing: AppSpacing.large
        ) {
            Text("Fluid & Meter Inputs")
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
                    "Upstream Pipe Diameter",
                symbol: "D₁",
                unit: "m",
                placeholder: "Example: 0.1",
                text:
                    $upstreamDiameterText
            )

            EngineeringInputField(
                title:
                    meterType
                        .restrictionFieldTitle,
                symbol: "d₂",
                unit: "m",
                placeholder:
                    "Example: \(meterType.exampleRestrictionDiameter)",
                text:
                    $restrictionDiameterText
            )

            EngineeringInputField(
                title:
                    "Measured Pressure Difference",
                symbol: "ΔP",
                unit: "Pa",
                placeholder:
                    "Example: \(meterType.examplePressureDifference)",
                text:
                    $pressureDifferenceText
            )

            EngineeringInputField(
                title:
                    "Discharge Coefficient",
                symbol: "Cᴅ",
                unit: "",
                placeholder:
                    "Example: \(meterType.exampleDischargeCoefficient)",
                text:
                    $dischargeCoefficientText
            )

            actionButtons

            PrimaryActionButton(
                title:
                    "Calculate Flow Rate",
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
            DifferentialPressureFlowResult
    ) -> some View {

        VStack(
            spacing: AppSpacing.large
        ) {
            CalculationResultCard(
                items: [
                    CalculationResultDisplayItem(
                        label:
                            "Volumetric Flow Rate",
                        value:
                            numberFormatter.format(
                                result
                                    .volumetricFlowRate
                            ),
                        unit: "m³/s"
                    ),
                    CalculationResultDisplayItem(
                        label:
                            "Volumetric Flow Rate",
                        value:
                            numberFormatter.format(
                                result
                                    .volumetricFlowRateLitresPerSecond
                            ),
                        unit: "L/s"
                    ),
                    CalculationResultDisplayItem(
                        label:
                            "Mass Flow Rate",
                        value:
                            numberFormatter.format(
                                result.massFlowRate
                            ),
                        unit: "kg/s"
                    )
                ]
            )

            CalculatorInfoCard(
                tint: meterType.tint
            ) {
                VStack(
                    spacing:
                        AppSpacing.small
                ) {
                    informationRow(
                        title:
                            "Diameter ratio",
                        value:
                            numberFormatter.format(
                                result.betaRatio
                            )
                    )

                    informationRow(
                        title:
                            "Upstream velocity",
                        value:
                            numberFormatter.format(
                                result
                                    .upstreamVelocity,
                                unit: "m/s"
                            )
                    )

                    informationRow(
                        title:
                            meterType
                                .restrictionVelocityTitle,
                        value:
                            numberFormatter.format(
                                result
                                    .restrictionVelocity,
                                unit: "m/s"
                            )
                    )

                    informationRow(
                        title:
                            "Ideal flow rate",
                        value:
                            numberFormatter.format(
                                result
                                    .idealVolumetricFlowRate,
                                unit: "m³/s"
                            )
                    )

                    informationRow(
                        title:
                            "Pressure difference",
                        value:
                            numberFormatter.format(
                                result
                                    .pressureDifferenceKilopascals,
                                unit: "kPa"
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
                    input:
                        try makeInput()
                )
        } catch let error
            as CalculationError {

            showCalculationError(error)
        } catch let error
            as DifferentialPressureFlowError {

            errorMessage =
                error.errorDescription
                ?? "The flow rate could not be calculated."
        } catch {
            errorMessage =
                error.localizedDescription
        }
    }

    private func makeInput() throws
        -> DifferentialPressureFlowInput {

        DifferentialPressureFlowInput(
            meterType:
                meterType,
            fluidDensity:
                try parsePositive(
                    densityText,
                    fieldName:
                        "Fluid Density"
                ),
            upstreamDiameter:
                try parsePositive(
                    upstreamDiameterText,
                    fieldName:
                        "Upstream Pipe Diameter"
                ),
            restrictionDiameter:
                try parsePositive(
                    restrictionDiameterText,
                    fieldName:
                        meterType
                            .restrictionFieldTitle
                ),
            pressureDifference:
                try parseNonNegative(
                    pressureDifferenceText,
                    fieldName:
                        "Measured Pressure Difference"
                ),
            dischargeCoefficient:
                try parseFractionAboveZero(
                    dischargeCoefficientText,
                    fieldName:
                        "Discharge Coefficient"
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
        densityText =
            meterType == .venturi
            ? "998"
            : "1000"

        upstreamDiameterText = "0.1"

        restrictionDiameterText =
            meterType
                .exampleRestrictionDiameter

        pressureDifferenceText =
            meterType
                .examplePressureDifference

        dischargeCoefficientText =
            meterType
                .exampleDischargeCoefficient

        clearResult()
    }

    private func resetInputs() {
        densityText = ""
        upstreamDiameterText = ""
        restrictionDiameterText = ""
        pressureDifferenceText = ""
        dischargeCoefficientText = ""

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

private extension
    DifferentialPressureMeterType {

    var title: String {
        switch self {
        case .venturi:
            return "Venturi Meter"

        case .orifice:
            return "Orifice Meter"
        }
    }

    var subtitle: String {
        switch self {
        case .venturi:
            return
                "Calculate flow rate from the pressure drop through a Venturi tube"

        case .orifice:
            return
                "Calculate flow rate from the pressure drop across an orifice plate"
        }
    }

    var equationTitle: String {
        switch self {
        case .venturi:
            return "Venturi Flow Equation"

        case .orifice:
            return "Orifice Meter Equation"
        }
    }

    var explanation: String {
        switch self {
        case .venturi:
            return
                "A gradual contraction produces a pressure difference between the upstream section and throat."

        case .orifice:
            return
                "A sharp-edged orifice plate produces a measurable pressure difference across the restriction."
        }
    }

    var restrictionFieldTitle: String {
        switch self {
        case .venturi:
            return "Throat Diameter"

        case .orifice:
            return "Orifice Diameter"
        }
    }

    var restrictionVelocityTitle:
        String {
        switch self {
        case .venturi:
            return "Throat velocity"

        case .orifice:
            return "Orifice velocity"
        }
    }

    var symbolName: String {
        switch self {
        case .venturi:
            return
                "arrow.right.and.line.vertical.and.arrow.left"

        case .orifice:
            return
                "circle.dashed"
        }
    }

    var tint: Color {
        switch self {
        case .venturi:
            return .teal

        case .orifice:
            return .orange
        }
    }

    var exampleRestrictionDiameter:
        String {
        switch self {
        case .venturi:
            return "0.05"

        case .orifice:
            return "0.04"
        }
    }

    var examplePressureDifference:
        String {
        switch self {
        case .venturi:
            return "10000"

        case .orifice:
            return "15000"
        }
    }

    var exampleDischargeCoefficient:
        String {
        switch self {
        case .venturi:
            return "0.98"

        case .orifice:
            return "0.61"
        }
    }
}

#Preview("Venturi") {
    NavigationStack {
        DifferentialPressureMeterView(
            meterType: .venturi
        )
    }
}

#Preview("Orifice") {
    NavigationStack {
        DifferentialPressureMeterView(
            meterType: .orifice
        )
    }
}
