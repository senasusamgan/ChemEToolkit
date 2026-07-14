import SwiftUI

struct FrictionFactorView: View {

    @State
    private var reynoldsNumberText =
        "100000"

    @State
    private var diameterText =
        "0.1"

    @State
    private var roughnessText =
        "0.000045"

    @State
    private var calculationResult:
        FrictionFactorResult?

    @State
    private var errorMessage = ""

    private let engine =
        FrictionFactorEngine()

    private let numberFormatter =
        NumberFormatterService.precise

    var body: some View {
        ScrollView {
            VStack(
                spacing: AppSpacing.xLarge
            ) {
                ModuleHeaderView(
                    symbolName:
                        "line.3.horizontal.decrease.circle.fill",
                    title:
                        "Pipe Friction Factor",
                    subtitle:
                        "Calculate Darcy and Fanning friction factors",
                    tint:
                        .indigo
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
            "Friction Factor"
        )
    }

    private var equationInformationCard:
        some View {

        CalculatorInfoCard(
            tint: .indigo
        ) {
            VStack(
                spacing: AppSpacing.small
            ) {
                Text(
                    "Darcy Friction Factor"
                )
                .font(.headline)

                Text(
                    "Laminar: fᴅ = 64 / Re"
                )
                .font(
                    .system(
                        size: 20,
                        weight: .semibold
                    )
                )

                Text(
                    "Turbulent: Colebrook–White equation"
                )
                .font(
                    .system(
                        size: 20,
                        weight: .semibold
                    )
                )
                .multilineTextAlignment(
                    .center
                )

                Text(
                    "1/√fᴅ = −2 log₁₀[ε/(3.7D) + 2.51/(Re√fᴅ)]"
                )
                .font(.subheadline)
                .multilineTextAlignment(
                    .center
                )
                .minimumScaleFactor(0.65)

                Text(
                    "Transitional flow is reported without applying an uncertain correlation."
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
            Text("Flow & Pipe Properties")
                .font(.headline)

            numberInputField(
                title:
                    "Reynolds Number",
                symbol:
                    "Re",
                unit:
                    "",
                placeholder:
                    "Example: 100000",
                text:
                    $reynoldsNumberText
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

            actionButtons

            PrimaryActionButton(
                title:
                    "Calculate Friction Factor",
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
        _ result:
            FrictionFactorResult
    ) -> some View {

        VStack(
            spacing: AppSpacing.large
        ) {
            CalculationResultCard(
                items: [
                    CalculationResultDisplayItem(
                        label:
                            "Darcy Friction Factor",
                        value:
                            numberFormatter.format(
                                result
                                    .darcyFrictionFactor
                            ),
                        unit:
                            ""
                    ),
                    CalculationResultDisplayItem(
                        label:
                            "Fanning Friction Factor",
                        value:
                            numberFormatter.format(
                                result
                                    .fanningFrictionFactor
                            ),
                        unit:
                            ""
                    ),
                    CalculationResultDisplayItem(
                        label:
                            "Relative Roughness",
                        value:
                            numberFormatter.format(
                                result
                                    .relativeRoughness
                            ),
                        unit:
                            "ε/D"
                    )
                ]
            )

            resultInformationCard(
                result
            )
        }
    }

    private func resultInformationCard(
        _ result:
            FrictionFactorResult
    ) -> some View {

        CalculatorInfoCard(
            tint: .indigo
        ) {
            VStack(
                spacing: AppSpacing.small
            ) {
                Text(
                    regimeTitle(
                        result.flowRegime
                    )
                )
                .font(.headline)

                informationRow(
                    title:
                        "Equation",
                    value:
                        equationDescription(
                            result
                        )
                )

                informationRow(
                    title:
                        "Iterations",
                    value:
                        iterationDescription(
                            result
                        )
                )

                informationRow(
                    title:
                        "Absolute roughness",
                    value:
                        numberFormatter.format(
                            result
                                .absoluteRoughness,
                            unit: "m"
                        )
                )

                informationRow(
                    title:
                        "Pipe diameter",
                    value:
                        numberFormatter.format(
                            result
                                .pipeDiameter,
                            unit: "m"
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

    private func equationDescription(
        _ result:
            FrictionFactorResult
    ) -> String {

        if result.usedIterativeEquation {
            return "Colebrook–White"
        }

        return "fᴅ = 64 / Re"
    }

    private func iterationDescription(
        _ result:
            FrictionFactorResult
    ) -> String {

        if result.usedIterativeEquation {
            return
                "\(result.iterationCount)"
        }

        return "Direct equation"
    }

    private func regimeTitle(
        _ regime: FlowRegime
    ) -> String {

        switch regime {
        case .laminar:
            return "Laminar Flow"

        case .transitional:
            return "Transitional Flow"

        case .turbulent:
            return "Turbulent Flow"
        }
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
        -> FrictionFactorInput {

        let reynoldsNumber =
            try parsePositive(
                reynoldsNumberText,
                fieldName:
                    "Reynolds Number"
            )

        let diameter =
            try parsePositive(
                diameterText,
                fieldName:
                    "Internal Pipe Diameter"
            )

        let roughness =
            try parseNonNegative(
                roughnessText,
                fieldName:
                    "Absolute Roughness"
            )

        return FrictionFactorInput(
            reynoldsNumber:
                reynoldsNumber,
            pipeDiameter:
                diameter,
            absoluteRoughness:
                roughness
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
        reynoldsNumberText =
            "100000"

        diameterText =
            "0.1"

        roughnessText =
            "0.000045"

        clearResult()
    }

    private func resetInputs() {
        reynoldsNumberText = ""
        diameterText = ""
        roughnessText = ""

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
        FrictionFactorView()
    }
}
