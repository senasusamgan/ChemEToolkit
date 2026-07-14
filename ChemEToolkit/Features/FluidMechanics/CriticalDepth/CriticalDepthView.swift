import SwiftUI

struct CriticalDepthView: View {

    @State
    private var flowRateText =
        "6.6829"

    @State
    private var channelWidthText =
        "3"

    @State
    private var currentDepthText =
        "1.2"

    @State
    private var gravityText =
        "9.80665"

    @State
    private var calculationResult:
        CriticalDepthResult?

    @State
    private var errorMessage = ""

    private let engine =
        CriticalDepthEngine()

    private let numberFormatter =
        NumberFormatterService.precise

    var body: some View {
        ScrollView {
            VStack(
                spacing: AppSpacing.xLarge
            ) {
                ModuleHeaderView(
                    symbolName: "ruler.fill",
                    title:
                        "Critical Depth",
                    subtitle:
                        "Calculate critical depth and specific energy in a rectangular channel",
                    tint:
                        .indigo
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
            "Critical Depth"
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
                    "Rectangular Channel"
                )
                .font(.headline)

                Text(
                    "y꜀ = [Q²/(gb²)]¹ᐟ³"
                )
                .font(
                    .system(
                        size: 24,
                        weight: .semibold
                    )
                )

                Text(
                    "E = y + v²/(2g)"
                )
                .font(
                    .system(
                        size: 21,
                        weight: .semibold
                    )
                )

                Text(
                    "Critical depth corresponds to the minimum specific energy for a given flow rate."
                )
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
            Text("Channel & Flow Inputs")
                .font(.headline)

            EngineeringInputField(
                title:
                    "Volumetric Flow Rate",
                symbol: "Q",
                unit: "m³/s",
                placeholder:
                    "Example: 6.6829",
                text: $flowRateText
            )

            EngineeringInputField(
                title:
                    "Channel Width",
                symbol: "b",
                unit: "m",
                placeholder:
                    "Example: 3",
                text:
                    $channelWidthText
            )

            EngineeringInputField(
                title:
                    "Current Flow Depth",
                symbol: "y",
                unit: "m",
                placeholder:
                    "Example: 1.2",
                text:
                    $currentDepthText
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
                    "Calculate Critical Depth",
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
            CriticalDepthResult
    ) -> some View {

        VStack(
            spacing: AppSpacing.large
        ) {
            CalculationResultCard(
                items: [
                    CalculationResultDisplayItem(
                        label:
                            "Critical Depth",
                        value:
                            numberFormatter.format(
                                result.criticalDepth
                            ),
                        unit: "m"
                    ),
                    CalculationResultDisplayItem(
                        label:
                            "Minimum Specific Energy",
                        value:
                            numberFormatter.format(
                                result
                                    .minimumSpecificEnergy
                            ),
                        unit: "m"
                    ),
                    CalculationResultDisplayItem(
                        label:
                            "Current Specific Energy",
                        value:
                            numberFormatter.format(
                                result
                                    .currentSpecificEnergy
                            ),
                        unit: "m"
                    ),
                    CalculationResultDisplayItem(
                        label:
                            "Current Flow Regime",
                        value:
                            regimeTitle(
                                result.flowRegime
                            ),
                        unit: ""
                    )
                ]
            )

            CalculatorInfoCard(
                tint: .indigo
            ) {
                VStack(
                    spacing:
                        AppSpacing.small
                ) {
                    informationRow(
                        title:
                            "Critical velocity",
                        value:
                            numberFormatter.format(
                                result
                                    .criticalVelocity,
                                unit: "m/s"
                            )
                    )

                    informationRow(
                        title:
                            "Current velocity",
                        value:
                            numberFormatter.format(
                                result
                                    .currentVelocity,
                                unit: "m/s"
                            )
                    )

                    informationRow(
                        title:
                            "Current Froude number",
                        value:
                            numberFormatter.format(
                                result
                                    .currentFroudeNumber
                            )
                    )

                    Divider()

                    informationRow(
                        title:
                            "Current depth − critical depth",
                        value:
                            numberFormatter.format(
                                result
                                    .depthDifference,
                                unit: "m"
                            )
                    )

                    informationRow(
                        title:
                            "Energy above minimum",
                        value:
                            numberFormatter.format(
                                result
                                    .energyAboveMinimum,
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
                .multilineTextAlignment(
                    .trailing
                )
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
            as CriticalDepthError {

            errorMessage =
                error.errorDescription
                ?? "The critical depth could not be calculated."
        } catch {
            errorMessage =
                error.localizedDescription
        }
    }

    private func makeInput() throws
        -> CriticalDepthInput {

        CriticalDepthInput(
            volumetricFlowRate:
                try parsePositive(
                    flowRateText,
                    fieldName:
                        "Volumetric Flow Rate"
                ),
            channelWidth:
                try parsePositive(
                    channelWidthText,
                    fieldName:
                        "Channel Width"
                ),
            currentFlowDepth:
                try parsePositive(
                    currentDepthText,
                    fieldName:
                        "Current Flow Depth"
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

    private func loadExample() {
        flowRateText = "6.6829"
        channelWidthText = "3"
        currentDepthText = "1.2"
        gravityText = "9.80665"

        clearResult()
    }

    private func resetInputs() {
        flowRateText = ""
        channelWidthText = ""
        currentDepthText = ""
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
        CriticalDepthView()
    }
}
