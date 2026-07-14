import SwiftUI

struct FroudeNumberView: View {

    @State
    private var velocityText = "2"

    @State
    private var hydraulicDepthText =
        "1.2"

    @State
    private var gravityText =
        "9.80665"

    @State
    private var calculationResult:
        FroudeNumberResult?

    @State
    private var errorMessage = ""

    private let engine =
        FroudeNumberEngine()

    private let numberFormatter =
        NumberFormatterService.precise

    var body: some View {
        ScrollView {
            VStack(
                spacing: AppSpacing.xLarge
            ) {
                ModuleHeaderView(
                    symbolName:
                        "water.waves",
                    title:
                        "Froude Number",
                    subtitle:
                        "Classify subcritical, critical and supercritical open-channel flow",
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
            "Froude Number"
        )
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
                    "Open-Channel Flow Regime"
                )
                .font(.headline)

                Text(
                    "Fr = v / √(gDₕ)"
                )
                .font(
                    .system(
                        size: 25,
                        weight: .semibold
                    )
                )

                Text(
                    "For a rectangular channel, hydraulic depth equals the liquid depth."
                )
                .foregroundStyle(.secondary)
                .multilineTextAlignment(
                    .center
                )

                Text(
                    "Fr < 1: Subcritical   •   Fr = 1: Critical   •   Fr > 1: Supercritical"
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
            Text("Flow Properties")
                .font(.headline)

            EngineeringInputField(
                title:
                    "Average Flow Velocity",
                symbol: "v",
                unit: "m/s",
                placeholder:
                    "Example: 2",
                text: $velocityText
            )

            EngineeringInputField(
                title:
                    "Hydraulic Depth",
                symbol: "Dₕ",
                unit: "m",
                placeholder:
                    "Example: 1.2",
                text:
                    $hydraulicDepthText
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
                    "Calculate Froude Number",
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
            FroudeNumberResult
    ) -> some View {

        VStack(
            spacing: AppSpacing.large
        ) {
            CalculationResultCard(
                items: [
                    CalculationResultDisplayItem(
                        label:
                            "Froude Number",
                        value:
                            numberFormatter.format(
                                result.froudeNumber
                            ),
                        unit: ""
                    ),
                    CalculationResultDisplayItem(
                        label:
                            "Flow Regime",
                        value:
                            regimeTitle(
                                result.flowRegime
                            ),
                        unit: ""
                    ),
                    CalculationResultDisplayItem(
                        label:
                            "Wave Celerity",
                        value:
                            numberFormatter.format(
                                result
                                    .gravityWaveCelerity
                            ),
                        unit: "m/s"
                    )
                ]
            )

            CalculatorInfoCard(
                tint:
                    regimeTint(
                        result.flowRegime
                    )
            ) {
                VStack(
                    spacing:
                        AppSpacing.small
                ) {
                    Text(
                        regimeTitle(
                            result.flowRegime
                        )
                    )
                    .font(.headline)

                    Text(
                        regimeExplanation(
                            result.flowRegime
                        )
                    )
                    .foregroundStyle(.secondary)
                    .multilineTextAlignment(
                        .center
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
                            "Hydraulic depth",
                        value:
                            numberFormatter.format(
                                result
                                    .hydraulicDepth,
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

    private func regimeTitle(
        _ regime:
            OpenChannelFlowRegime
    ) -> String {

        switch regime {
        case .subcritical:
            return "Subcritical"

        case .critical:
            return "Critical"

        case .supercritical:
            return "Supercritical"
        }
    }

    private func regimeExplanation(
        _ regime:
            OpenChannelFlowRegime
    ) -> String {

        switch regime {
        case .subcritical:
            return
                "The flow is relatively deep and slow. Surface disturbances can travel upstream."

        case .critical:
            return
                "The flow velocity equals the gravity-wave celerity."

        case .supercritical:
            return
                "The flow is relatively shallow and fast. Disturbances cannot travel upstream."
        }
    }

    private func regimeTint(
        _ regime:
            OpenChannelFlowRegime
    ) -> Color {

        switch regime {
        case .subcritical:
            return .blue

        case .critical:
            return .orange

        case .supercritical:
            return .red
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
            as FroudeNumberError {

            errorMessage =
                error.errorDescription
                ?? "The Froude number could not be calculated."
        } catch {
            errorMessage =
                error.localizedDescription
        }
    }

    private func makeInput() throws
        -> FroudeNumberInput {

        FroudeNumberInput(
            averageVelocity:
                try parseNonNegative(
                    velocityText,
                    fieldName:
                        "Average Flow Velocity"
                ),
            hydraulicDepth:
                try parsePositive(
                    hydraulicDepthText,
                    fieldName:
                        "Hydraulic Depth"
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

    private func loadExample() {
        velocityText = "2"
        hydraulicDepthText = "1.2"
        gravityText = "9.80665"

        clearResult()
    }

    private func resetInputs() {
        velocityText = ""
        hydraulicDepthText = ""
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
        FroudeNumberView()
    }
}
