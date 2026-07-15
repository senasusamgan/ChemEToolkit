import SwiftUI

struct DryingRateTimeView: View {
    @State
    private var drySolidMassInput = "100"

    @State
    private var dryingAreaInput = "10"

    @State
    private var constantFluxInput = "2"

    @State
    private var initialMoistureInput = "0.5"

    @State
    private var criticalMoistureInput = "0.2"

    @State
    private var equilibriumMoistureInput =
        "0.05"

    @State
    private var finalMoistureInput = "0.1"

    @State
    private var result:
        DryingRateTimeResult?

    @State
    private var errorMessage = ""

    private let engine =
        DryingRateTimeEngine()

    private let numberFormatter =
        NumberFormatterService.precise

    var body: some View {
        ScrollView {
            VStack(spacing: AppSpacing.xLarge) {
                ModuleHeaderView(
                    symbolName: "wind",
                    title: "Drying Rate & Time",
                    subtitle:
                        "Calculate constant-rate and linear falling-rate drying periods",
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
            "Drying Rate & Time"
        )
    }

    private var formulaCard: some View {
        CalculatorInfoCard(tint: .blue) {
            VStack(spacing: AppSpacing.small) {
                Text(
                    "Dry-Solid Moisture Basis"
                )
                .font(.headline)

                Text(
                    "tc = Ms(Xi − Xc)/(A Rc)"
                )
                .font(
                    .system(
                        size: 18,
                        weight: .semibold
                    )
                )
                .minimumScaleFactor(0.55)

                Text(
                    "tf = Ms(Xc − Xe)/(A Rc) ln[(Xc − Xe)/(Xf − Xe)]"
                )
                .font(
                    .system(
                        size: 16,
                        weight: .semibold
                    )
                )
                .minimumScaleFactor(0.45)
                .multilineTextAlignment(.center)

                Text(
                    """
                    The falling-rate curve is assumed linear from Rc at \
                    critical moisture to zero at equilibrium moisture. \
                    Shrinkage and internal temperature variation are neglected.
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
            Text("Drying Equipment and Rate")
                .font(.headline)

            EngineeringInputField(
                title: "Dry-Solid Mass",
                symbol: "Ms",
                unit: "kg dry solid",
                placeholder: "Example: 100",
                text: $drySolidMassInput
            )

            EngineeringInputField(
                title: "Drying Area",
                symbol: "A",
                unit: "m²",
                placeholder: "Example: 10",
                text: $dryingAreaInput
            )

            EngineeringInputField(
                title:
                    "Constant Drying Flux",
                symbol: "Rc",
                unit: "kg/(m²·h)",
                placeholder: "Example: 2",
                text: $constantFluxInput
            )

            Divider()

            Text(
                "Moisture Contents — kg water/kg dry solid"
            )
            .font(.headline)

            EngineeringInputField(
                title:
                    "Initial Moisture",
                symbol: "Xi",
                unit: "kg/kg dry",
                placeholder: "Example: 0.5",
                text: $initialMoistureInput
            )

            EngineeringInputField(
                title:
                    "Critical Moisture",
                symbol: "Xc",
                unit: "kg/kg dry",
                placeholder: "Example: 0.2",
                text: $criticalMoistureInput
            )

            EngineeringInputField(
                title:
                    "Equilibrium Moisture",
                symbol: "Xe",
                unit: "kg/kg dry",
                placeholder: "Example: 0.05",
                text:
                    $equilibriumMoistureInput
            )

            EngineeringInputField(
                title:
                    "Final Moisture",
                symbol: "Xf",
                unit: "kg/kg dry",
                placeholder: "Example: 0.1",
                text: $finalMoistureInput
            )

            MassTransferActionButtons(
                loadExample: loadExample,
                clear: resetInputs
            )

            PrimaryActionButton(
                title:
                    "Calculate Drying Time",
                systemImage: "wind",
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
            DryingRateTimeResult
    ) -> some View {
        VStack(spacing: AppSpacing.large) {
            CalculationResultCard(
                items: [
                    CalculationResultDisplayItem(
                        label:
                            "Constant-Rate Time",
                        value:
                            numberFormatter.format(
                                result.constantRateTime
                            ),
                        unit: "h"
                    ),
                    CalculationResultDisplayItem(
                        label:
                            "Falling-Rate Time",
                        value:
                            numberFormatter.format(
                                result.fallingRateTime
                            ),
                        unit: "h"
                    ),
                    CalculationResultDisplayItem(
                        label:
                            "Total Drying Time",
                        value:
                            numberFormatter.format(
                                result.totalDryingTime
                            ),
                        unit: "h"
                    ),
                    CalculationResultDisplayItem(
                        label:
                            "Removed Moisture",
                        value:
                            numberFormatter.format(
                                result
                                    .removedMoistureMass
                            ),
                        unit: "kg water"
                    ),
                    CalculationResultDisplayItem(
                        label:
                            "Average Drying Flux",
                        value:
                            numberFormatter.format(
                                result.averageDryingFlux
                            ),
                        unit: "kg/(m²·h)"
                    ),
                    CalculationResultDisplayItem(
                        label:
                            "Final Drying Flux",
                        value:
                            numberFormatter.format(
                                result.finalDryingFlux
                            ),
                        unit: "kg/(m²·h)"
                    ),
                    CalculationResultDisplayItem(
                        label:
                            "Constant-Rate ΔX",
                        value:
                            numberFormatter.format(
                                result
                                    .constantRateMoistureRemoved
                            ),
                        unit: "kg/kg dry"
                    ),
                    CalculationResultDisplayItem(
                        label:
                            "Falling-Rate ΔX",
                        value:
                            numberFormatter.format(
                                result
                                    .fallingRateMoistureRemoved
                            ),
                        unit: "kg/kg dry"
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
                        "Drying-Period Interpretation",
                        systemImage: "wind"
                    )
                    .font(.headline)

                    Divider()

                    Text(
                        result.periodDescription
                    )
                    .fontWeight(.semibold)

                    Text(result.modelName)
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
        -> DryingRateTimeInput {

        DryingRateTimeInput(
            drySolidMass:
                try InputValidator.parseNumber(
                    drySolidMassInput,
                    fieldName:
                        "dry-solid mass"
                ),
            dryingArea:
                try InputValidator.parseNumber(
                    dryingAreaInput,
                    fieldName:
                        "drying area"
                ),
            constantDryingFlux:
                try InputValidator.parseNumber(
                    constantFluxInput,
                    fieldName:
                        "constant drying flux"
                ),
            initialMoistureContent:
                try InputValidator.parseNumber(
                    initialMoistureInput,
                    fieldName:
                        "initial moisture content"
                ),
            criticalMoistureContent:
                try InputValidator.parseNumber(
                    criticalMoistureInput,
                    fieldName:
                        "critical moisture content"
                ),
            equilibriumMoistureContent:
                try InputValidator.parseNumber(
                    equilibriumMoistureInput,
                    fieldName:
                        "equilibrium moisture content"
                ),
            finalMoistureContent:
                try InputValidator.parseNumber(
                    finalMoistureInput,
                    fieldName:
                        "final moisture content"
                )
        )
    }

    private func loadExample() {
        drySolidMassInput = "100"
        dryingAreaInput = "10"
        constantFluxInput = "2"
        initialMoistureInput = "0.5"
        criticalMoistureInput = "0.2"
        equilibriumMoistureInput = "0.05"
        finalMoistureInput = "0.1"
        clearResult()
    }

    private func resetInputs() {
        drySolidMassInput = ""
        dryingAreaInput = ""
        constantFluxInput = ""
        initialMoistureInput = ""
        criticalMoistureInput = ""
        equilibriumMoistureInput = ""
        finalMoistureInput = ""
        clearResult()
    }

    private func clearResult() {
        result = nil
        errorMessage = ""
    }
}

#Preview {
    NavigationStack {
        DryingRateTimeView()
    }
}
