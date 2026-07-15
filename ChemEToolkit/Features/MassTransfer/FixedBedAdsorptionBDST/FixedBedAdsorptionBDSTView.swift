import SwiftUI

struct FixedBedAdsorptionBDSTView:
    View {

    @State
    private var bedDepthInput = "1"

    @State
    private var columnAreaInput =
        "0.5"

    @State
    private var superficialVelocityInput =
        "5"

    @State
    private var influentConcentrationInput =
        "0.1"

    @State
    private var breakthroughConcentrationInput =
        "0.005"

    @State
    private var bedCapacityInput = "20"

    @State
    private var kineticConstantInput = "2"

    @State
    private var result:
        FixedBedAdsorptionBDSTResult?

    @State
    private var errorMessage = ""

    private let engine =
        FixedBedAdsorptionBDSTEngine()

    private let numberFormatter =
        NumberFormatterService.precise

    var body: some View {
        ScrollView {
            VStack(spacing: AppSpacing.xLarge) {
                ModuleHeaderView(
                    symbolName:
                        "chart.line.uptrend.xyaxis",
                    title:
                        "Fixed-Bed Adsorption BDST",
                    subtitle:
                        "Estimate minimum bed depth and service time to breakthrough",
                    tint: .blue
                )

                formulaCard

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
            "Fixed-Bed Adsorption BDST"
        )
    }

    private var formulaCard: some View {
        CalculatorInfoCard(tint: .blue) {
            VStack(spacing: AppSpacing.small) {
                Text(
                    "Bed-Depth Service-Time Model"
                )
                .font(.headline)

                Text(
                    "tb = N0 Z/(C0 u) − [1/(ka C0)] ln(C0/Cb − 1)"
                )
                .font(
                    .system(
                        size: 16,
                        weight: .semibold
                    )
                )
                .minimumScaleFactor(0.4)
                .multilineTextAlignment(.center)

                Text(
                    """
                    N0 is usable bed capacity per bed volume and ka is \
                    the fitted kinetic coefficient. Use parameters measured \
                    for the same adsorbent–solute operating system.
                    """
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

    private var calculatorContent: some View {
        VStack(
            alignment: .leading,
            spacing: AppSpacing.large
        ) {
            Text("Column Geometry and Flow")
                .font(.headline)

            EngineeringInputField(
                title: "Bed Depth",
                symbol: "Z",
                unit: "m",
                placeholder: "Example: 1",
                text: $bedDepthInput
            )

            EngineeringInputField(
                title:
                    "Column Cross-Sectional Area",
                symbol: "A",
                unit: "m²",
                placeholder: "Example: 0.5",
                text: $columnAreaInput
            )

            EngineeringInputField(
                title:
                    "Superficial Velocity",
                symbol: "u",
                unit: "m/h",
                placeholder: "Example: 5",
                text:
                    $superficialVelocityInput
            )

            Divider()

            Text("Breakthrough Specification")
                .font(.headline)

            EngineeringInputField(
                title:
                    "Influent Concentration",
                symbol: "C0",
                unit: "kg/m³",
                placeholder: "Example: 0.1",
                text:
                    $influentConcentrationInput
            )

            EngineeringInputField(
                title:
                    "Breakthrough Concentration",
                symbol: "Cb",
                unit: "kg/m³",
                placeholder:
                    "Example: 0.005",
                text:
                    $breakthroughConcentrationInput
            )

            Divider()

            Text("Fitted BDST Parameters")
                .font(.headline)

            EngineeringInputField(
                title:
                    "Bed Capacity per Volume",
                symbol: "N0",
                unit: "kg/m³ bed",
                placeholder: "Example: 20",
                text: $bedCapacityInput
            )

            EngineeringInputField(
                title:
                    "Adsorption Rate Constant",
                symbol: "ka",
                unit: "m³/(kg·h)",
                placeholder: "Example: 2",
                text: $kineticConstantInput
            )

            CalculatorInfoCard(tint: .orange) {
                Label(
                    "The implemented breakthrough form requires 0 < Cb/C0 < 0.5.",
                    systemImage:
                        "exclamationmark.triangle.fill"
                )
                .foregroundStyle(.secondary)
            }

            MassTransferActionButtons(
                loadExample: loadExample,
                clear: resetInputs
            )

            PrimaryActionButton(
                title:
                    "Calculate Bed Service Time",
                systemImage:
                    "chart.line.uptrend.xyaxis",
                action: calculate
            )

            if let result {
                resultSection(result)
            }

            if !errorMessage.isEmpty {
                CalculationErrorCard(
                    message: errorMessage
                )
            }
        }
    }

    private func resultSection(
        _ result:
            FixedBedAdsorptionBDSTResult
    ) -> some View {
        VStack(spacing: AppSpacing.large) {
            CalculationResultCard(
                items: [
                    CalculationResultDisplayItem(
                        label:
                            "Breakthrough Ratio",
                        value:
                            numberFormatter.format(
                                result
                                    .breakthroughRatio
                            ),
                        unit: "Cb/C0"
                    ),
                    CalculationResultDisplayItem(
                        label:
                            "Minimum Bed Depth",
                        value:
                            numberFormatter.format(
                                result.minimumBedDepth
                            ),
                        unit: "m"
                    ),
                    CalculationResultDisplayItem(
                        label:
                            "Service Time to Breakthrough",
                        value:
                            numberFormatter.format(
                                result
                                    .serviceTimeToBreakthrough
                            ),
                        unit: "h"
                    ),
                    CalculationResultDisplayItem(
                        label:
                            "Bed-Depth Safety Margin",
                        value:
                            numberFormatter.format(
                                result
                                    .bedDepthSafetyMargin
                            ),
                        unit: "m"
                    ),
                    CalculationResultDisplayItem(
                        label:
                            "Volumetric Flow Rate",
                        value:
                            numberFormatter.format(
                                result
                                    .volumetricFlowRate
                            ),
                        unit: "m³/h"
                    ),
                    CalculationResultDisplayItem(
                        label: "Bed Volume",
                        value:
                            numberFormatter.format(
                                result.bedVolume
                            ),
                        unit: "m³"
                    ),
                    CalculationResultDisplayItem(
                        label:
                            "Bed Saturation Capacity",
                        value:
                            numberFormatter.format(
                                result
                                    .bedSaturationCapacity
                            ),
                        unit: "kg"
                    ),
                    CalculationResultDisplayItem(
                        label:
                            "Treated Fluid Volume",
                        value:
                            numberFormatter.format(
                                result
                                    .treatedFluidVolume
                            ),
                        unit: "m³"
                    ),
                    CalculationResultDisplayItem(
                        label:
                            "Nominal Influent Solute Throughput",
                        value:
                            numberFormatter.format(
                                result
                                    .nominalInfluentSoluteThroughput
                            ),
                        unit: "kg"
                    ),
                    CalculationResultDisplayItem(
                        label:
                            "Nominal Capacity Utilization",
                        value:
                            numberFormatter.format(
                                100
                                * result
                                    .nominalCapacityUtilization
                            ),
                        unit: "%"
                    )
                ],
                tint: .blue
            )

            CalculatorInfoCard(tint: .blue) {
                VStack(
                    alignment: .leading,
                    spacing: AppSpacing.small
                ) {
                    Label(
                        "BDST Validity",
                        systemImage:
                            "chart.line.uptrend.xyaxis"
                    )
                    .font(.headline)

                    Divider()

                    Text(result.modelName)
                        .fontWeight(.semibold)

                    Text(
                        result
                            .limitationDescription
                    )
                    .foregroundStyle(.secondary)
                }
            }
        }
    }

    private func calculate() {
        clearResult()

        do {
            result = try engine.calculate(
                try makeInput()
            )
        } catch {
            errorMessage =
                MassTransferViewSupport
                    .errorMessage(for: error)
        }
    }

    private func makeInput() throws
        -> FixedBedAdsorptionBDSTInput {

        FixedBedAdsorptionBDSTInput(
            bedDepth:
                try InputValidator.parseNumber(
                    bedDepthInput,
                    fieldName: "bed depth"
                ),
            columnCrossSectionalArea:
                try InputValidator.parseNumber(
                    columnAreaInput,
                    fieldName:
                        "column cross-sectional area"
                ),
            superficialVelocity:
                try InputValidator.parseNumber(
                    superficialVelocityInput,
                    fieldName:
                        "superficial velocity"
                ),
            influentConcentration:
                try InputValidator.parseNumber(
                    influentConcentrationInput,
                    fieldName:
                        "influent concentration"
                ),
            breakthroughConcentration:
                try InputValidator.parseNumber(
                    breakthroughConcentrationInput,
                    fieldName:
                        "breakthrough concentration"
                ),
            bedCapacityPerVolume:
                try InputValidator.parseNumber(
                    bedCapacityInput,
                    fieldName:
                        "bed capacity per volume"
                ),
            adsorptionRateConstant:
                try InputValidator.parseNumber(
                    kineticConstantInput,
                    fieldName:
                        "adsorption rate constant"
                )
        )
    }

    private func loadExample() {
        bedDepthInput = "1"
        columnAreaInput = "0.5"
        superficialVelocityInput = "5"
        influentConcentrationInput = "0.1"
        breakthroughConcentrationInput =
            "0.005"
        bedCapacityInput = "20"
        kineticConstantInput = "2"
        clearResult()
    }

    private func resetInputs() {
        bedDepthInput = ""
        columnAreaInput = ""
        superficialVelocityInput = ""
        influentConcentrationInput = ""
        breakthroughConcentrationInput = ""
        bedCapacityInput = ""
        kineticConstantInput = ""
        clearResult()
    }

    private func clearResult() {
        result = nil
        errorMessage = ""
    }
}

#Preview {
    NavigationStack {
        FixedBedAdsorptionBDSTView()
    }
}
