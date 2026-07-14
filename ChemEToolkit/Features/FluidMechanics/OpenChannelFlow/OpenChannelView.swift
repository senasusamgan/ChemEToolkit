import SwiftUI

struct OpenChannelView: View {

    @State
    private var channelWidthText = "3"

    @State
    private var flowDepthText = "1.2"

    @State
    private var bedSlopeText = "0.001"

    @State
    private var manningCoefficientText =
        "0.013"

    @State
    private var calculationResult:
        OpenChannelResult?

    @State
    private var errorMessage = ""

    private let engine =
        OpenChannelEngine()

    private let numberFormatter =
        NumberFormatterService.precise

    var body: some View {
        ScrollView {
            VStack(
                spacing: AppSpacing.xLarge
            ) {
                ModuleHeaderView(
                    symbolName: "water.waves",
                    title: "Open Channel Flow",
                    subtitle:
                        "Calculate rectangular channel discharge using Manning’s equation",
                    tint: .blue
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
            "Open Channel Flow"
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
                Text("Manning Equation")
                    .font(.headline)

                Text(
                    "Q = (1/n)ARₕ²ᐟ³S¹ᐟ²"
                )
                .font(
                    .system(
                        size: 24,
                        weight: .semibold
                    )
                )

                Text(
                    "A = by,  P = b + 2y,  Rₕ = A/P"
                )
                .font(
                    .system(
                        size: 18,
                        weight: .semibold
                    )
                )
                .multilineTextAlignment(.center)

                Text(
                    "This version models steady, uniform flow through a rectangular open channel."
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
            Text("Channel Geometry")
                .font(.headline)

            EngineeringInputField(
                title: "Channel Width",
                symbol: "b",
                unit: "m",
                placeholder: "Example: 3",
                text: $channelWidthText
            )

            EngineeringInputField(
                title: "Flow Depth",
                symbol: "y",
                unit: "m",
                placeholder:
                    "Example: 1.2",
                text: $flowDepthText
            )

            Divider()

            Text("Channel Properties")
                .font(.headline)

            EngineeringInputField(
                title: "Channel Bed Slope",
                symbol: "S",
                unit: "m/m",
                placeholder:
                    "Example: 0.001",
                text: $bedSlopeText
            )

            EngineeringInputField(
                title:
                    "Manning Roughness Coefficient",
                symbol: "n",
                unit: "",
                placeholder:
                    "Example: 0.013",
                text:
                    $manningCoefficientText
            )

            actionButtons

            PrimaryActionButton(
                title:
                    "Calculate Channel Flow",
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
        _ result: OpenChannelResult
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
                            "Average Velocity",
                        value:
                            numberFormatter.format(
                                result
                                    .averageVelocity
                            ),
                        unit: "m/s"
                    ),
                    CalculationResultDisplayItem(
                        label:
                            "Hydraulic Radius",
                        value:
                            numberFormatter.format(
                                result
                                    .hydraulicRadius
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
                            "Cross-sectional area",
                        value:
                            numberFormatter.format(
                                result
                                    .crossSectionalArea,
                                unit: "m²"
                            )
                    )

                    informationRow(
                        title:
                            "Wetted perimeter",
                        value:
                            numberFormatter.format(
                                result
                                    .wettedPerimeter,
                                unit: "m"
                            )
                    )

                    informationRow(
                        title:
                            "Flow rate per hour",
                        value:
                            numberFormatter.format(
                                result
                                    .volumetricFlowRatePerHour,
                                unit: "m³/h"
                            )
                    )

                    informationRow(
                        title:
                            "Manning coefficient",
                        value:
                            numberFormatter.format(
                                result
                                    .manningCoefficient
                            )
                    )

                    informationRow(
                        title:
                            "Channel slope",
                        value:
                            numberFormatter.format(
                                result.bedSlope,
                                unit: "m/m"
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
            as OpenChannelError {

            errorMessage =
                error.errorDescription
                ?? "The channel flow could not be calculated."
        } catch {
            errorMessage =
                error.localizedDescription
        }
    }

    private func makeInput() throws
        -> OpenChannelInput {

        OpenChannelInput(
            channelWidth:
                try parsePositive(
                    channelWidthText,
                    fieldName:
                        "Channel Width"
                ),
            flowDepth:
                try parsePositive(
                    flowDepthText,
                    fieldName:
                        "Flow Depth"
                ),
            bedSlope:
                try parsePositive(
                    bedSlopeText,
                    fieldName:
                        "Channel Bed Slope"
                ),
            manningCoefficient:
                try parsePositive(
                    manningCoefficientText,
                    fieldName:
                        "Manning Roughness Coefficient"
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
        channelWidthText = "3"
        flowDepthText = "1.2"
        bedSlopeText = "0.001"
        manningCoefficientText = "0.013"

        clearResult()
    }

    private func resetInputs() {
        channelWidthText = ""
        flowDepthText = ""
        bedSlopeText = ""
        manningCoefficientText = ""

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
        OpenChannelView()
    }
}
