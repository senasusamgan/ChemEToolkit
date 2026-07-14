import SwiftUI

struct FlowRateView: View {

    @State
    private var diameterText = "0.1"

    @State
    private var velocityText = "2"

    @State
    private var densityText = "998"

    @State
    private var calculationResult:
        FlowRateResult?

    @State
    private var errorMessage = ""

    private let engine =
        FlowRateEngine()

    private let numberFormatter =
        NumberFormatterService.precise

    var body: some View {
        ScrollView {
            VStack(
                spacing: AppSpacing.xLarge
            ) {
                ModuleHeaderView(
                    symbolName:
                        "arrow.right.to.line.compact",
                    title:
                        "Volumetric & Mass Flow Rate",
                    subtitle:
                        "Calculate flow through a circular pipe",
                    tint:
                        .blue
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
        .navigationTitle("Flow Rate")
    }

    private var equationInformationCard:
        some View {

        CalculatorInfoCard(
            tint: .blue
        ) {
            VStack(
                spacing: AppSpacing.small
            ) {
                Text("Circular Pipe Flow")
                    .font(.headline)

                Text("A = πD² / 4")
                    .font(
                        .system(
                            size: 21,
                            weight: .semibold
                        )
                    )

                Text("Q = Av")
                    .font(
                        .system(
                            size: 21,
                            weight: .semibold
                        )
                    )

                Text("ṁ = ρQ")
                    .font(
                        .system(
                            size: 21,
                            weight: .semibold
                        )
                    )

                Text(
                    "Velocity represents the average velocity across the pipe cross-section."
                )
                .foregroundStyle(.secondary)
                .multilineTextAlignment(.center)

                Text(
                    "All input values use SI units."
                )
                .font(.caption)
                .foregroundStyle(.secondary)
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
            Text("Pipe & Fluid Properties")
                .font(.headline)

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

            actionButtons

            PrimaryActionButton(
                title:
                    "Calculate Flow Rates",
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
        _ result: FlowRateResult
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
                        unit:
                            "m³/s"
                    ),
                    CalculationResultDisplayItem(
                        label:
                            "Mass Flow Rate",
                        value:
                            numberFormatter.format(
                                result.massFlowRate
                            ),
                        unit:
                            "kg/s"
                    ),
                    CalculationResultDisplayItem(
                        label:
                            "Cross-sectional Area",
                        value:
                            numberFormatter.format(
                                result
                                    .crossSectionalArea
                            ),
                        unit:
                            "m²"
                    )
                ]
            )

            conversionInformationCard(
                result
            )
        }
    }

    private func conversionInformationCard(
        _ result: FlowRateResult
    ) -> some View {

        CalculatorInfoCard(
            tint: .blue
        ) {
            VStack(
                spacing: AppSpacing.small
            ) {
                Text("Flow Rate Conversions")
                    .font(.headline)

                informationRow(
                    title:
                        "Litres per second",
                    value:
                        numberFormatter.format(
                            result
                                .litresPerSecond,
                            unit: "L/s"
                        )
                )

                informationRow(
                    title:
                        "Cubic metres per hour",
                    value:
                        numberFormatter.format(
                            result
                                .cubicMetresPerHour,
                            unit: "m³/h"
                        )
                )

                Divider()

                informationRow(
                    title:
                        "Average velocity",
                    value:
                        numberFormatter.format(
                            result
                                .averageVelocity,
                            unit: "m/s"
                        )
                )

                informationRow(
                    title:
                        "Fluid density",
                    value:
                        numberFormatter.format(
                            result.density,
                            unit: "kg/m³"
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
            as FlowRateError {

            errorMessage =
                error.errorDescription
                ?? "The flow rate could not be calculated."
        } catch {
            errorMessage =
                error.localizedDescription
        }
    }

    private func makeInput() throws
        -> FlowRateInput {

        let diameter =
            try parsePositive(
                diameterText,
                fieldName:
                    "Internal Pipe Diameter"
            )

        let velocity =
            try parseNonNegative(
                velocityText,
                fieldName:
                    "Average Flow Velocity"
            )

        let density =
            try parsePositive(
                densityText,
                fieldName:
                    "Fluid Density"
            )

        return FlowRateInput(
            diameter: diameter,
            averageVelocity: velocity,
            density: density
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
        diameterText = "0.1"
        velocityText = "2"
        densityText = "998"

        clearResult()
    }

    private func resetInputs() {
        diameterText = ""
        velocityText = ""
        densityText = ""

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
        FlowRateView()
    }
}
